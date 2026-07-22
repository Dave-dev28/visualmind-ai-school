-- ════════════════════════════════════════════════════════════════════════════
-- AI School — "Build Apps with AI" track (7 lessons, matches the depth of
-- the AI Video & Cinema track). Closes the dead end: choose-path already
-- offers this track, but it had zero content until now.
-- Run in Supabase Dashboard → SQL Editor → Run. Safe to re-run (idempotent).
--
-- Arc: what an app actually is (+ the director mindset from basics-6,
-- reinforced) → breaking ideas into features/MVP → prompting for code →
-- testing what AI built → planning before you prompt → two platform-literacy
-- lessons (Replit, Lovable). Same learn-then-do rhythm as every other module;
-- all content uses only implemented beat types.
--
-- Videos verified live on YouTube (2026-07-22, via oEmbed):
--   YBdgATnK6fw  corbin — How To Write AI Coding Prompts For Beginners
--   Wwk14j_SAC4  GitHub — Software testing basics for beginners (with Copilot)
--   3c39Z7SW3b4  Learn Mode Lab — Replit Tutorial for Beginners (2026)
--   exXBN2WJSIA  Entrepreneur Nut — How to Build Your FIRST App With Lovable AI (2026)
-- ════════════════════════════════════════════════════════════════════════════

-- ─── Day 1 — What an app actually is ────────────────────────────────────────
insert into public.lessons (id, track, day, title, minutes, content, published)
values ('apps-1', 'Build Apps with AI', 1, 'What an app actually is', 13,
$json${
  "beats": [
    { "id": "b1", "type": "read",
      "prompt": "First, the idea.",
      "title": "Every app is just three ingredients",
      "image": { "src": "/media/l8-app-anatomy.jpg", "alt": "An app screen breaking apart into layers labelled screens, data, instructions", "caption": "WhatsApp, your bank app, a school app — same three ingredients, every time." },
      "body": [
        "An app is just three things, combined endlessly. Screens — what you see and tap. Data — the information it remembers, like your name, your orders, your saved photos. Instructions — what happens when you tap something (\"when tapped, save this, then show that\").",
        "That's genuinely it. WhatsApp, your bank app, a school attendance app — all built from the exact same three ingredients, just arranged differently.",
        "Before AI, turning a plain description of those three things into real, working software required years of learning a programming language. AI erased that translation step entirely. You describe the screens, the data, and the instructions in plain English — AI writes the actual code."
      ],
      "keyPoints": [
        "Every app = screens + data + instructions.",
        "AI is now the translator from plain English into working code."
      ] },
    { "id": "b2", "type": "select",
      "prompt": "Use the idea.",
      "question": "You're building an app where a tailor's customers can check their order status. Which piece is the DATA?",
      "options": [
        { "id": "o1", "label": "The button a customer taps to check status", "explain": "Close — but a button is part of the screen, and tapping it triggers an instruction. Data is the actual information being stored and shown." },
        { "id": "o2", "label": "The customer's name, fabric choice, and ready date, saved in the app", "explain": "Exactly. That's the information the app remembers and shows back — the data." },
        { "id": "o3", "label": "The background color of the screen", "explain": "That's just screen design — how it looks, not what it remembers or does." }
      ],
      "correct": "o2" },
    { "id": "b3", "type": "read",
      "prompt": "One more piece before you sort.",
      "title": "Same mindset as before: you're still the director",
      "body": [
        "Remember the mindset shift from earlier this week: AI executes, you direct. That rule doesn't change just because the subject is code instead of video. AI writes every single line — but it writes exactly what you pictured, or exactly what you vaguely gestured at.",
        "The friend test still applies here too. Before you open any AI coding tool, could you describe your app to a friend, screen by screen, clearly enough that they could sketch it on paper? If not, you're not ready to prompt yet — you're ready to think a little more first."
      ],
      "keyPoints": [
        "You are still the director — now directing code instead of a camera.",
        "Run the friend test before prompting an app, exactly like before prompting a video."
      ] },
    { "id": "b4", "type": "drag_sort",
      "prompt": "Sort each piece into what it actually is.",
      "items": [
        { "id": "i1", "label": "The login page" },
        { "id": "i2", "label": "A student's saved test score" },
        { "id": "i3", "label": "When the button is tapped, show the next question" },
        { "id": "i4", "label": "The home screen listing today's lesson" },
        { "id": "i5", "label": "A customer's phone number on file" },
        { "id": "i6", "label": "When payment succeeds, unlock the seat" }
      ],
      "buckets": [
        { "id": "screens", "label": "Screens" },
        { "id": "data", "label": "Data" },
        { "id": "instructions", "label": "Instructions" }
      ],
      "correct": { "i1": "screens", "i2": "data", "i3": "instructions", "i4": "screens", "i5": "data", "i6": "instructions" } },
    { "id": "b5", "type": "type_answer",
      "prompt": "Picture one small app you wish existed.",
      "question": "Think of one small app you wish existed for your own life or business. What screens would it need? One or two sentences.",
      "keywords": [],
      "minMatches": 0,
      "hint": "",
      "sampleAnswer": "" },
    { "id": "b6", "type": "select",
      "prompt": "Last check before tomorrow.",
      "question": "Which instruction to an AI coding tool gives you the most control over the result?",
      "options": [
        { "id": "o1", "label": "\"Build me an app\"", "explain": "Far too vague — AI has to guess every screen, every field, every behavior. Fog in, fog out." },
        { "id": "o2", "label": "\"Build a screen where a tailor can add a customer's name, phone number, and order date, then see all customers in a list sorted by order date\"", "explain": "Exactly. Specific screens, specific data, specific behavior — nothing left to guess." },
        { "id": "o3", "label": "\"Make it modern and nice\"", "explain": "That's a style wish, not a description of what the app does. Style matters, but it's not enough on its own." }
      ],
      "correct": "o2" }
  ],
  "tomorrow": "Day 2 — Breaking your app idea into small, buildable pieces."
}$json$::jsonb, true)
on conflict (id) do update set track = excluded.track, day = excluded.day,
  title = excluded.title, minutes = excluded.minutes,
  content = excluded.content, published = excluded.published;

