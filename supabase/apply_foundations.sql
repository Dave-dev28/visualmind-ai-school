-- ════════════════════════════════════════════════════════════════════════════
-- AI School — Foundations module v2 ("What every beginner should know")
-- 5 lessons every student takes BEFORE choosing a path, + choose_track().
-- Run in Supabase Dashboard → SQL Editor → Run. Safe to re-run (idempotent).
--
-- v2 adds: visual-narration image slots (files go in /public/media/ — lessons
-- work fine before the images exist), Nate Herk's 100-years-of-AI video in the
-- history class, and a new Lesson 5 (the AI toolbox + using AI wisely).
--
-- Videos verified live on YouTube (2026-07-18, via oEmbed):
--   a0_lo_GDcFw  CrashCourse — What Is Artificial Intelligence? #1
--   NHFbAg2b54U  Nate Herk — 100 Years of Artificial Intelligence Explained
--   3wLqsRLvV-c  TED-Ed — The Turing test: Can a computer pass for a human?
--   R9OHn5ZF4Uo  CGP Grey — How Machines Learn
--   LPZh9BOjkQs  3Blue1Brown — Large Language Models explained briefly
-- ════════════════════════════════════════════════════════════════════════════

-- ─── choose_track: student picks a path after finishing Foundations ─────────
create or replace function public.choose_track(p_track text)
returns text language plpgsql security definer set search_path = '' as $$
declare
  v_uid uuid := auth.uid();
begin
  if v_uid is null then return 'unauthenticated'; end if;
  if p_track not in ('AI Video & Cinema', 'Build Apps with AI') then
    return 'invalid';
  end if;
  update public.profiles
  set track = p_track
  where id = v_uid and seat_claimed;
  if not found then return 'no_seat'; end if;
  return 'ok';
end;
$$;

grant execute on function public.choose_track(text) to authenticated;

