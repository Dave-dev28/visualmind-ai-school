"use client";

import { useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

type Mode = "login" | "signup";

/**
 * Email + password auth (PRD §F1). Phone/Google are the eventual v1 methods;
 * email keeps the pilot moving today with zero external provider setup.
 */
export default function AuthForm({ mode }: { mode: Mode }) {
  const router = useRouter();
  const supabase = createClient();
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);

  const isSignup = mode === "signup";

  const submit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setBusy(true);
    try {
      if (isSignup) {
        const { error } = await supabase.auth.signUp({
          email,
          password,
          options: { data: { display_name: name } },
        });
        if (error) throw error;
      } else {
        const { error } = await supabase.auth.signInWithPassword({
          email,
          password,
        });
        if (error) throw error;
      }
      // Proxy decides where to land (seat gate or home) based on session.
      router.replace("/");
      router.refresh();
    } catch (err) {
      setError(err instanceof Error ? err.message : "Something went wrong.");
      setBusy(false);
    }
  };

  return (
    <main className="app-aura mx-auto flex min-h-dvh w-full max-w-md flex-col justify-center px-6 pb-10">
      <div className="mb-8">
        <p className="text-sm font-600 text-[var(--accent-strong)]">AI School</p>
        <h1 className="mt-1 text-3xl font-800 leading-tight">
          {isSignup ? "Let’s get you started." : "Welcome back."}
        </h1>
        <p className="mt-2 text-[var(--text-muted)]">
          {isSignup
            ? "Make your account, then enter the code you got after paying."
            : "Sign in to pick up where you left off."}
        </p>
      </div>

      <form onSubmit={submit} className="flex flex-col gap-3">
        {isSignup && (
          <Field
            label="Your name"
            value={name}
            onChange={setName}
            placeholder="e.g. Ada"
            autoComplete="name"
            required
          />
        )}
        <Field
          label="Email"
          type="email"
          value={email}
          onChange={setEmail}
          placeholder="you@example.com"
          autoComplete="email"
          required
        />
        <Field
          label="Password"
          type="password"
          value={password}
          onChange={setPassword}
          placeholder="At least 6 characters"
          autoComplete={isSignup ? "new-password" : "current-password"}
          required
        />

        {error && (
          <p className="rounded-[var(--radius-sm)] bg-[rgba(244,164,139,0.1)] px-3 py-2 text-sm font-600 text-[var(--danger)]">
            {error}
          </p>
        )}

        <button
          type="submit"
          disabled={busy}
          className="mt-2 rounded-[var(--radius-pill)] py-4 text-lg font-800 transition-transform active:scale-[0.99] disabled:opacity-50"
          style={{ background: "var(--accent)", color: "var(--accent-ink)" }}
        >
          {busy ? "One sec…" : isSignup ? "Create account" : "Sign in"}
        </button>
      </form>

      <p className="mt-6 text-center text-sm text-[var(--text-muted)]">
        {isSignup ? "Already have an account? " : "New here? "}
        <Link
          href={isSignup ? "/login" : "/signup"}
          className="font-700 text-[var(--accent-strong)]"
        >
          {isSignup ? "Sign in" : "Create one"}
        </Link>
      </p>
    </main>
  );
}

function Field({
  label,
  value,
  onChange,
  type = "text",
  ...rest
}: {
  label: string;
  value: string;
  onChange: (v: string) => void;
  type?: string;
  placeholder?: string;
  autoComplete?: string;
  required?: boolean;
}) {
  return (
    <label className="flex flex-col gap-1.5">
      <span className="text-sm font-700 text-[var(--text-muted)]">{label}</span>
      <input
        type={type}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        className="rounded-[var(--radius-md)] border border-[var(--border)] bg-[var(--surface)] px-4 py-3.5 text-base font-600 text-[var(--text)] outline-none transition-colors focus:border-[var(--accent)]"
        {...rest}
      />
    </label>
  );
}
