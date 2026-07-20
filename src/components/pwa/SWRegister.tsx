"use client";

import { useEffect } from "react";

/** Registers the service worker (production only) — makes the app installable
 * and enables the low-data caching in public/sw.js. */
export default function SWRegister() {
  useEffect(() => {
    if (
      process.env.NODE_ENV === "production" &&
      "serviceWorker" in navigator
    ) {
      navigator.serviceWorker.register("/sw.js").catch(() => {
        // Registration failing is non-fatal — the app still works online.
      });
    }
  }, []);
  return null;
}