-- ─── Lesson 1 — What is AI, really? ─────────────────────────────────────────
insert into public.lessons (id, track, day, title, minutes, content, published)
values ('basics-1', 'Foundations', 1, 'What is AI, really?', 12,
$json${
  "beats": [
    { "id": "b1", "type": "select",
      "prompt": "Let's start with a prediction.",
      "image": { "src": "/media/l1-ai-around-you.png", "alt": "A phone surrounded by everyday AI features", "caption": "Look closely — how much of this is AI?" },
      "question": "Which of these on your phone is using AI right now?",
      "options": [
        { "id": "o1", "label": "Face unlock", "explain": "True — but it's not the only one. Look again at the full list." },
        { "id": "o2", "label": "Google Maps picking a faster route", "explain": "True — but it's not the only one. Look again at the full list." },
        { "id": "o3", "label": "All of them — AI is already all around you", "explain": "Exactly. Face unlock, smart routes, voice notes to text, photo search — AI is already in your daily life. This course just makes you the one in control of it." }
      ],
      "correct": "o3" },
    { "id": "b2", "type": "watch",
      "prompt": "Watch: what AI actually means (3 min).",
      "videoId": "a0_lo_GDcFw", "start": 30, "end": 225,
      "source": "CrashCourse — What Is Artificial Intelligence? #1" },
    { "id": "b3", "type": "drag_sort",
      "prompt": "Sort these: which ones learn, and which just follow fixed rules?",
      "image": { "src": "/media/l1-learns-vs-rules.png", "alt": "A robot studying photos versus gears following a checklist", "caption": "Two very different kinds of software." },
      "items": [
        { "id": "i1", "label": "Spam filter that catches new scam styles" },
        { "id": "i2", "label": "Calculator app" },
        { "id": "i3", "label": "Photo app that finds all pictures of your face" },
        { "id": "i4", "label": "Alarm clock" },
        { "id": "i5", "label": "WhatsApp voice note → text" },
        { "id": "i6", "label": "Torchlight app" }
      ],
      "buckets": [
        { "id": "ai", "label": "Learns (AI)" },
        { "id": "rules", "label": "Fixed rules" }
      ],
      "correct": { "i1": "ai", "i2": "rules", "i3": "ai", "i4": "rules", "i5": "ai", "i6": "rules" } },
    { "id": "b4", "type": "select",
      "prompt": "So what makes something AI?",
      "question": "What's the real difference between AI and normal software?",
      "options": [
        { "id": "o1", "label": "AI learned from examples; normal software follows rules someone typed", "explain": "That's the heart of it. Nobody wrote a rule for every possible scam message — the spam filter learned the pattern from millions of examples." },
        { "id": "o2", "label": "AI is newer and faster", "explain": "Speed isn't it — a calculator is instant but it's not AI. The difference is learning from examples instead of following typed-out rules." },
        { "id": "o3", "label": "AI runs on the internet", "explain": "Not quite — face unlock works in airplane mode. The difference is learning from examples instead of following typed-out rules." }
      ],
      "correct": "o1" },
    { "id": "b5", "type": "lever",
      "prompt": "You're training AI to recognize your face. Pull the lever to change how many example photos it learns from.",
      "minLabel": "10 photos", "maxLabel": "Millions",
      "states": [
        { "label": "10 photos", "description": "Confused. It unlocks for your brother too.", "image": "/media/l1-faces-10.png" },
        { "label": "1,000 photos", "description": "Sometimes right — struggles in bad light.", "image": "/media/l1-faces-1k.png" },
        { "label": "100,000 photos", "description": "Right most of the time. This is getting useful.", "image": "/media/l1-faces-100k.png" },
        { "label": "Millions of photos", "description": "Sharp — day, night, new haircut. But even now, never perfect. More examples = better AI.", "image": "/media/l1-faces-millions.png" }
      ],
      "target": 3 },
    { "id": "b6", "type": "type_answer",
      "prompt": "Last one — say it in your own words.",
      "question": "How is AI different from a calculator app? One or two sentences, your own words.",
      "keywords": [
        ["learn", "learns", "learned", "learnt", "train", "trained", "training", "example", "examples", "pattern", "patterns"],
        ["rule", "rules", "fixed", "programmed", "instruction", "instructions", "typed"]
      ],
      "minMatches": 1,
      "hint": "Think about it this way: who taught each of them — and how? One follows steps a programmer typed. The other studied examples.",
      "sampleAnswer": "A calculator follows fixed rules a programmer typed in. AI learned from many examples, so it can handle new things nobody wrote an exact rule for." }
  ],
  "tomorrow": "Day 2 — Where AI came from (100 years of the story)."
}$json$::jsonb, true)
on conflict (id) do update set track = excluded.track, day = excluded.day,
  title = excluded.title, minutes = excluded.minutes,
  content = excluded.content, published = excluded.published;