-- ─── Day 2 — Breaking your idea into features ───────────────────────────────
insert into public.lessons (id, track, day, title, minutes, content, published)
values ('apps-2', 'Build Apps with AI', 2, 'Breaking your idea into features', 13,
$json${
  "beats": [
    { "id": "b1", "type": "read",
      "prompt": "First, the idea.",
      "title": "One giant idea will break you. Small pieces won't.",
      "body": [
        "Beginners often try to describe an entire app idea in one giant prompt: \"build me a full delivery app with riders, payments, chat, and live tracking.\" AI chokes on this the same way a person would — too many decisions at once, and nothing gets built well.",
        "The fix: break your idea into features — one small, complete thing the app can DO, fully working on its own. \"A customer can place an order\" is a feature. \"A rider can mark an order delivered\" is a different one. Build and test one feature before asking for the next.",
        "Think of a feature list like a grocery list for your app. You buy — build — one item at a time. Not the whole shop in one trip."
      ],
      "keyPoints": [
        "A feature = one thing the app fully does, on its own.",
        "Build one feature at a time, never the whole app in one prompt."
      ] },
    { "id": "b2", "type": "select",
      "prompt": "Use the idea.",
      "question": "You're building a simple savings app. Which is a properly-sized single feature to ask AI to build first?",
      "options": [
        { "id": "o1", "label": "The whole app, start to finish", "explain": "Too big — AI will guess at dozens of decisions at once and the result will be messy. Break it down first." },
        { "id": "o2", "label": "A screen where a user can add a savings goal with a name and a target amount", "explain": "Exactly the right size — one clear thing, fully working, that you can test before adding anything else." },
        { "id": "o3", "label": "\"Make it colorful\"", "explain": "That's a style note, not a feature at all — there's nothing here for the app to actually do." }
      ],
      "correct": "o2" },
    { "id": "b3", "type": "read",
      "prompt": "One more piece of theory before you sort.",
      "title": "The MVP — the smallest version worth building",
      "body": [
        "MVP stands for Minimum Viable Product — the smallest version of your app that still genuinely helps someone. Before dreaming up every feature you could ever want, ask: if I only had ONE feature, which single one would make someone say \"this is actually useful\"? Build that first. Everything else can wait.",
        "Real example: a tailor's order-tracking app doesn't need payments, chat, and delivery tracking on day one. It needs one thing — \"see all customer orders in one place instead of a lost notebook.\" That's the MVP. Ship that, then add more."
      ],
      "keyPoints": [
        "MVP = the smallest version that's still genuinely useful.",
        "Find your one must-have feature before building anything else."
      ] },
    { "id": "b4", "type": "drag_sort",
      "prompt": "For a school fees tracking app, sort each feature into when it should be built.",
      "items": [
        { "id": "i1", "label": "Add a student and their fee amount" },
        { "id": "i2", "label": "See a list of who has paid and who hasn't" },
        { "id": "i3", "label": "Send automatic WhatsApp reminders" },
        { "id": "i4", "label": "Let parents pay directly in the app" },
        { "id": "i5", "label": "Print a fee receipt" },
        { "id": "i6", "label": "Mark a student as paid" }
      ],
      "buckets": [
        { "id": "mvp", "label": "MVP — build first" },
        { "id": "later", "label": "Later" }
      ],
      "correct": { "i1": "mvp", "i2": "mvp", "i3": "later", "i4": "later", "i5": "later", "i6": "mvp" } },
    { "id": "b5", "type": "type_answer",
      "prompt": "Find your own MVP.",
      "question": "Take the app idea you pictured yesterday (or a new one). What's the ONE feature you'd build first — your MVP? One sentence.",
      "keywords": [],
      "minMatches": 0,
      "hint": "",
      "sampleAnswer": "" },
    { "id": "b6", "type": "select",
      "prompt": "Diagnose what went wrong.",
      "question": "You asked AI to \"build the whole savings app with goals, reminders, and a graph\" in one prompt. It gave you something that mostly doesn't work right. What happened?",
      "options": [
        { "id": "o1", "label": "AI just isn't good enough yet", "explain": "The tool isn't the problem here — the request was. Too many features in one prompt overwhelms even a great AI." },
        { "id": "o2", "label": "Too many features were asked for at once — break it into one feature per prompt", "explain": "Exactly right. Build and confirm one feature, then move to the next." },
        { "id": "o3", "label": "You should have used more technical words", "explain": "Technical vocabulary isn't the fix here — scope is. Break the request into smaller, complete pieces." }
      ],
      "correct": "o2" }
  ],
  "tomorrow": "Day 3 — Prompting for code: the same clarity rule, new subject."
}$json$::jsonb, true)
on conflict (id) do update set track = excluded.track, day = excluded.day,
  title = excluded.title, minutes = excluded.minutes,
  content = excluded.content, published = excluded.published;

