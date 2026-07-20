"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

export default function SignOutButton() {
  const router = useRouter();
  const supabase = createClient();
  const [busy, setBusy] = useState(false);

  const signOut = async () => {
    setBusy(true);
    await supabase.auth.signOut();
    router.replace("/login");
    router.refresh();
  };

  return (
    <button
      onClick={signOut}
      disabled={busy}
      className="w-full rounded-[var(--radius-pill)] border-2 py-3.5 font-800 transition-transform active:scale-[0.99] disabled:opacity-50"
      style={{ borderColor: "var(--danger)", color: "var(--danger)" }}
    >
      {busy ? "Signing out…" : "Sign out"}
    </button>
  );
}