-- ─── Lesson 2 — Where AI came from ──────────────────────────────────────────
insert into public.lessons (id, track, day, title, minutes, content, published)
values ('basics-2', 'Foundations', 2, 'Where AI came from', 15,
$json${
  "beats": [
    { "id": "b1", "type": "select",
      "prompt": "Quick prediction first.",
      "image": { "src": "/media/l2-turing.png", "alt": "Alan Turing beside a 1950s room-sized computer", "caption": "The man who asked the question that started everything." },
      "question": "When did people start seriously asking \"can machines think?\"",
      "options": [
        { "id": "o1", "label": "The 1950s — before your parents were born", "explain": "Yes! Alan Turing asked it in 1950. AI is an old dream — what's new is that computers finally got strong enough to deliver it." },
        { "id": "o2", "label": "The 1990s, with the internet", "explain": "Earlier than that — Alan Turing asked \"can machines think?\" back in 1950. The internet came much later." },
        { "id": "o3", "label": "2022, when ChatGPT launched", "explain": "ChatGPT made AI famous, but the question is over 70 years old — Alan Turing asked it in 1950." }
      ],
      "correct": "o1" },
    { "id": "b2", "type": "watch",
      "prompt": "Watch: the whole story — 100 years of AI, up till today.",
      "videoId": "NHFbAg2b54U",
      "source": "Nate Herk — 100 Years of Artificial Intelligence Explained" },
    { "id": "b3", "type": "drag_sort",
      "prompt": "Now you've seen the story — put each moment in its era.",
      "image": { "src": "/media/l2-timeline.png", "alt": "A timeline in three eras: the spark, the struggle, the boom", "caption": "Three eras, one long dream." },
      "items": [
        { "id": "i1", "label": "Turing asks: can machines think?" },
        { "id": "i2", "label": "ELIZA — the first chatbot" },
        { "id": "i3", "label": "\"AI winters\" — money and hope dry up" },
        { "id": "i4", "label": "Deep Blue beats the world chess champion" },
        { "id": "i5", "label": "ChatGPT reaches 100 million users" },
        { "id": "i6", "label": "AI starts making images and videos" }
      ],
      "buckets": [
        { "id": "early", "label": "The spark (1950s–60s)" },
        { "id": "middle", "label": "The struggle (70s–90s)" },
        { "id": "boom", "label": "The boom (2010s–now)" }
      ],
      "correct": { "i1": "early", "i2": "early", "i3": "middle", "i4": "middle", "i5": "boom", "i6": "boom" } },
    { "id": "b4", "type": "select",
      "prompt": "About those \"AI winters\"…",
      "question": "AI progress froze for years — twice. Why?",
      "options": [
        { "id": "o1", "label": "The promises were too big and computers were too weak", "explain": "Exactly. The ideas were mostly right — the machines just couldn't keep up yet. When people saw the gap, funding disappeared." },
        { "id": "o2", "label": "People lost interest in the idea", "explain": "The dream never died — researchers kept at it. What failed was the hardware: computers were simply too weak for the promises being made." },
        { "id": "o3", "label": "Governments banned AI research", "explain": "No ban — funding dried up because results kept disappointing. The real blocker was weak computers, not laws." }
      ],
      "correct": "o1" },
    { "id": "b5", "type": "watch",
      "prompt": "Deeper dive: the test that started it all (4 min).",
      "videoId": "3wLqsRLvV-c",
      "source": "TED-Ed — The Turing test: Can a computer pass for a human?" },
    { "id": "b6", "type": "lever",
      "prompt": "Pull through the decades and watch what computers could handle.",
      "minLabel": "1950s", "maxLabel": "2020s",
      "states": [
        { "label": "1950s — room-sized computer", "description": "Can play tic-tac-toe. That's about it.", "image": "/media/l2-1950s.png" },
        { "label": "1990s — desktop PC", "description": "Strong enough to beat a chess champion — one narrow skill.", "image": "/media/l2-1990s.png" },
        { "label": "2010s — GPU clusters", "description": "Recognizes faces, photos and speech. AI quietly enters your phone.", "image": "/media/l2-2010s.png" },
        { "label": "2020s — data centres", "description": "Writes, chats, makes images and video. The 70-year-old dream finally has an engine.", "image": "/media/l2-2020s.png" }
      ],
      "target": 3 },
    { "id": "b7", "type": "type_answer",
      "prompt": "Your turn to explain.",
      "question": "The ideas behind AI are 70+ years old. Why is AI exploding NOW and not in 1990?",
      "keywords": [
        ["computer", "computers", "compute", "power", "powerful", "gpu", "gpus", "chip", "chips", "hardware", "faster", "stronger"],
        ["data", "internet", "examples", "information", "photos", "text"]
      ],
      "minMatches": 1,
      "hint": "Two things had to grow massively: the machines doing the learning, and the pile of examples to learn from.",
      "sampleAnswer": "The ideas were waiting for the machines. Today's computers are millions of times more powerful, and the internet gave AI mountains of examples to learn from — so what failed in 1990 finally works." }
  ],
  "tomorrow": "Day 3 — How machines actually learn (teacher bots and builder bots)."
}$json$::jsonb, true)
on conflict (id) do update set track = excluded.track, day = excluded.day,
  title = excluded.title, minutes = excluded.minutes,
  content = excluded.content, published = excluded.published;