-- ─── Day 3 — Prompting for code ─────────────────────────────────────────────
insert into public.lessons (id, track, day, title, minutes, content, published)
values ('apps-3', 'Build Apps with AI', 3, 'Prompting for code', 14,
$json${
  "beats": [
    { "id": "b1", "type": "read",
      "prompt": "First, the idea.",
      "title": "Same rule as always: clarity in, quality out",
      "body": [
        "You already know this rule. For code, vague looks like \"make a login page.\" Clear looks like: \"a login screen with an email field, a password field, a 'Log in' button, and a 'Forgot password?' link below it — dark background, bright accent color on the button.\"",
        "The extra ingredient for code specifically: describe what happens when things go RIGHT and WRONG. \"When login succeeds, go to the home screen. When it fails, show a message saying the email or password is wrong.\" AI coding tools do far better work when you describe both paths, not just the happy one."
      ],
      "keyPoints": [
        "Describe the screen AND what happens when it works AND when it fails.",
        "The happy path alone is an incomplete instruction."
      ] },
    { "id": "b2", "type": "watch",
      "prompt": "Watch: writing AI coding prompts that actually work (4 min).",
      "videoId": "YBdgATnK6fw", "end": 240,
      "source": "corbin — How To Write AI Coding Prompts For Beginners" },
    { "id": "b3", "type": "select",
      "prompt": "Diagnose the gap.",
      "question": "Your AI-built signup form shows no message when a customer forgets to fill in their phone number — it just silently fails. What's the likely cause?",
      "options": [
        { "id": "o1", "label": "AI coding tools can't handle forms well", "explain": "Forms are one of the most common things AI handles — the tool isn't the limit here." },
        { "id": "o2", "label": "The prompt probably only described the happy path, not what happens when something's missing", "explain": "Exactly. If you never told AI what should happen on a missing field, it had no instruction to follow for that case." },
        { "id": "o3", "label": "This always happens and can't be fixed", "explain": "It's very fixable — just describe the missing-field case explicitly in your next prompt." }
      ],
      "correct": "o2" },
    { "id": "b4", "type": "drag_sort",
      "prompt": "Sort each coding prompt by how much control it actually gives you.",
      "items": [
        { "id": "i1", "label": "\"make a signup form\"" },
        { "id": "i2", "label": "A signup form with name, email, password fields; on submit, check all fields are filled, then show \"Welcome!\" — if any field is empty, show \"Please fill in all fields\" in red" },
        { "id": "i3", "label": "\"make it look nice\"" },
        { "id": "i4", "label": "A product list screen showing item name, price, and a photo, sorted by price low to high, with a search box at the top" }
      ],
      "buckets": [
        { "id": "weak", "label": "Weak — AI is guessing" },
        { "id": "strong", "label": "Strong — nothing left to guess" }
      ],
      "correct": { "i1": "weak", "i2": "strong", "i3": "weak", "i4": "strong" } },
    { "id": "b5", "type": "lever",
      "prompt": "Pull the lever from a one-word prompt to a fully specified one and watch the result change.",
      "minLabel": "One word", "maxLabel": "Fully specified",
      "states": [
        { "label": "One word: \"login\"", "description": "AI has to guess everything — fields, behavior, look. Result: generic, often broken.", "image": "/media/l8-prompt-vague.jpg" },
        { "label": "A sentence: \"a login screen\"", "description": "Slightly better, still guessing on fields and behavior. Result: works, but not what you pictured.", "image": "/media/l8-prompt-some.jpg" },
        { "label": "Fields + happy path", "description": "Real structure now — fields named, success behavior described. Result: mostly matches your vision.", "image": "/media/l8-prompt-good.jpg" },
        { "label": "Fields + happy path + error path + style", "description": "Nothing left to guess. Result: matches your exact picture.", "image": "/media/l8-prompt-full.jpg" }
      ],
      "target": 3 },
    { "id": "b6", "type": "type_answer",
      "prompt": "Write a strong prompt of your own.",
      "question": "Write a strong prompt for one screen in the app you've been picturing. Describe the fields, what happens on success, and what happens on failure.",
      "keywords": [
        ["field", "fields", "button", "screen", "form"],
        ["success", "fail", "error", "when", "if"]
      ],
      "minMatches": 1,
      "hint": "Remember the ingredients: what's ON the screen, what happens when it works, what happens when it doesn't.",
      "sampleAnswer": "A screen with a name field and an amount field and a 'Save' button. When both fields are filled, save the entry and show 'Saved!'. If either field is empty, show 'Please fill in both fields' in red." }
  ],
  "tomorrow": "Day 4 — Testing what AI built (you don't need to code to catch bugs)."
}$json$::jsonb, true)
on conflict (id) do update set track = excluded.track, day = excluded.day,
  title = excluded.title, minutes = excluded.minutes,
  content = excluded.content, published = excluded.published;

