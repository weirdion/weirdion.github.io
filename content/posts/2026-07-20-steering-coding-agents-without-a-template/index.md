+++
title = "Steering Coding Agents Without a Template"
description = "How I reasoned my way from Kiro's spec-driven approach, AI-DLC, and vibe coding to a read-as-steering setup that fits a solo operator working across many repos."
summary = "A build-narrative on finding a way of working with coding agents that survives across repos and sessions — what I borrowed from spec-driven and steering methodologies, what I left behind, and why 'read it, don't clone it' beat a shared template."
date = 2026-07-20
categories = ["AI", "Coding Agents", "Developer Workflow", "Ways of Working"]
tags = ["claude-code", "coding-agents", "ai-workflow", "context-management", "agent-steering", "spec-driven", "kiro", "ai-dlc"]
feature = "featured.png"
layout = "simple"
draft = false
+++

**Disclaimer:** _This is a personal setup, not a recommendation for your team. I'll be honest about what I landed on, but the whole point of this post is that the right answer depends on your context — and mine (someone who jumps across a lot of repos) is probably not yours._

![AI generated image of a crossroads with a wooden signpost at the center pointing toward several floating code-editor windows, rendered in a flat slate, wood, and off-white palette — a visual for steering coding agents in different directions rather than down one prescribed path.](featured.png "AI generated image of a crossroads with a wooden signpost pointing toward several floating code-editor windows — steering coding agents rather than templating them.")

I keep a lot of repos. Work spans app code, shared libraries, and infrastructure; on the side there's a homelab, a couple of creative projects, and whatever I'm currently nerd-sniped by. On any given day I might touch five of them, and I do it with a coding agent riding shotgun these days.

The problem crept up on me slowly: I was re-explaining myself. Every new session, every compacted context, every repo I hadn't opened in a month — the agent would start cold, and I'd re-establish the same things. How I like commits. That decisions get logged, not re-litigated. That "done" means verified, not "the code compiles." It wasn't dramatic. It was a slow tax, paid a dozen times a day.

So I did what I usually do: I started building a system. And before I built it, I went and read what other people had already figured out. This post is the map of how I got from there to something that actually sticks — dead ends included, because the dead ends are where the reasoning lives.

# The Why 🤔

The thing I was actually fighting is **context rot**. Agent context is fragile in three specific ways, and each one bit me:

- **Compaction loses it.** A long session gets summarized, and the nuance you established in turn 10 is gone by turn 60.
- **Decisions get re-litigated.** Without a durable record, the agent happily re-opens a question you settled last week, and you re-argue it.
- **Deferrals vanish.** "We'll come back to that" lives in a commit message, and by next session it may as well not exist.

I'd been fighting this per-project for a while with a convention I'd drifted into — an agent-context directory in each repo holding the durable stuff. It worked. But it only worked because *I* kept it consistent, repo by repo, turn by turn. It was artisanal. And artisanal doesn't survive fifteen repos and a tech lead's day.

Here's the thing though: before I let myself build anything, I made myself go read the field. I've genuinely used and experimented with a few approaches, and each one taught me something about what I was actually looking for.

## The approaches I read (and mostly borrowed from)

### Kiro's spec-driven development

