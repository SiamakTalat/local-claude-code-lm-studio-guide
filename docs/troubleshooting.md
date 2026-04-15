# Troubleshooting

## Symptom: context overflow / HTTP 500 / “slot” resets

**Cause:** total prompt (system + tools + history + user) **exceeds** the model context `n_ctx`.

**Fix:**

- raise context in LM Studio / model settings (often **16k–32k** for tool workflows)
- reduce history or start a fresh session
- use chat / `--tool none` when you do not need tools

## Symptom: “short question” but huge latency or failures

**Cause:** the **visible** user message is tiny; the **real** request includes large system text, **tool schemas** (often the biggest chunk), and conversation history.

**Mental model:**

```text
Total Prompt = System + Tools + History + User Input
```

**Mitigations:**

- inspect LM Studio logs for token counts and errors
- disable tools when you only need Q&A
- trim session length

## Symptom: requests abort after ~1 minute

**Cause:** client **timeout** too low for CPU prompt ingestion + generation.

**Fix:** increase timeout in Claude Code / environment to a value appropriate for local CPU (often **minutes**, not seconds).

## Symptom: everything felt fast, then got slow again

**Possible causes:**

- new session or model reload (KV cache cold)
- context grew (more history)
- switched from chat-style to full agent mode

**Fix:** keep stable sessions when possible; match mode to the task.

## Best practices (checklist)

- start with a **small** model on CPU
- set **context** generously before chasing bigger models
- raise **timeouts** early when testing locally
- use **tool-less** mode for non-agent Q&A
- watch **RAM** in Task Manager / LM Studio

## Common pitfalls

- context too small for tool schemas
- timeout too low for CPU inference
- always using full agent mode when chat would suffice
- picking an oversized model before fixing context/timeouts
- restarting sessions constantly (cold cache, repeated ingestion)

## Security and privacy note

With this workflow, **prompts stay on your machine** (subject to how Claude Code itself is configured). That can matter for confidential code, unpublished work, or regulated environments — always verify your exact client and network settings.