-- ─── Day 4 — Testing what AI built ──────────────────────────────────────────
insert into public.lessons (id, track, day, title, minutes, content, published)
values ('apps-4', 'Build Apps with AI', 4, 'Testing what AI built', 14,
$json${
  "beats": [
    { "id": "b1", "type": "read",
      "prompt": "First, the idea.",
      "title": "AI can be confidently wrong — your job is to catch it",
      "body": [
        "Remember from the basics: AI predicts likely-sounding output, it doesn't guarantee correctness. Code is no different. AI can hand you something that LOOKS finished — a clean screen, nice colors — but quietly does the wrong thing underneath. A save button that doesn't actually save. A total that adds up wrong.",
        "You don't need to read a single line of code to test an app well. You need to click through it on purpose, like a suspicious customer — not a proud parent admiring their own work."
      ],
      "keyPoints": [
        "A finished-LOOKING app isn't the same as a working app.",
        "Test like a suspicious customer, not a proud parent."
      ] },
    { "id": "b2", "type": "watch",
      "prompt": "Watch: how testing actually works, simply explained (5 min).",
      "videoId": "Wwk14j_SAC4", "end": 300,
      "source": "GitHub — Software testing basics for beginners" },
    { "id": "b3", "type": "read",
      "prompt": "One more piece before you sort.",
      "title": "Three questions to ask on every single screen",
      "body": [
        "1) Does it do what I asked for the NORMAL case? Add a customer with a name and phone number — does it save and show up in the list? 2) What happens with the WEIRD case? Leave a field empty. Type letters where a number should go. Tap the button five times fast. 3) Does it survive leaving and coming back? Close the app, reopen it — is your data still there?",
        "Most beginners only ever test #1. That's exactly why apps that \"worked in the demo\" break the moment a real customer touches them."
      ],
      "keyPoints": [
        "Test the normal case, the weird case, and whether it survives being closed and reopened.",
        "The demo working once means almost nothing on its own."
      ] },
    { "id": "b4", "type": "drag_sort",
      "prompt": "Sort each test into which of the three questions it's actually checking.",
      "items": [
        { "id": "i1", "label": "Fill in the form correctly and tap Save" },
        { "id": "i2", "label": "Leave the phone number field empty and tap Save" },
        { "id": "i3", "label": "Close the app completely, then reopen it" },
        { "id": "i4", "label": "Type letters into a field meant for a price" },
        { "id": "i5", "label": "Add a customer, check they appear in the list" },
        { "id": "i6", "label": "Restart your phone and open the app again" }
      ],
      "buckets": [
        { "id": "normal", "label": "Normal case" },
        { "id": "weird", "label": "Weird case" },
        { "id": "survives", "label": "Survives close + reopen" }
      ],
      "correct": { "i1": "normal", "i2": "weird", "i3": "survives", "i4": "weird", "i5": "normal", "i6": "survives" } },
    { "id": "b5", "type": "select",
      "prompt": "Learn from the near-miss.",
      "question": "You tested your app once, it worked, and you excitedly showed a friend. They typed their name with an emoji in it and the app crashed. What should you have done first?",
      "options": [
        { "id": "o1", "label": "Nothing — this is rare and not worth testing", "explain": "Weird input is more common than it feels — emojis, extra-long names, blank fields all show up in real use." },
        { "id": "o2", "label": "Tried a few weird inputs yourself before showing anyone", "explain": "Exactly — a few minutes of trying to \"break\" your own app catches most of these before a customer ever does." },
        { "id": "o3", "label": "Blamed the AI coding tool", "explain": "Not the tool's fault here — this is exactly the weird-case testing this lesson is about. Test it yourself first." }
      ],
      "correct": "o2" },
    { "id": "b6", "type": "type_answer",
      "prompt": "Plan your own weird-case tests.",
      "question": "Pick one screen from the app you've been picturing. List two \"weird case\" tests you'd try on it before trusting it works.",
      "keywords": [],
      "minMatches": 0,
      "hint": "",
      "sampleAnswer": "" }
  ],
  "tomorrow": "Day 5 — Planning your app before you touch any AI tool."
}$json$::jsonb, true)
on conflict (id) do update set track = excluded.track, day = excluded.day,
  title = excluded.title, minutes = excluded.minutes,
  content = excluded.content, published = excluded.published;