[Kiro](https://kiro.dev/) leans on a spec-first loop: you write the requirements and a design before the code, and the agent builds against them. Acceptance criteria up front, then implementation.

I want to be clear about this one, because it's easy to be dismissive and that would be wrong: **for most teams, I think this is the right approach.** When you've got multiple engineers and multiple agents pointed at the same codebase, a spec-first workflow enforces consistency and encodes the team's standards into something the agent can actually follow. That's real value. If you're leading a team and picking a methodology, spec-driven is a genuinely good default.

It just wasn't the right fit for *me*. Writing a formal spec per feature is friction I don't need on a personal project where I'm the only stakeholder and the "team standard" is whatever I decided this morning. I took the ordering lesson — *think about what "done" looks like before you start* — and left the ceremony. Not because the ceremony is bad. Because it's solving a coordination problem I don't have.

### AI-DLC and the phase-gated lifecycle

The "AI development lifecycle" framing — intent, plan, build, verify, with human checkpoints at each boundary — is a solid skeleton. It's basically the loop I already run: assess, plan, implement, verify, document.

What AI-DLC adds on top is ceremony and explicit human-in-the-loop gating. And again — that ceremony exists for a reason. It exists to *coordinate people*. Solo, most of it is overhead I'd be performing for an audience of one. So I kept the loop and skipped the gates, while quietly noting that if I were doing this with a team, the gates are exactly what I'd want.

### A colleague's rules repo

A colleague had built his own thing: a small set of canonical docs — principles, memory schema, behavioral rules — with tooling to install them into any repo. Reading it was the most useful hour I spent, because it showed me two things clearly.

The good: he'd factored out **behavioral corrections** I was re-typing by hand into every project. Things like *verify before you claim done*, *ask before choosing a strategy*, *no "you're absolutely right!"*. Naming those as reusable rules is smart, and I stole the idea outright.

The parts I left: he shipped generic engineering principles into *every* repo, regardless of whether they applied. That's cargo cult — rules nobody believes because they don't trace to anything real in that project. And some of the rules had enforced precision like cyclomatic complexity, and code health index. Rules that read authoritative but, at scale, measure nothing and tend to get lost. I adopted the behavioral corrections, rewrote them in my own voice, and dropped the metrics.

### And a word on pure vibe coding

I'll be blunt here, because I've got a technical opinion and this is my blog. **Pure vibe coding — just prompting your way forward with no structure, no verification, no durable context — is a bad idea for real engineering.** It's short-sighted almost by construction: it optimizes for the next five minutes and accumulates a mess you can't reason about.

The one place I'll allow it: an ad-hoc, one-off fix in a codebase you don't know and won't own. Even then — trust but verify, every time. The moment the thing you're building has to be maintained, "vibes" stops being a strategy and starts being a liability you've handed to future-you.

# The How 🏗

After all that reading, the shape of what I wanted got clearer by *contrast*. I didn't want a shared prompt that every repo clones — that rots the moment it drifts from the repos using it, and worse, it imposes one project's shape onto another. I didn't want per-repo artisanal, either — that's where I started.

The unlock was a small reframe:

> **Read it as steering. Don't install it.**

Instead of a template that gets copied into projects, I made a single directional repo that projects *read* and adopt the behavior from — while keeping their own hard-won specifics local. Nothing gets cloned. A project points at it, the way a new engineer reads a team's working agreements before touching the code.

That distinction did more work than I expected, so let me unpack the pieces.

## Invariants vs. derivations

The core question became: what's actually universal, and what did a specific project *earn*?

- **Invariants** transfer. DRY and KISS are true regardless of stack. "Verify before done" is true regardless of project. The habit of logging decisions so they don't get re-argued is universal.
- **Derivations** are local. The exact quality gates, the stack-specific conventions, the rule that exists *because this project drifted without it* — those are scars. They belong to the project that earned them, not to a shared template.

The steering repo carries the invariants. Each project carries its own derivations. Where a project says nothing, the steer governs; where a project has earned a local rule, the local rule wins — and it gets marked as a deliberate divergence, so a reader can tell an earned scar from accidental drift.

## Three layers

I split the shared guidance by how often it changes:

- **Spine** — engineering principles and agent conduct. Rarely changes. Loaded always.
- **Ways of working** — the boot sequence, how knowledge is layered, the workflow loop, verification discipline. Evolves as I gain scars. Loaded when relevant.
- **Preferences** — how I like to collaborate. Options-then-decide, lean responses, honesty over agreement. Loaded when relevant.

Laid out, the whole thing is deliberately small — the layers matter more than the file count:

```text
agent-steer/
├── INDEX.md              # the gate: what to read at boot (spine only), what to pull on a match
├── spine/                # LOAD ALWAYS — the ~3k-token always-on layer
│   ├── principles.md     #   engineering invariants (DRY, KISS, security-as-default…)
│   └── conduct.md        #   how the agent behaves every turn (verify before done, no sycophancy…)
├── ways-of-working/      # LOAD ON RELEVANCE — the boot sequence, knowledge layers, workflow, verification
├── preferences/          # LOAD ON RELEVANCE — how I like to collaborate
├── adoption/             # read only when bringing a project into the practice
├── exemplars.md          # the invariants shown in a real project — illustration, not a template
└── .agents/              # the steer's own context: its decisions, backlog, open questions
```

The layering matters for a boring but real reason: an agent that reads all of that up front forgets half of it by mid-session. So the whole thing is indexed — load the small always-on spine, pull the deeper layers only when the task calls for them. Same discipline I use for project context: index first, read on relevance. The `INDEX.md` isn't a table of contents; it's a boot instruction — *read the spine, nothing else, until a hook matches the task in front of you* — because the one thing you pay for every single session is the always-on layer, and that layer should stay cheap.

That last directory, `.agents/`, is the steer keeping its *own* context — tracking its decisions and open questions the same way it asks every adopting project to. A practice that documents itself but doesn't *use* itself is one I wouldn't trust either. If you want the concrete shape rather than my description of it, it's all in the [repo](https://github.com/weirdion/agent-steer).

## Directive on behavior, advisory on structure

This is the piece that took me two tries to get right, and it's the part I'm most happy with.

The steer is **directive about behavior** — verify before done, no sycophancy, security as the default. Non-negotiable, no discussion.

But it's **advisory about structure** — what the agent directory is called, whether one context is enough or the work should split by purpose, where docs live. Those aren't things the steer should dictate. They're things the agent should *assess from the actual repo and propose*, with me as the ratifier. The steer gives it the criteria to reason with; it doesn't hand it the answer.

That split — fixed on conduct, proposed on arrangement — is what keeps it feeling like steering instead of a template.

# Test it out 🧪

A design that only lives in my head is a design I don't trust yet. So I ran a cheap experiment: I pointed an agent at the steer and told it to *pretend it was an existing project's agent and adopt the practice.* A dry run, no changes made.

It was the most useful thing I did, because it immediately caught places where I'd overreached.

The clearest example: my first draft assumed every project should have one agent-context directory. The dry run against a tightly-coupled, multi-surface repo pushed back — a project where every decision ripples across the surfaces wants a *single* unified context so the agent sees the whole picture. But a large workspace of *independent* sub-projects wants the opposite: split by purpose so the contexts don't drown each other. The deciding factor wasn't size at all. It was **coupling**. I'd written a default where I should have written a criterion.

That's the honest state of it: it's validated by dry runs against real projects, not yet by a full-scale retrofit of everything I own. I know where it holds and I know it hasn't been stress-tested everywhere. I'd rather tell you that than pretend it's finished.

# Where do we go from here? ⏩

The most deliberate decision I made was to **stop before overfitting it.** It would have been easy to keep polishing — to encode every quirk of the two projects I tested against as if they were universal laws. That's exactly the trap. Those quirks are scars, not invariants, and baking them in would have made the steer prescriptive in the same way the template I was avoiding is prescriptive.

So instead it evolves by use. When a lesson learned in one project turns out to be about *how I work* rather than about *that project*, it graduates up into the shared layer. The scars accumulate honestly, one real moment at a time, instead of being guessed at up front.

Which leaves me with a genuinely open question, and I don't have a clean answer: **where's the line between a rule worth sharing and a scar that belongs to one project?** Most of the time it's obvious in hindsight and invisible in the moment. I think the honest move is to let it stay local until it proves it's universal — but that means occasionally re-deriving something I could have shared. I'm okay with that trade. I think.

If there's a meta-note here, it's this: this whole post *is* the method. A why, a how, a test, and the dead ends left in — because the reasoning is the useful part, not the artifact. The repo itself — [`agent-steer`](https://github.com/weirdion/agent-steer) — is public if you want to poke at it, but please don't clone it. Read it, disagree with it, and build the version that fits *your* context.

—

_I'm trying to get back into writing about the things I actually do — this one's been sitting in my head for a while. Let me know if it was useful, or tell me where I'm wrong, on [LinkedIn](https://www.linkedin.com/in/ankitpatterson/) or open an issue._ 🙂