-- ─── Lesson 3 — How machines actually learn ─────────────────────────────────
insert into public.lessons (id, track, day, title, minutes, content, published)
values ('basics-3', 'Foundations', 3, 'How machines actually learn', 13,
$json${
  "beats": [
    { "id": "b1", "type": "select",
      "prompt": "Think like a teacher for a second.",
      "image": { "src": "/media/l3-naira-notes.png", "alt": "Real and fake naira notes side by side under a magnifier", "caption": "Your mission: teach a machine to tell these apart." },
      "question": "You want AI to spot fake naira notes. What do you give it FIRST?",
      "options": [
        { "id": "o1", "label": "Thousands of real and fake notes, each labelled", "explain": "Yes — examples first, always. The machine studies them and finds the differences itself. No examples, no learning." },
        { "id": "o2", "label": "A list of rules about what fakes look like", "explain": "That's the old way — and it breaks the day counterfeiters change style. AI instead studies thousands of labelled examples and finds patterns itself." },
        { "id": "o3", "label": "A camera and a fast computer", "explain": "Tools help, but they're useless without the key ingredient: thousands of labelled examples of real and fake notes to learn from." }
      ],
      "correct": "o1" },
    { "id": "b2", "type": "watch",
      "prompt": "Watch: how machines teach themselves (4 min).",
      "videoId": "R9OHn5ZF4Uo", "end": 240,
      "source": "CGP Grey — How Machines Learn" },
    { "id": "b3", "type": "drag_sort",
      "prompt": "In training, who brings what? Sort each piece.",
      "image": { "src": "/media/l3-training-loop.png", "alt": "A loop: examples in, guess, score, adjust, repeat", "caption": "The training loop — round and round until it's good." },
      "items": [
        { "id": "i1", "label": "Thousands of labelled examples" },
        { "id": "i2", "label": "A score for right and wrong answers" },
        { "id": "i3", "label": "The goal to aim for" },
        { "id": "i4", "label": "The patterns hidden in the data" },
        { "id": "i5", "label": "Its own internal \"rules\"" }
      ],
      "buckets": [
        { "id": "you", "label": "You give it" },
        { "id": "machine", "label": "It figures out" }
      ],
      "correct": { "i1": "you", "i2": "you", "i3": "you", "i4": "machine", "i5": "machine" } },
    { "id": "b4", "type": "lever",
      "prompt": "Pull the lever to train the fake-note spotter more and more.",
      "minLabel": "No training", "maxLabel": "Over-trained",
      "states": [
        { "label": "0 rounds", "description": "Pure guessing. 50/50 — a coin toss.", "image": "/media/l3-train-0.png" },
        { "label": "Some training", "description": "Rough guesses. Catches obvious fakes only.", "image": "/media/l3-train-some.png" },
        { "label": "Well trained", "description": "Solid. It learned the general patterns — catches fakes it has never seen. This is the goal.", "image": "/media/l3-train-good.png" },
        { "label": "Over-trained on few examples", "description": "Trap! It memorized the training notes instead of learning patterns — new fakes walk right past it.", "image": "/media/l3-train-overfit.png" }
      ],
      "target": 2 },
    { "id": "b5", "type": "select",
      "prompt": "Now diagnose a broken AI.",
      "question": "Your AI scores 99% on training photos but fails badly on new photos. What happened?",
      "options": [
        { "id": "o1", "label": "It memorized the training photos instead of learning general patterns", "explain": "Exactly — like a student who memorized past questions but never understood the subject. Real learning must work on things it has never seen." },
        { "id": "o2", "label": "It needs a faster computer", "explain": "Speed isn't the issue — it already aced the training set. The problem is it memorized those exact photos instead of learning patterns that work on new ones." },
        { "id": "o3", "label": "New photos are impossible for AI", "explain": "New photos are the whole point! Handling things it has never seen is what learning means. This AI memorized instead of learning." }
      ],
      "correct": "o1" },
    { "id": "b6", "type": "type_answer",
      "prompt": "Teach it back — that's how you know you've got it.",
      "question": "Explain \"training an AI\" to a friend who knows nothing about tech. Two sentences.",
      "keywords": [
        ["example", "examples", "data", "photos", "notes", "pictures"],
        ["mistake", "mistakes", "wrong", "error", "errors", "feedback", "score", "corrected", "adjust", "adjusts"],
        ["pattern", "patterns", "learn", "learns", "improve", "improves", "better"]
      ],
      "minMatches": 2,
      "hint": "Three ingredients: lots of examples, feedback on mistakes, and getting better each round. Use any two.",
      "sampleAnswer": "You show the machine thousands of examples and score its guesses. Every mistake nudges it to adjust, and after many rounds it has found the patterns — so it can handle things it has never seen before." }
  ],
  "tomorrow": "Day 4 — Meet the LLM: the brain behind ChatGPT."
}$json$::jsonb, true)
on conflict (id) do update set track = excluded.track, day = excluded.day,
  title = excluded.title, minutes = excluded.minutes,
  content = excluded.content, published = excluded.published;