-- ─── Day 5 — Planning your app ──────────────────────────────────────────────
insert into public.lessons (id, track, day, title, minutes, content, published)
values ('apps-5', 'Build Apps with AI', 5, 'Planning your app', 12,
$json${
  "beats": [
    { "id": "b1", "type": "read",
      "prompt": "First, the idea.",
      "title": "Ten minutes of planning saves ten prompts of confusion",
      "image": { "src": "/media/l8-planning.jpg", "alt": "Boxes representing app screens connected by arrows showing the user's path through them", "caption": "A plan is just three lists, sketched before you open any tool." },
      "body": [
        "Three simple lists turn a fuzzy app idea into something ready to prompt. A screen list — every screen the app needs, named plainly. A user flow — the order a person actually moves through those screens (Home → Add Customer → Customer List). A feature list, ranked MVP-first, from what you learned on Day 2.",
        "Real example: a tailor's app. Screens: Home, Add Customer, Customer List. Flow: open Home, tap Add Customer, fill the form, land back on Customer List and see it there. Features, MVP-first: 1) add a customer 2) see the list 3) (later) send reminders.",
        "That's it — three short lists, sketched on paper, before you ever open an AI tool. Everything from Day 3's strong prompts gets easier once you already know exactly what you're asking for."
      ],
      "keyPoints": [
        "Screen list + user flow + MVP-first feature list = a real plan.",
        "Sketch it on paper first — the prompting gets far easier once you know exactly what you want."
      ] },
    { "id": "b2", "type": "drag_sort",
      "prompt": "Sort each piece into which part of the plan it belongs to.",
      "items": [
        { "id": "i1", "label": "Home, Add Customer, Customer List" },
        { "id": "i2", "label": "Open Home → tap Add Customer → fill the form → land back on Customer List" },
        { "id": "i3", "label": "1) Add a customer 2) See the list 3) (later) Send reminders" }
      ],
      "buckets": [
        { "id": "screens", "label": "Screen list" },
        { "id": "flow", "label": "User flow" },
        { "id": "features", "label": "Feature list" }
      ],
      "correct": { "i1": "screens", "i2": "flow", "i3": "features" } },
    { "id": "b3", "type": "select",
      "prompt": "Use the idea.",
      "question": "Why plan before prompting, instead of just describing everything to AI in one long back-and-forth conversation?",
      "options": [
        { "id": "o1", "label": "Because AI can't handle long conversations", "explain": "AI handles long conversations fine — that's not actually the problem here." },
        { "id": "o2", "label": "Because a plan turns one big fuzzy idea into a clear list of small, promptable features", "explain": "Exactly — this is Day 2's breakdown and Day 3's clarity, done on paper first, before a single prompt is typed." },
        { "id": "o3", "label": "Planning isn't actually necessary if you're patient enough", "explain": "Patience doesn't replace clarity — a fuzzy idea stays fuzzy no matter how long you spend describing it without a plan." }
      ],
      "correct": "o2" },
    { "id": "b4", "type": "type_answer",
      "prompt": "Sketch your own plan.",
      "question": "Sketch your app's plan in words: what screens does it need, and in what order does a person move through them?",
      "keywords": [],
      "minMatches": 0,
      "hint": "",
      "sampleAnswer": "" },
    { "id": "b5", "type": "type_answer",
      "prompt": "Lock this in before tomorrow.",
      "question": "Finish this: before I open any AI app-building tool, I should first ___.",
      "keywords": [
        ["plan", "screens", "flow", "features", "list", "sketch"]
      ],
      "minMatches": 1,
      "hint": "What three things did this lesson say to figure out first?",
      "sampleAnswer": "Before I open any AI app-building tool, I should first list my screens, plan the order someone moves through them, and rank my features so I know which one to build first." }
  ],
  "tomorrow": "Day 6 — Meet Replit: build and ship, right in the browser."
}$json$::jsonb, true)
on conflict (id) do update set track = excluded.track, day = excluded.day,
  title = excluded.title, minutes = excluded.minutes,
  content = excluded.content, published = excluded.published;

