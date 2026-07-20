import { createServerClient } from "@supabase/ssr";
import { NextResponse, type NextRequest } from "next/server";

/**
 * Refreshes the Supabase session on every request and gates the app behind
 * auth. Next 16 calls this layer "Proxy" (formerly Middleware).
 *
 * Rules:
 *  - Not signed in → allowed only on /login and /signup; else → /login.
 *  - Signed in but no claimed seat → forced to /seat (access-code gate),
 *    except when already there or signing out.
 *  - Signed in + seat claimed → full app.
 *  - /admin is exempt from the seat gate (an admin account may never redeem a
 *    student seat); the page itself checks the is_admin flag server-side.
 */
export async function updateSession(request: NextRequest) {
  let response = NextResponse.next({ request });

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return request.cookies.getAll();
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value }) =>
            request.cookies.set(name, value),
          );
          response = NextResponse.next({ request });
          cookiesToSet.forEach(({ name, value, options }) =>
            response.cookies.set(name, value, options),
          );
        },
      },
    },
  );

  // IMPORTANT: getUser() must run to refresh the token; don't add logic between
  // createServerClient and this call.
  const {
    data: { user },
  } = await supabase.auth.getUser();

  const path = request.nextUrl.pathname;
  const isAuthPage = path === "/login" || path === "/signup";
  const isSeatPage = path === "/seat";
  const isAdminPage = path === "/admin" || path.startsWith("/admin/");

  if (!user && !isAuthPage) {
    return redirectTo(request, "/login");
  }

  if (user && isAuthPage) {
    return redirectTo(request, "/");
  }

  if (user && !isAuthPage && !isAdminPage) {
    // Check whether this user has claimed a seat yet.
    const { data: profile } = await supabase
      .from("profiles")
      .select("seat_claimed")
      .eq("id", user.id)
      .maybeSingle();

    const claimed = profile?.seat_claimed === true;
    if (!claimed && !isSeatPage) {
      return redirectTo(request, "/seat");
    }
    if (claimed && isSeatPage) {
      return redirectTo(request, "/");
    }
  }

  return response;
}

function redirectTo(request: NextRequest, path: string) {
  const url = request.nextUrl.clone();
  url.pathname = path;
  return NextResponse.redirect(url);
}