-- ─── Lesson 4 — Meet the LLM ────────────────────────────────────────────────
insert into public.lessons (id, track, day, title, minutes, content, published)
values ('basics-4', 'Foundations', 4, 'Meet the LLM — the brain behind ChatGPT', 13,
$json${
  "beats": [
    { "id": "b1", "type": "select",
      "prompt": "One more prediction — this one surprises people.",
      "image": { "src": "/media/l4-next-word.png", "alt": "A sentence being continued word by word, with candidate next words glowing", "caption": "One word at a time. Really." },
      "question": "When ChatGPT writes you a long answer, what is it actually doing?",
      "options": [
        { "id": "o1", "label": "Predicting the next word, again and again, very fast", "explain": "That's really it. One word at a time, each chosen from patterns in nearly everything humans have written. Simple trick, massive scale — that's an LLM (Large Language Model)." },
        { "id": "o2", "label": "Searching the internet and copying answers", "explain": "Surprisingly, no — the base model isn't Googling. It's predicting the next word, again and again, from patterns it learned during training." },
        { "id": "o3", "label": "Thinking about your question like a person", "explain": "It can look that way! But underneath it's doing something simpler: predicting the next word, over and over, from patterns in text. Knowing this explains both its power and its mistakes." }
      ],
      "correct": "o1" },
    { "id": "b2", "type": "watch",
      "prompt": "Watch: LLMs explained simply (3 min).",
      "videoId": "LPZh9BOjkQs", "end": 200,
      "source": "3Blue1Brown — Large Language Models explained briefly" },
    { "id": "b3", "type": "lever",
      "prompt": "LLMs have a creativity dial (called \"temperature\"). Pull it and watch the same request change.",
      "minLabel": "Safe", "maxLabel": "Wild",
      "states": [
        { "label": "Zero", "description": "\"Lagos is a city in Nigeria.\" Correct, robotic, same answer every time.", "image": "/media/l4-temp-0.png" },
        { "label": "Low", "description": "Clear and focused. Great for facts, code and instructions.", "image": "/media/l4-temp-low.png" },
        { "label": "Medium", "description": "Natural, with some flair. Great for stories, captions and ideas — the sweet spot for creative work.", "image": "/media/l4-temp-med.png" },
        { "label": "Maximum", "description": "\"Lagos, that golden octopus of dreams…\" Fun, but it starts inventing things. Wild isn't always wise.", "image": "/media/l4-temp-max.png" }
      ],
      "target": 2 },
    { "id": "b4", "type": "drag_sort",
      "prompt": "Talking to an LLM well is a skill called prompting. Sort these habits.",
      "image": { "src": "/media/l4-prompting.png", "alt": "A person giving a clear brief versus a person shrugging vaguely", "caption": "The clearer the brief, the better the work — same as with people." },
      "items": [
        { "id": "i1", "label": "Say who the answer is for" },
        { "id": "i2", "label": "Show an example of what you want" },
        { "id": "i3", "label": "Name the format — list, table, steps" },
        { "id": "i4", "label": "One vague word like \"business\"" },
        { "id": "i5", "label": "Expect it to read your mind" },
        { "id": "i6", "label": "Ask five different things at once" }
      ],
      "buckets": [
        { "id": "strong", "label": "Strong prompt" },
        { "id": "weak", "label": "Weak prompt" }
      ],
      "correct": { "i1": "strong", "i2": "strong", "i3": "strong", "i4": "weak", "i5": "weak", "i6": "weak" } },
    { "id": "b5", "type": "select",
      "prompt": "The most important thing to know about LLMs:",
      "image": { "src": "/media/l4-confident-wrong.png", "alt": "A cheerful robot confidently presenting a nonsense chart", "caption": "Confidence is not correctness." },
      "question": "Why can an LLM confidently tell you something that's completely wrong?",
      "options": [
        { "id": "o1", "label": "It predicts likely-sounding words — it doesn't check facts", "explain": "This is the key insight. \"Sounds right\" and \"is right\" are different things. Smart users enjoy the power but verify important facts — now you're one of them." },
        { "id": "o2", "label": "Someone programmed it to lie sometimes", "explain": "Nobody programmed lies — it's simpler: the model predicts words that sound likely, and likely-sounding isn't the same as true. So verify important facts." },
        { "id": "o3", "label": "Its internet connection is unstable", "explain": "Not connection — the base model isn't looking things up at all. It predicts likely-sounding words, and likely-sounding isn't always true. So verify important facts." }
      ],
      "correct": "o1" },
    { "id": "b6", "type": "type_answer",
      "prompt": "Make it yours.",
      "question": "What is an LLM, in your own words? Pretend you're telling your friend at a bus stop.",
      "keywords": [
        ["predict", "predicts", "predicting", "guess", "guesses", "next word", "one word", "word by word", "word at a time"],
        ["text", "words", "writing", "language", "books", "internet", "trained", "learned", "read"]
      ],
      "minMatches": 2,
      "hint": "Two pieces: what it learned from (mountains of text), and what it does with that (predicts the next word, over and over).",
      "sampleAnswer": "An LLM is a program that read mountains of human text and learned the patterns in it. When you ask it something, it predicts the next word again and again until an answer forms — powerful, but it sounds sure even when it's wrong." }
  ],
  "tomorrow": "Day 5 — Your AI toolbox: what AI can make today (and how to use it wisely)."
}$json$::jsonb, true)
on conflict (id) do update set track = excluded.track, day = excluded.day,
  title = excluded.title, minutes = excluded.minutes,
  content = excluded.content, published = excluded.published;