-- ─── Day 6 — Meet Replit ─────────────────────────────────────────────────────
insert into public.lessons (id, track, day, title, minutes, content, published)
values ('apps-6', 'Build Apps with AI', 6, 'Meet Replit — build and ship in one place', 13,
$json${
  "beats": [
    { "id": "b1", "type": "read",
      "prompt": "First, the idea.",
      "title": "One browser tab: describe it, watch it build, share it",
      "image": { "src": "/media/l8-replit.jpg", "alt": "A browser-based app builder interface showing a chat panel next to a live app preview", "caption": "No installs. No setup. Just describe, watch, and share." },
      "body": [
        "Replit is a browser-based tool where you describe an app in plain English and an AI agent builds it live, right in front of you — no software to install, no setup. You watch your screens and features appear as you direct.",
        "Why this matters for a beginner: the moment something works, you can share a live link — no separate step to \"publish\" or \"deploy\" on some other platform. Everything from Day 1 through Day 5 — screens, features, MVP-first, strong prompts, testing — applies directly here."
      ],
      "keyPoints": [
        "Replit builds live in the browser as you describe features in plain English.",
        "A working feature becomes a shareable link almost immediately."
      ] },
    { "id": "b2", "type": "watch",
      "prompt": "Watch: using Replit as a total beginner (5 min).",
      "videoId": "3c39Z7SW3b4", "end": 300,
      "source": "Learn Mode Lab — Replit Tutorial for Beginners (2026)" },
    { "id": "b3", "type": "select",
      "prompt": "Use the idea.",
      "question": "Your Replit-built app looks right in the preview, but you haven't tested weird inputs yet. What should you do before sharing the link with anyone?",
      "options": [
        { "id": "o1", "label": "Share it — the preview looking right is enough", "explain": "Remember Day 4: looking right and working right are different things. Test it yourself first." },
        { "id": "o2", "label": "Run your normal-case, weird-case, and reopen tests from Day 4 first", "explain": "Exactly — everything you learned about testing applies the moment there's a real app in front of you, on any platform." },
        { "id": "o3", "label": "Ask a friend to test it instead of doing it yourself", "explain": "A second pair of eyes helps eventually, but you should catch the obvious weird-case breaks yourself first — it's faster and it's your job as director." }
      ],
      "correct": "o2" },
    { "id": "b4", "type": "drag_sort",
      "prompt": "Sort each Replit concept to what it's for.",
      "items": [
        { "id": "i1", "label": "Chatting with the AI agent to describe a new feature" },
        { "id": "i2", "label": "Watching your app update live as it's built" },
        { "id": "i3", "label": "Getting a link anyone can open to try your app" }
      ],
      "buckets": [
        { "id": "describe", "label": "Describing features" },
        { "id": "preview", "label": "Seeing it live" },
        { "id": "share", "label": "Sharing it" }
      ],
      "correct": { "i1": "describe", "i2": "preview", "i3": "share" } },
    { "id": "b5", "type": "type_answer",
      "prompt": "Make the idea yours.",
      "question": "What's the first feature you'd ask Replit's AI to build — your MVP from Day 2?",
      "keywords": [],
      "minMatches": 0,
      "hint": "",
      "sampleAnswer": "" }
  ],
  "tomorrow": "Day 7 — Meet Lovable: from idea to a polished, shareable app."
}$json$::jsonb, true)
on conflict (id) do update set track = excluded.track, day = excluded.day,
  title = excluded.title, minutes = excluded.minutes,
  content = excluded.content, published = excluded.published;

