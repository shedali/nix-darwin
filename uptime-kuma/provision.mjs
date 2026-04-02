#!/usr/bin/env node
/**
 * Uptime Kuma declarative monitor provisioner.
 * Reads monitors.json and syncs them to the running Uptime Kuma instance.
 *
 * Credentials sourced from 1Password:
 *   op item get "Uptime Kuma" --vault agents --field username
 *   op item get "Uptime Kuma" --vault agents --field password
 *
 * Run manually: node provision.mjs
 * Managed by: nix-darwin mini.nix (launchd agent uptime-kuma-provision)
 */

import { io } from "socket.io-client";
import { readFileSync } from "fs";
import { fileURLToPath } from "url";
import { dirname, join } from "path";
import { execSync } from "child_process";

const __dirname = dirname(fileURLToPath(import.meta.url));
const UPTIME_KUMA_URL = "http://localhost:3001";
const MONITORS_PATH = join(__dirname, "monitors.json");

function getCredentials() {
  try {
    const op = "/usr/local/bin/op";
    const username = execSync(
      `${op} item get "Uptime Kuma" --vault agents --field username --reveal`,
      { encoding: "utf8" }
    ).trim();
    const password = execSync(
      `${op} item get "Uptime Kuma" --vault agents --field password --reveal`,
      { encoding: "utf8" }
    ).trim();
    return { username, password };
  } catch {
    return {
      username: process.env.UPTIME_KUMA_USER ?? "admin",
      password: process.env.UPTIME_KUMA_PASS ?? "",
    };
  }
}

const targetMonitors = JSON.parse(readFileSync(MONITORS_PATH, "utf8"));

async function provision() {
  const { username, password } = getCredentials();

  const socket = io(UPTIME_KUMA_URL, {
    transports: ["websocket"],
    reconnection: false,
    timeout: 10000,
  });

  return new Promise((resolve, reject) => {
    const timeout = setTimeout(() => {
      socket.disconnect();
      reject(new Error("Timeout: Uptime Kuma not responding"));
    }, 20000);

    socket.on("connect_error", (err) => {
      clearTimeout(timeout);
      socket.disconnect();
      reject(new Error(`Connection failed: ${err.message}`));
    });

    socket.on("connect", () => {
      socket.emit("login", { username, password, token: "" }, (loginRes) => {
        if (!loginRes.ok) {
          clearTimeout(timeout);
          socket.disconnect();
          reject(new Error(`Login failed: ${loginRes.msg}`));
          return;
        }

        socket.emit("getMonitorList", (monitorList) => {
          const existing = Object.values(monitorList ?? {});
          const existingNames = new Set(existing.map((m) => m.name));

          console.log(`Existing monitors: ${existing.length}`);

          const toAdd = targetMonitors.filter((m) => !existingNames.has(m.name));

          if (toAdd.length === 0) {
            console.log("All monitors already provisioned, nothing to do.");
            clearTimeout(timeout);
            socket.disconnect();
            resolve();
            return;
          }

          console.log(`Adding ${toAdd.length} monitors...`);

          let done = 0;
          for (const monitor of toAdd) {
            socket.emit("add", monitor, (addRes) => {
              if (addRes.ok) {
                console.log(`  ✓ ${monitor.name}`);
              } else {
                console.error(`  ✗ ${monitor.name}: ${addRes.msg}`);
              }
              done++;
              if (done === toAdd.length) {
                clearTimeout(timeout);
                socket.disconnect();
                resolve();
              }
            });
          }
        });
      });
    });
  });
}

async function main() {
  const maxAttempts = 12; // ~2 minutes of retries
  const retryDelay = 10000;

  for (let i = 1; i <= maxAttempts; i++) {
    try {
      await provision();
      console.log("Provisioning complete.");
      process.exit(0);
    } catch (err) {
      console.error(`Attempt ${i}/${maxAttempts}: ${err.message}`);
      if (i < maxAttempts) {
        await new Promise((r) => setTimeout(r, retryDelay));
      }
    }
  }

  console.error("Provisioning failed after all retries.");
  process.exit(1);
}

main();
