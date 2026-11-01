# Chhoti Don

Multi-language, multi-agent AI system focused on software development, cybersecurity, and ethical research.

Chhoti Don is a fully local, zero-cost autonomous multi-agent AI assistant for Windows. It runs a Flask web API + React UI, routes natural-language requests through a brain/agent system, and executes tools (coding, web search, browser automation, cyber analysis) — all powered by local Ollama models with no cloud dependency and no API key.

## Features

- **Multi-agent brain** — chat, reasoning, planning and RAG through local Ollama models, with task routing (coding, debug, navigation, vision).
- **Coding agent** — natural-language coding, debugging, review and self-healing with a sandboxed executor.
- **Browser agent** — read-only plan → act → observe research loop (Playwright), guarded operations with human-in-the-loop approval.
- **Hands layer** — tool hands for browser, filesystem, terminal, search, news, weather, YouTube, vision and Windows control.
- **Cyber engine** — defensive security analysis: recon, vulnerability analysis, threat intel, code intelligence and reporting. (Untouched by the Nov 2026 repo cleanup — see git history.)
- **Voice** — local speech-to-text (faster-whisper) and text-to-speech (Piper), CPU/GPU.
- **Knowledge pipeline** — RAG over local documents with ChromaDB.
- **Interfaces** — Flask web API, 10-mode CLI, React dashboard and an Electron desktop shell.

## Requirements

- Windows 10/11
- Python 3.11+
- Node.js 18+ (for the React dashboard build)
- [Ollama](https://ollama.com) running locally

## Quick start (fresh clone)

```bat
git clone https://github.com/bharatkumarhbg2109-alt/Chhoti-Don-Multi-AI-assistant-.git
cd Chhoti-Don-Multi-AI-assistant-
setup.bat
```

`setup.bat` installs Python dependencies, builds the React dashboard, installs the Playwright Chromium browser, and pulls the Ollama models. Then run:

```bat
python app.py
```

Open http://localhost:8000 for the web UI. For the CLI instead:

```bat
python main.py
```

## Manual setup (without setup.bat)

```bat
python -m pip install -r requirements.txt
cd chhoti-don-react
npm install
npm run build
cd ..
python -m playwright install chromium
ollama pull qwen3.5:latest
ollama pull deepseek-coder-v2:16b-lite-instruct-q4_K_M
ollama pull llava:latest
ollama pull nomic-embed-text
```

Voice mode is optional:

```bat
python -m pip install -r requirements-voice.txt
python -m voice.download_voice
```

## Models (local-only policy)

| Role | Model |
| ---- | ----- |
| Main brain (chat, reasoning, planning, RAG) | `qwen3.5:latest` |
| Coding (generation, debug, review) | `deepseek-coder-v2:16b-lite-instruct-q4_K_M` |
| Vision (image understanding) | `llava:latest` |
| Navigation brain (browser agent) | `qwen3.5:latest` |
| Embeddings (RAG) | `nomic-embed-text` |

Designed for an 8GB VRAM GPU: `num_ctx: 4096` keeps qwen3.5 (~5.5 GB) fully on GPU. If Ollama is offline, the system returns a clear "local model unavailable" error — never a fabricated answer and never a cloud call.

## Tests

```bat
python -m pytest tests/ -q
```

Live Ollama tests skip automatically when no Ollama daemon is running (see `tests/test_integration_live.py`).

## Project structure

```
app.py                  # Flask web API — main HTTP entry point (:8000)
main.py                 # CLI entry point (10 interactive modes)
core/                   # Brain, routing, memory, safety, config
chhoti_agents/          # Analyst, coder, security agents
coding_agent/           # Coding agent (sandbox, shell, tools, server)
browser/                # Browser automation (guarded + HITL)
hands/                  # Tool hands layer
tools/                  # Calculator, code tools, registry, sandbox
cyber_engine/           # Defensive security analysis engine
voice/                  # Local STT/TTS voice assistant
knowledge_pipeline/     # RAG pipeline (fetch, process, retrieve)
chhoti-don-react/       # React dashboard (Vite + Tailwind)
desktop/                # Electron desktop shell
tests/                  # Pytest suite
brain.md                # Living codebase memory / architecture notes
```

## License

MIT — see [LICENSE](LICENSE).