-- ─── Day 7 — Meet Lovable ────────────────────────────────────────────────────
insert into public.lessons (id, track, day, title, minutes, content, published)
values ('apps-7', 'Build Apps with AI', 7, 'Meet Lovable — from idea to shareable app', 13,
$json${
  "beats": [
    { "id": "b1", "type": "read",
      "prompt": "First, the idea.",
      "title": "A second tool, a different strength: polish",
      "image": { "src": "/media/l8-lovable.jpg", "alt": "A phone showing a polished finished app interface, glowing softly against a dark background", "caption": "Same director skills, a different crew — this one leans into a clean, business-ready look." },
      "body": [
        "Lovable is another AI app builder, similar in spirit to Replit — describe it, AI builds it — but it leans toward clean, business-ready visual design out of the box. This is exactly why Day 6 taught you a multi-platform mindset already familiar from the video track: no single tool is best at everything, and comparing is part of directing well.",
        "The habits carry over completely: MVP-first from Day 2, strong prompts with success and failure paths from Day 3, real testing from Day 4, and a plan sketched before you open the tool from Day 5. The tool changes. Your job as director doesn't."
      ],
      "keyPoints": [
        "Lovable leans toward polished, business-ready design.",
        "Every habit from this week — MVP, strong prompts, testing, planning — carries over to any tool you pick."
      ] },
    { "id": "b2", "type": "watch",
      "prompt": "Watch: building your first app with Lovable (5 min).",
      "videoId": "exXBN2WJSIA", "end": 300,
      "source": "Entrepreneur Nut — How to Build Your FIRST App With Lovable AI (2026)" },
    { "id": "b3", "type": "select",
      "prompt": "Use the idea.",
      "question": "You're building an app to pitch to a potential business partner tomorrow. Visual polish matters as much as function. Which habit from this week matters most right now?",
      "options": [
        { "id": "o1", "label": "Skip planning — just start prompting and hope for the best", "explain": "Skipping the plan (Day 5) is exactly how a rushed, unpolished-looking result happens under time pressure — the opposite of what you need here." },
        { "id": "o2", "label": "Write a strong, fully-specified prompt including the exact style and feel you want, from Day 3's habit", "explain": "Exactly — a clear, style-specific prompt is how you get a polished result on the first real attempt, especially under a deadline." },
        { "id": "o3", "label": "Build every possible feature so nothing looks missing", "explain": "That's the opposite of MVP thinking from Day 2 — more unfinished features looks worse than one polished, working one." }
      ],
      "correct": "o2" },
    { "id": "b4", "type": "drag_sort",
      "prompt": "Sort each habit to the day it came from.",
      "items": [
        { "id": "i1", "label": "Break the idea into one feature at a time, MVP first" },
        { "id": "i2", "label": "Describe fields, the success path, AND the failure path" },
        { "id": "i3", "label": "Test the normal case, the weird case, and reopening the app" },
        { "id": "i4", "label": "Sketch a screen list, user flow, and feature list on paper first" }
      ],
      "buckets": [
        { "id": "day2", "label": "Day 2 — Features & MVP" },
        { "id": "day3", "label": "Day 3 — Prompting" },
        { "id": "day4", "label": "Day 4 — Testing" },
        { "id": "day5", "label": "Day 5 — Planning" }
      ],
      "correct": { "i1": "day2", "i2": "day3", "i3": "day4", "i4": "day5" } },
    { "id": "b5", "type": "type_answer",
      "prompt": "Make the idea yours — last question of this track's basics.",
      "question": "You've finished the basics of building apps with AI. In your own words: what's the mindset that makes someone good at directing AI to build software?",
      "keywords": [
        ["clear", "vision", "picture", "vague", "plan"],
        ["direct", "director", "instruct", "guide"]
      ],
      "minMatches": 1,
      "hint": "Think back to the very first idea this whole week was built on — who's the thinker, and who's the executor?",
      "sampleAnswer": "The mindset is thinking like a director — having a clear picture of exactly what I want, breaking it into small pieces, and giving AI clear instructions instead of vague ones, then checking its work carefully instead of just trusting it." }
  ],
  "tomorrow": "You've built the skills. Now go build something real. 💻🚀"
}$json$::jsonb, true)
on conflict (id) do update set track = excluded.track, day = excluded.day,
  title = excluded.title, minutes = excluded.minutes,
  content = excluded.content, published = excluded.published;
