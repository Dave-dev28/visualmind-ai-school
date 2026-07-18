-- ════════════════════════════════════════════════════════════════════════════
-- AI School — Foundations module v3 ("learn → then do")
-- 5 lessons every student takes BEFORE choosing a path, + choose_track().
-- Run in Supabase Dashboard → SQL Editor → Run. Safe to re-run (idempotent).
--
-- v3: every interactive cluster is now preceded by a `read` THEORY beat —
-- students read and understand a subject first; interactions then check
-- understanding instead of forcing guesswork. Interactivity kept only where
-- it genuinely helps understanding.
--
-- Videos verified live on YouTube (2026-07-18, via oEmbed):
--   a0_lo_GDcFw  CrashCourse — What Is Artificial Intelligence? #1
--   NHFbAg2b54U  Nate Herk — 100 Years of Artificial Intelligence Explained
--   3wLqsRLvV-c  TED-Ed — The Turing test: Can a computer pass for a human?
--   R9OHn5ZF4Uo  CGP Grey — How Machines Learn
--   LPZh9BOjkQs  3Blue1Brown — Large Language Models explained briefly
-- ════════════════════════════════════════════════════════════════════════════

-- ─── choose_track ───────────────────────────────────────────────────────────
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
values ('basics-1', 'Foundations', 1, 'What is AI, really?', 14,
$json${
  "beats": [
    { "id": "b1", "type": "read",
      "prompt": "First, the idea.",
      "title": "AI is not magic — it's learning from examples",
      "image": { "src": "/media/l1-ai-around-you.png", "alt": "A phone surrounded by everyday AI features", "caption": "AI is already in your pocket." },
      "body": [
        "Most software works like a recipe: a programmer types exact rules, and the computer follows them step by step. A calculator, an alarm clock, a torchlight app — all recipes. They never change unless someone rewrites them.",
        "AI is different. Instead of typing rules, we show the computer thousands of examples and let it find the patterns by itself. Nobody wrote a rule for every scam message in the world — your spam filter studied millions of them and learned what a scam smells like.",
        "That's why AI can handle things nobody planned for: a new scam style, your face in bad light, your voice in a noisy bus. It learned the pattern, not a fixed list."
      ],
      "keyPoints": [
        "Normal software follows rules a programmer typed.",
        "AI learns patterns from many examples.",
        "Learning from examples lets it handle brand-new situations."
      ] },
    { "id": "b2", "type": "select",
      "prompt": "Now use that idea.",
      "question": "Which of these on your phone is using AI right now?",
      "options": [
        { "id": "o1", "label": "Face unlock", "explain": "True — but it's not the only one. Look again at the full list." },
        { "id": "o2", "label": "Google Maps picking a faster route", "explain": "True — but it's not the only one. Look again at the full list." },
        { "id": "o3", "label": "All of them — AI is already all around you", "explain": "Exactly. Face unlock, smart routes, voice notes to text, photo search — all of them learned from examples. This course makes you the one in control of that power." }
      ],
      "correct": "o3" },
    { "id": "b3", "type": "watch",
      "prompt": "Watch: what AI actually means (3 min).",
      "videoId": "a0_lo_GDcFw", "start": 30, "end": 225,
      "source": "CrashCourse — What Is Artificial Intelligence? #1" },
    { "id": "b4", "type": "read",
      "prompt": "One more piece of theory before you sort.",
      "title": "Rules break. Learning bends.",
      "image": { "src": "/media/l1-learns-vs-rules.png", "alt": "A robot studying photos versus gears following a checklist", "caption": "Recipe-followers vs pattern-learners." },
      "body": [
        "Why not just write better rules? Because the world keeps changing. The day scammers invent a new trick, a rule-based filter is blind — someone must notice, write a new rule, and update the app. Slow.",
        "A learning system just needs new examples. Feed it the new scams, and it adjusts itself. That's the deep reason AI took over: the world moves too fast for hand-written rules.",
        "So when you see an app do something clever with messy real-life input — faces, voices, traffic, handwriting — ask: did someone type rules for this, or did it learn? If it handles surprises, it learned."
      ],
      "keyPoints": [
        "Hand-written rules go stale the moment the world changes.",
        "Learners just need fresh examples to adapt."
      ] },
    { "id": "b5", "type": "drag_sort",
      "prompt": "Check yourself: which ones learn, and which just follow fixed rules?",
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
    { "id": "b6", "type": "lever",
      "prompt": "Theory said: AI learns from examples. So what happens as you give it MORE? Pull and see.",
      "minLabel": "10 photos", "maxLabel": "Millions",
      "states": [
        { "label": "10 photos", "description": "Confused. It unlocks for your brother too.", "image": "/media/l1-faces-10.png" },
        { "label": "1,000 photos", "description": "Sometimes right — struggles in bad light.", "image": "/media/l1-faces-1k.png" },
        { "label": "100,000 photos", "description": "Right most of the time. This is getting useful.", "image": "/media/l1-faces-100k.png" },
        { "label": "Millions of photos", "description": "Sharp — day, night, new haircut. But even now, never perfect. More examples = better AI.", "image": "/media/l1-faces-millions.png" }
      ],
      "target": 3 },
    { "id": "b7", "type": "type_answer",
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
values ('basics-2', 'Foundations', 2, 'Where AI came from', 16,
$json${
  "beats": [
    { "id": "b1", "type": "read",
      "prompt": "First, the story.",
      "title": "A 70-year-old dream",
      "image": { "src": "/media/l2-turing.png", "alt": "Alan Turing beside a 1950s room-sized computer", "caption": "1950: Alan Turing asks the question." },
      "body": [
        "AI feels brand new, but the dream is older than your parents. In 1950, a British mathematician named Alan Turing asked a famous question: can machines think? He even proposed a test — if you chat with something and can't tell it's a machine, does the difference matter?",
        "For seventy years, brilliant people chased that dream — and mostly hit a wall. The ideas were good, but the computers of their time were far too weak, like designing a jet engine in a world that only has bicycle parts.",
        "Knowing this story matters: it tells you today's AI boom isn't a random fad. It's a very old idea that finally got the machine it was waiting for."
      ],
      "keyPoints": [
        "The question \"can machines think?\" is from 1950 — Alan Turing.",
        "The ideas were old; the computers were too weak.",
        "Today's boom = old dream + finally-strong-enough machines."
      ] },
    { "id": "b2", "type": "watch",
      "prompt": "Watch: the whole story — 100 years of AI, up till today.",
      "videoId": "NHFbAg2b54U",
      "source": "Nate Herk — 100 Years of Artificial Intelligence Explained" },
    { "id": "b3", "type": "read",
      "prompt": "Let's organize what you just watched.",
      "title": "The three eras of AI",
      "image": { "src": "/media/l2-timeline.png", "alt": "A timeline in three eras: the spark, the struggle, the boom", "caption": "The spark → the struggle → the boom." },
      "body": [
        "The spark (1950s–60s): Turing's question, the first excited researchers, and ELIZA — the first chatbot, so simple it just reflected your words back, yet people poured their hearts out to it.",
        "The struggle (1970s–90s): promises kept outrunning reality, so funding collapsed — twice. These freezes are called the AI winters. Still, there were flashes of what was coming: in 1997, IBM's Deep Blue beat the world chess champion.",
        "The boom (2010s–now): computers finally got powerful enough (thanks to GPU chips) and the internet piled up mountains of examples to learn from. AlphaGo shocked the world, ChatGPT reached 100 million users in two months, and AI began making images and video."
      ],
      "keyPoints": [
        "Spark: Turing's question, ELIZA the first chatbot.",
        "Struggle: two \"AI winters\" — big promises, weak machines.",
        "Boom: strong chips + internet data made the dream real."
      ] },
    { "id": "b4", "type": "drag_sort",
      "prompt": "Place each moment in its era.",
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
values ('basics-3', 'Foundations', 3, 'How machines actually learn', 15,
$json${
  "beats": [
    { "id": "b1", "type": "read",
      "prompt": "First, the idea.",
      "title": "Machines learn like students, not like calculators",
      "image": { "src": "/media/l3-training-loop.png", "alt": "A loop: examples in, guess, score, adjust, repeat", "caption": "The training loop — round and round until it's good." },
      "body": [
        "Teaching a machine looks a lot like teaching a person. You need three ingredients: plenty of examples, honest feedback on mistakes, and many rounds of practice.",
        "Here's the loop. Show the machine an example — say, a photo of a banknote. It guesses: real or fake. You score the guess. Every wrong answer nudges its internal settings a tiny bit. Then the next example, and the next — thousands of rounds.",
        "The magic is what you DON'T give it: you never tell it what to look for. It discovers the patterns itself — the texture, the print quality, things even you might not notice. You bring examples, feedback and a goal; it builds its own understanding."
      ],
      "keyPoints": [
        "Training = examples + feedback + many rounds.",
        "You give it examples and scores — it finds the patterns itself.",
        "Every mistake nudges it slightly closer to good."
      ] },
    { "id": "b2", "type": "select",
      "prompt": "Apply it.",
      "image": { "src": "/media/l3-naira-notes.png", "alt": "Real and fake naira notes side by side under a magnifier", "caption": "Your mission: teach a machine to tell these apart." },
      "question": "You want AI to spot fake naira notes. What do you give it FIRST?",
      "options": [
        { "id": "o1", "label": "Thousands of real and fake notes, each labelled", "explain": "Yes — examples first, always. The machine studies them and finds the differences itself. No examples, no learning." },
        { "id": "o2", "label": "A list of rules about what fakes look like", "explain": "That's the old way — and it breaks the day counterfeiters change style. AI instead studies thousands of labelled examples and finds patterns itself." },
        { "id": "o3", "label": "A camera and a fast computer", "explain": "Tools help, but they're useless without the key ingredient: thousands of labelled examples of real and fake notes to learn from." }
      ],
      "correct": "o1" },
    { "id": "b3", "type": "watch",
      "prompt": "Watch: how machines teach themselves (4 min).",
      "videoId": "R9OHn5ZF4Uo", "end": 240,
      "source": "CGP Grey — How Machines Learn" },
    { "id": "b4", "type": "drag_sort",
      "prompt": "From the theory and the video: in training, who brings what?",
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
    { "id": "b5", "type": "read",
      "prompt": "One trap every AI builder must know.",
      "title": "The memorization trap",
      "body": [
        "Here's a student you probably know: they memorized last year's exam questions perfectly — and failed the real exam, because the questions changed. Machines fall into the exact same trap.",
        "If you train too hard on too few examples, the machine stops learning the general pattern and starts memorizing the exact answers. It looks brilliant on its training examples — 99% correct! — then falls apart on anything new. Engineers call this overfitting.",
        "The test of real learning is always the same, for machines and people: can you handle something you've never seen before? That's why AI builders always keep some examples hidden during training, just to test with later."
      ],
      "keyPoints": [
        "Memorizing training examples ≠ learning the pattern.",
        "Great scores on training data can hide total failure on new data.",
        "Real learning = handling things never seen before."
      ] },
    { "id": "b6", "type": "lever",
      "prompt": "Watch the trap happen: pull the lever to train the fake-note spotter more and more.",
      "minLabel": "No training", "maxLabel": "Over-trained",
      "states": [
        { "label": "0 rounds", "description": "Pure guessing. 50/50 — a coin toss.", "image": "/media/l3-train-0.png" },
        { "label": "Some training", "description": "Rough guesses. Catches obvious fakes only.", "image": "/media/l3-train-some.png" },
        { "label": "Well trained", "description": "Solid. It learned the general patterns — catches fakes it has never seen. This is the goal.", "image": "/media/l3-train-good.png" },
        { "label": "Over-trained on few examples", "description": "The trap! It memorized the training notes — new fakes walk right past it.", "image": "/media/l3-train-overfit.png" }
      ],
      "target": 2 },
    { "id": "b7", "type": "type_answer",
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
values ('basics-4', 'Foundations', 4, 'Meet the LLM — the brain behind ChatGPT', 15,
$json${
  "beats": [
    { "id": "b1", "type": "read",
      "prompt": "First, the trick.",
      "title": "The trick behind ChatGPT: predict the next word",
      "image": { "src": "/media/l4-next-word.png", "alt": "A sentence being continued word by word, with candidate next words glowing", "caption": "One word at a time. Really." },
      "body": [
        "When ChatGPT writes you a beautiful paragraph, it's doing something surprisingly simple: predicting the next word. Then the next. Then the next — very fast, thousands of times, until an answer forms.",
        "How can word-guessing be so smart? Scale. An LLM — Large Language Model — was trained on mountains of human writing: books, articles, conversations, code. To predict the next word well in ALL of that, it had to absorb grammar, facts, styles, even reasoning patterns.",
        "Yesterday you learned how machines train: examples, feedback, adjustment. An LLM is exactly that — the examples were nearly everything humans have written, and the game was \"guess the next word.\" Simple game, played at planetary scale."
      ],
      "keyPoints": [
        "LLM = Large Language Model.",
        "It writes by predicting the next word, over and over.",
        "It learned from mountains of human text — same training loop you already know."
      ] },
    { "id": "b2", "type": "select",
      "prompt": "Check the idea.",
      "question": "When ChatGPT writes you a long answer, what is it actually doing?",
      "options": [
        { "id": "o1", "label": "Predicting the next word, again and again, very fast", "explain": "That's really it. One word at a time, each chosen from patterns in nearly everything humans have written. Simple trick, massive scale." },
        { "id": "o2", "label": "Searching the internet and copying answers", "explain": "Surprisingly, no — the base model isn't Googling. It's predicting the next word, again and again, from patterns it learned during training." },
        { "id": "o3", "label": "Thinking about your question like a person", "explain": "It can look that way! But underneath it's doing something simpler: predicting the next word, over and over. Knowing this explains both its power and its mistakes." }
      ],
      "correct": "o1" },
    { "id": "b3", "type": "watch",
      "prompt": "Watch: LLMs explained simply (3 min).",
      "videoId": "LPZh9BOjkQs", "end": 200,
      "source": "3Blue1Brown — Large Language Models explained briefly" },
    { "id": "b4", "type": "read",
      "prompt": "Two things every LLM user must know.",
      "title": "The creativity dial — and the honesty problem",
      "body": [
        "First: LLMs have a setting called temperature — think of it as a creativity dial. Low temperature: safe, predictable words, great for facts and instructions. High temperature: surprising, colorful words, great for stories — but push it too far and it starts inventing nonsense.",
        "Second, and more important: an LLM predicts words that SOUND likely. It does not check whether they're TRUE. So it can tell you something completely wrong in a perfectly confident tone — a made-up date, a fake book title, a wrong dosage. People call these hallucinations.",
        "This isn't a reason to avoid AI — it's a reason to use it like a professional: enjoy the speed, then verify anything important somewhere trusted. And when you ask, give it a clear brief — who it's for, what format you want, one example — the same way you'd brief a human assistant. Clear brief in, good work out."
      ],
      "keyPoints": [
        "Temperature = the creativity dial. Low for facts, medium for creative work.",
        "\"Sounds right\" is not \"is right\" — LLMs don't check facts.",
        "Prompting = briefing. Clear brief in, good work out."
      ] },
    { "id": "b5", "type": "lever",
      "prompt": "Try the creativity dial yourself — same request, different temperature.",
      "minLabel": "Safe", "maxLabel": "Wild",
      "states": [
        { "label": "Zero", "description": "\"Lagos is a city in Nigeria.\" Correct, robotic, same answer every time.", "image": "/media/l4-temp-0.png" },
        { "label": "Low", "description": "Clear and focused. Great for facts, code and instructions.", "image": "/media/l4-temp-low.png" },
        { "label": "Medium", "description": "Natural, with some flair. Great for stories, captions and ideas — the sweet spot for creative work.", "image": "/media/l4-temp-med.png" },
        { "label": "Maximum", "description": "\"Lagos, that golden octopus of dreams…\" Fun, but it starts inventing things. Wild isn't always wise.", "image": "/media/l4-temp-max.png" }
      ],
      "target": 2 },
    { "id": "b6", "type": "drag_sort",
      "prompt": "You read that prompting = briefing. Sort these habits.",
      "image": { "src": "/media/l4-prompting.png", "alt": "A person giving a clear brief versus a person shrugging vaguely", "caption": "Brief the AI like you'd brief a person." },
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
    { "id": "b7", "type": "select",
      "prompt": "And the honesty problem — make sure it stuck.",
      "image": { "src": "/media/l4-confident-wrong.png", "alt": "A cheerful robot confidently presenting a nonsense chart", "caption": "Confidence is not correctness." },
      "question": "Why can an LLM confidently tell you something that's completely wrong?",
      "options": [
        { "id": "o1", "label": "It predicts likely-sounding words — it doesn't check facts", "explain": "This is the key insight. \"Sounds right\" and \"is right\" are different things. Enjoy the power, verify important facts — that's the pro habit." },
        { "id": "o2", "label": "Someone programmed it to lie sometimes", "explain": "Nobody programmed lies — it's simpler: the model predicts words that sound likely, and likely-sounding isn't the same as true." },
        { "id": "o3", "label": "Its internet connection is unstable", "explain": "Not connection — the base model isn't looking things up at all. It predicts likely-sounding words, and likely-sounding isn't always true." }
      ],
      "correct": "o1" },
    { "id": "b8", "type": "type_answer",
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

-- ─── Lesson 5 — Your AI toolbox ─────────────────────────────────────────────
insert into public.lessons (id, track, day, title, minutes, content, published)
values ('basics-5', 'Foundations', 5, 'Your AI toolbox — what AI can make today', 13,
$json${
  "beats": [
    { "id": "b1", "type": "read",
      "prompt": "You know what AI is. Now — what can it make?",
      "title": "The toolbox: words, pictures, video, voice, software",
      "image": { "src": "/media/l5-toolbox.png", "alt": "An open toolbox glowing with icons for words, images, video, voice and code", "caption": "Every tool in here is one you can learn to direct." },
      "body": [
        "Today's AI splits into a few big tool families. Chatbots (LLMs) handle words: captions, emails, scripts, summaries, ideas. Image and video generators turn descriptions into pictures and moving clips. Voice AI clones and creates speech. And AI coding tools turn plain English into working software.",
        "Here's what matters for you: real people earn real money with every one of these, today — social media managers, ad creators, app builders, video makers. The tools are not the hard part anymore. Knowing how to direct them is.",
        "The two paths in this school are built on exactly these families: AI Video & Cinema lives on the image, video and voice tools; Build Apps with AI lives on LLMs and coding tools. Everything you've learned this week powers both."
      ],
      "keyPoints": [
        "Tool families: words (LLMs), images & video, voice, code.",
        "People earn with every one of these today.",
        "The skill that pays is directing the tools — that's what you're here to learn."
      ] },
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
    { "id": "b3", "type": "read",
      "prompt": "The most important idea in this whole week.",
      "title": "Be the director, not the passenger",
      "body": [
        "There are three ways people work with AI. Some ignore it and do everything by hand — honest, but slow, and they're now competing with people who have an engine. Others go full autopilot: AI does everything, they just post it. Fast — but the results are generic, and they build no skill anyone would pay for.",
        "The winners sit in the middle: they DIRECT. They bring the idea, the taste, the judgment of what's good — and let AI bring the speed. A director doesn't hold the camera, but nothing gets made without their vision.",
        "That's the person this school trains you to be. And one director's habit above all: AI output is a draft, not a verdict. When something important comes out — a fact, a price, a dosage — verify it somewhere trusted before you act on it. You learned why yesterday."
      ],
      "keyPoints": [
        "Autopilot makes generic slop; directing makes valuable work.",
        "You bring taste and judgment — AI brings speed.",
        "AI output is a draft. Verify important facts before acting."
      ] },
    { "id": "b4", "type": "lever",
      "prompt": "See the difference — pull across the three ways people work with AI.",
      "minLabel": "No AI", "maxLabel": "Full autopilot",
      "states": [
        { "label": "Everything by hand", "description": "Honest work, but slow — and you're competing with people who have an engine.", "image": "/media/l5-lever-diy.png" },
        { "label": "AI as your assistant", "description": "You think, it drafts. Faster, but you're still doing most of the lifting.", "image": "/media/l5-lever-assist.png" },
        { "label": "You direct, AI produces", "description": "The sweet spot. Taste + judgment from you, speed from AI. This is what this school trains.", "image": "/media/l5-lever-director.png" },
        { "label": "Full autopilot", "description": "AI does everything, you just post it. Fast — but generic, and you learned nothing anyone would pay for.", "image": "/media/l5-lever-autopilot.png" }
      ],
      "target": 2 },
    { "id": "b5", "type": "select",
      "prompt": "The director's habit — make sure it stuck.",
      "question": "An AI chatbot tells you a medicine dose, a legal rule, or an exam date. What do you do?",
      "options": [
        { "id": "o1", "label": "Verify it somewhere trusted before acting on it", "explain": "Always. LLMs predict likely-sounding words — they don't check facts. Use AI for speed, use your judgment for truth." },
        { "id": "o2", "label": "Trust it — AI is smarter than people", "explain": "Careful! Remember: LLMs predict likely-sounding words — they don't check facts. For anything important, verify somewhere trusted first." },
        { "id": "o3", "label": "Never use AI for anything serious", "explain": "Too far the other way — AI is a great starting point even for serious topics. The pro habit: use it for speed, then verify." }
      ],
      "correct": "o1" },
    { "id": "b6", "type": "type_answer",
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
