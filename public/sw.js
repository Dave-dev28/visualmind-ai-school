/* AI School service worker — installability + low-data caching (PRD §8).
 * Strategy:
 *  - Static assets (/_next/static, /icons, /media) → cache-first: immutable
 *    or rarely-changing, and media is the expensive part on mobile data.
 *  - Page navigations → network-first, honest offline message on failure
 *    (never serve stale lesson HTML).
 *  - Everything else (Supabase API, auth) → network only, untouched.
 */
const CACHE = "ai-school-v1";
const CACHEABLE = [/^\/_next\/static\//, /^\/icons\//, /^\/media\//];

self.addEventListener("install", () => {
  self.skipWaiting();
});

self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches
      .keys()
      .then((keys) =>
        Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k))),
      )
      .then(() => self.clients.claim()),
  );
});

self.addEventListener("fetch", (event) => {
  const { request } = event;
  if (request.method !== "GET") return;

  const url = new URL(request.url);
  if (url.origin !== self.location.origin) return; // Supabase etc: untouched

  if (CACHEABLE.some((re) => re.test(url.pathname))) {
    event.respondWith(
      caches.open(CACHE).then(async (cache) => {
        const hit = await cache.match(request);
        if (hit) return hit;
        const fresh = await fetch(request);
        if (fresh.ok) cache.put(request, fresh.clone());
        return fresh;
      }),
    );
    return;
  }

  if (request.mode === "navigate") {
    event.respondWith(
      fetch(request).catch(
        () =>
          new Response(
            `<!doctype html><html lang="en"><head><meta charset="utf-8">
             <meta name="viewport" content="width=device-width,initial-scale=1">
             <title>Offline — AI School</title>
             <style>body{margin:0;display:grid;place-items:center;min-height:100dvh;
             background:#17130f;color:#f5efe6;font-family:system-ui,sans-serif;text-align:center;padding:24px}
             .card{max-width:320px}h1{font-size:1.4rem}p{color:#b8ad9c;line-height:1.5}
             .dot{font-size:2.5rem}</style></head><body><div class="card">
             <div class="dot">📡</div><h1>This part needs internet</h1>
             <p>No shame — data comes and goes. Reconnect and pull down to refresh;
             your progress is saved.</p></div></body></html>`,
            { headers: { "Content-Type": "text/html; charset=utf-8" } },
          ),
      ),
    );
  }
});
