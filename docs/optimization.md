# Optimization

## Context window (`n_ctx`)

Agent-style prompts can be **much larger** than the visible user message (system + tool schemas + history). If total tokens exceed `n_ctx`, you get rejections, HTTP errors, or unstable behavior.

**Rule:**

```text
n_ctx must be larger than total prompt size
```

**Practical targets for Claude Code + tools:**

- **8k** — light chat-style use
- **16k** — moderate workflows
- **32k** — safer for tool-heavy agents

Example adjustment discussed in learning materials: **4096 → 32000** when the stack includes large tool definitions.

## Performance: prompt ingestion and batching

On CPU, **time to process the prompt** often dominates. If the runtime processes the prompt in fixed-size chunks:

```text
Batches = Prompt Tokens / Batch Size
```

Example: ~19,653 tokens at batch512 → about 38 batches. If each batch is ~16s on CPU, ingestion alone can be ~10 minutes before generation.

**Insight:** local speed is often a **token-ingestion** problem, not only “tokens per second” generation.

## Timeouts

Default short timeouts (e.g. **60s**) often fail on CPU when prompts are large.

**Better local values** may be in the **multi-minute** range (e.g. **300000 ms** / 5 minutes), depending on your client and how it reads configuration.

Without enough timeout budget:

- long prompt loads fail
- agent steps abort
- the stack looks “broken” while it is just slow

## KV cache and session reuse

Later turns can reuse work via **KV cache checkpoints**: valid prefix states avoid recomputing the full prompt every time.

**Practices:**

- keep sessions alive when possible
- avoid unnecessary LM Studio / model reloads

Mental model: **checkpoints** in a long level — continuous sessions get faster for repeated-prefix work.

## Highest-impact knob: fewer tools

Using something equivalent to:

```bash
--tool none
```

can drastically drop prompt size (in one documented case, from ~19.6k toward ~3.2k tokens) by removing tool schemas and related system material.

**When to prefer minimal tools / chat-style use:** explanations, Q&A, debugging discussion.

**When you need full tools:** file edits, shell commands, multi-step autonomous workflows — expect larger prompts and slower CPU ingestion.

## Model selection (CPU path)

1. Start small (e.g. 2B-class).
2. Fix context and timeouts.
3. Move up (4B/7B) only if quality is insufficient **after** context/latency are sane.

## Formulas and mental models

**Total latency (rough):**

```text
Total Time ~= (Prompt Tokens / Batch Size * Batch Time) + Generation Time
```

**Effective prompt:**

```text
Prompt = Hidden System + Tools + History + User Input
```

**Speed rule:**

```text
Fewer tools → fewer tokens → fewer batches → faster response
```