-- ─── Lesson 5 — Your AI toolbox (NEW) ───────────────────────────────────────
insert into public.lessons (id, track, day, title, minutes, content, published)
values ('basics-5', 'Foundations', 5, 'Your AI toolbox — what AI can make today', 11,
$json${
  "beats": [
    { "id": "b1", "type": "select",
      "prompt": "You know what AI is and how it learns. Now — what can it MAKE?",
      "image": { "src": "/media/l5-toolbox.png", "alt": "An open toolbox glowing with icons for words, images, video, voice and code", "caption": "Every tool in here is one you can learn to use." },
      "question": "Which of these can AI create today, well enough that people get paid for it?",
      "options": [
        { "id": "o1", "label": "Written content — captions, emails, scripts", "explain": "True — and it's only one item on the list. Look at the last option again." },
        { "id": "o2", "label": "Images, video clips and voiceovers", "explain": "True — and it's only part of the list. Look at the last option again." },
        { "id": "o3", "label": "All of these — plus working apps and websites", "explain": "Yes — words, images, video, voice AND software. Real people earn with each of these today. The two paths in this school are built on exactly these tools." }
      ],
      "correct": "o3" },
    { "id": "b2", "type": "drag_sort",
      "prompt": "Match the job to the right AI tool.",
      "items": [
        { "id": "i1", "label": "Write product captions for your shop" },
        { "id": "i2", "label": "Summarize a long document" },
        { "id": "i3", "label": "Make a product photo with no photoshoot" },
        { "id": "i4", "label": "Turn a photo into a moving ad clip" },
        { "id": "i5", "label": "Build a booking app for a salon" },
        { "id": "i6", "label": "Automate sending invoices" }
      ],
      "buckets": [
        { "id": "words", "label": "Chatbot (LLM)" },
        { "id": "visual", "label": "Image / video AI" },
        { "id": "code", "label": "AI coding tools" }
      ],
      "correct": { "i1": "words", "i2": "words", "i3": "visual", "i4": "visual", "i5": "code", "i6": "code" } },
    { "id": "b3", "type": "lever",
      "prompt": "The big question: how much should you let AI do? Pull the lever across the three ways people work.",
      "minLabel": "No AI", "maxLabel": "Full autopilot",
      "states": [
        { "label": "Everything by hand", "description": "Honest work, but slow — and you're competing with people who have an engine.", "image": "/media/l5-lever-diy.png" },
        { "label": "AI as your assistant", "description": "You think, it drafts. Faster, but you're still doing most of the lifting.", "image": "/media/l5-lever-assist.png" },
        { "label": "You direct, AI produces", "description": "The sweet spot. You bring taste, judgment and the idea — AI brings speed. This is what this school trains you to be: the director.", "image": "/media/l5-lever-director.png" },
        { "label": "Full autopilot", "description": "AI does everything, you just post it. Fast — but the results are generic, and you learned nothing anyone would pay for.", "image": "/media/l5-lever-autopilot.png" }
      ],
      "target": 2 },
    { "id": "b4", "type": "select",
      "prompt": "One habit separates pros from amateurs.",
      "question": "An AI chatbot tells you a medicine dose, a legal rule, or an exam date. What do you do?",
      "options": [
        { "id": "o1", "label": "Verify it somewhere trusted before acting on it", "explain": "Always. You learned why in the last class — LLMs predict likely-sounding words, they don't check facts. Use AI for speed, use your judgment for truth." },
        { "id": "o2", "label": "Trust it — AI is smarter than people", "explain": "Careful! Remember the last class: LLMs predict likely-sounding words — they don't check facts. For anything important, verify somewhere trusted first." },
        { "id": "o3", "label": "Never use AI for anything serious", "explain": "Too far the other way — AI is a great starting point even for serious topics. The pro habit is: use it for speed, then verify important facts somewhere trusted." }
      ],
      "correct": "o1" },
    { "id": "b5", "type": "type_answer",
      "prompt": "Last question of the basics — and there's no wrong answer.",
      "question": "Tomorrow you choose your path: making films with AI, or building apps with AI. Which one pulls you more — and why?",
      "keywords": [],
      "minMatches": 0,
      "hint": "",
      "sampleAnswer": "" }
  ],
  "tomorrow": "You finished the basics! Next — choose your path. 🎬💻"
}$json$::jsonb, true)
on conflict (id) do update set track = excluded.track, day = excluded.day,
  title = excluded.title, minutes = excluded.minutes,
  content = excluded.content, published = excluded.published;
