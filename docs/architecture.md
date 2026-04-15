# System architecture

## Three layers

### 1. Claude Code (agent layer)

Claude Code is the terminal-based agent interface. It can read and write files, run shell commands, edit codebases, reason over multiple steps, and use tool schemas. This is the **agent orchestration layer**.

### 2. LM Studio (inference server)

LM Studio acts as a local OpenAI/Anthropic-compatible API server. It loads the model into RAM, exposes a local HTTP endpoint, manages inference slots, maintains KV cache, and returns generated tokens.

Typical base URL:

```text
http://localhost:1234
```

### 3. Local LLM (reasoning engine)

Example setups use small GGUF models (e.g. Qwen-class, 2B–7B range) quantized for CPU or GPU. This is the actual **language reasoning engine**.

## End-to-end flow

```text
Claude Code
   -> LM Studio local API
   -> Local LLM inference
   -> Generated tokens
   -> Terminal response
```

## Core model concepts

### Parameter size

Examples: 2B, 7B, 14B, 32B (learned weights). **Smaller** tends to be faster; **larger** tends to improve reasoning at higher RAM/VRAM cost.

### CPU vs GPU

**CPU-friendly:** roughly 1B–2B, small quantized 3B, GGUF Q4/Q5.

**GPU-preferred:** often 7B+, long context, multi-step agent workflows.

### GGUF

GGUF fits **llama.cpp-style** inference (as used by LM Studio): good CPU support, lower memory than many raw formats, practical for local deployment.

### Quantization (rule of thumb)


| Quant | Quality | Speed  | RAM    |
| ----- | ------- | ------ | ------ |
| Q8    | Highest | Slower | Higher |
| Q6    | High    | Medium | Medium |
| Q4    | Good    | Faster | Lower  |


On CPU-only Windows laptops, **Q4/Q5 GGUF** is often the sweet spot.

## Claude Code vs Continue


| Tool            | Strengths                                                                          |
| --------------- | ---------------------------------------------------------------------------------- |
| **Continue**    | Fast inline completion, lightweight IDE-native edits                               |
| **Claude Code** | Richer reasoning, structured answers, terminal workflows, autonomous agent actions |


**Rule of thumb:** Continue for fast IDE assistance; Claude Code for autonomous engineering workflows in the terminal.

## Resource profiling (high level)

- **LM Studio:** often multi-GB RAM (weights + KV cache + buffers).
- **Claude Code:** comparatively modest process memory (UI + orchestration).

**Takeaway:** inference cost concentrates in the **model server**, not the terminal UI.