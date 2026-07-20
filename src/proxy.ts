import { type NextRequest } from "next/server";
import { updateSession } from "@/lib/supabase/proxy";

/** Next 16 Proxy (formerly Middleware) — runs Supabase session + seat gating. */
export async function proxy(request: NextRequest) {
  return updateSession(request);
}

export const config = {
  matcher: [
    /*
     * Run on all paths except static assets and the manifest/icons, so auth
     * cookies stay fresh and gating applies everywhere.
     */
    "/((?!_next/static|_next/image|favicon.ico|manifest.webmanifest|sw.js|apple-icon.png|.*\\.(?:svg|png|jpg|jpeg|gif|webp|ico)$).*)",
  ],
};
