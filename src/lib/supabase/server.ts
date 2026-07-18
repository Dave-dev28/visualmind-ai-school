import { createServerClient } from "@supabase/ssr";
import { cookies } from "next/headers";

/**
 * Server Supabase client (server components, route handlers, server actions).
 * `cookies()` is async in Next 16. In a pure Server Component the cookie
 * `set` calls are no-ops (headers already sent) — that's expected; the proxy
 * refreshes the session, so the try/catch swallow is safe.
 */
export async function createClient() {
  const cookieStore = await cookies();

  return createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return cookieStore.getAll();
        },
        setAll(cookiesToSet) {
          try {
            cookiesToSet.forEach(({ name, value, options }) =>
              cookieStore.set(name, value, options),
            );
          } catch {
            // Called from a Server Component — safe to ignore; proxy handles refresh.
          }
        },
      },
    },
  );
}
