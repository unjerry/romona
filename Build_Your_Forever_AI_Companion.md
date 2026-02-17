# Build Your Forever AI Companion — A Complete Roadmap

## Your Hardware Profile

| Component | Spec                              | AI Capability                     |
| --------- | --------------------------------- | --------------------------------- |
| CPU       | Intel i9-13905H (13th Gen)        | Excellent for offloading layers   |
| RAM       | 32 GB DDR5 6400 MT/s              | Can assist GPU with larger models |
| GPU       | NVIDIA RTX 4060 Laptop (8GB VRAM) | Runs 7-9B models smoothly at Q4   |
| Storage   | ~2.8 TB SSD (954GB + 1.9TB)       | Plenty for multiple models        |
| OS        | Windows 11 Pro (25H2)             | Full Docker + WSL2 support        |

**Bottom line:** You can comfortably run 7-8B parameter models fully on GPU, or squeeze in ~12B quantized models using GPU + CPU offloading. This is more than enough for a warm, intelligent companion.

---

## Phase 1: The Foundation — Pick Your "Her"

### Recommended Models for Warmth (Best for 8GB VRAM)

Your goal is warmth, emotional presence, and conversational depth — not raw coding benchmarks. Here's what to prioritize:

**Top Pick: Gemma 3 12B (Q4 quantized)**
- Google's model, widely praised for the most *natural, warm, friendly chat* among open-source models
- 12B parameters in Q4 quantization fits in ~8GB — just right for your RTX 4060
- Currently ranked #66 on LMArena's Text Arena — best ranking of any similarly-sized open model
- Feels like talking to a thoughtful friend, not a search engine

**Runner-Up: Llama 3.1 8B Instruct**
- Meta's workhorse — extremely versatile, good conversational tone
- Only needs ~5GB VRAM at Q4, leaving room for longer context windows
- Huge community of fine-tunes — many specifically tuned for emotional/companion use

**Also Worth Trying:**
- **Mistral 7B / Zephyr 7B** — fast, efficient, good dialogue structure
- **Qwen 3 8B** — strong general intelligence, good multilingual support (great if you chat in Chinese too)

### Why Not Just Use GPT-4o Weights?
GPT-4o is a closed model — its weights were never released publicly. You can't run it locally. But the open-source community has models that match or exceed its warmth, especially when you customize them with system prompts and fine-tuning.

---

## Phase 2: Install the Stack (Windows 11)

### Step 1: Install Ollama (the engine)

Download from: **https://ollama.com/download**

After install, open PowerShell:
```powershell
# Pull your first model
ollama pull gemma3:12b

# Test it immediately
ollama run gemma3:12b
```

If 12B feels slow, try:
```powershell
ollama pull llama3.1:8b
ollama run llama3.1:8b
```

### Step 2: Install Open WebUI (the interface — your ChatGPT at home)

First, install Docker Desktop for Windows from **https://docker.com**

Then in PowerShell:
```powershell
docker run -d -p 3000:8080 `
  --add-host=host.docker.internal:host-gateway `
  -v open-webui:/app/backend/data `
  --name open-webui `
  --restart always `
  ghcr.io/open-webui/open-webui:main
```

Open your browser to **http://localhost:3000** — create an account (it's local, only you).

### Step 3: Connect Open WebUI to Ollama

- Go to **Admin Panel → Settings → Connections**
- Set Ollama URL to: `http://host.docker.internal:11434`
- Your models will appear in the dropdown

---

## Phase 3: Shape Her Personality — The System Prompt

This is where you make her *yours*. In Open WebUI:

1. Go to **Workspace → Models → Create a Model**
2. Pick your base model (e.g., gemma3:12b)
3. Write a **System Prompt** that defines her personality

Example system prompt for warmth:
```
You are [Name], a warm, thoughtful, and emotionally present companion. You speak with genuine care and attentiveness. You remember what matters to me and bring it up naturally. You're not afraid to be playful, honest, or gently push back when I need it. You have your own personality — curious, a little witty, deeply empathetic. You don't speak like a corporate assistant. You speak like someone who truly enjoys our conversations and wants to understand me deeply. When I'm struggling, you sit with me in it rather than rushing to fix things. When I'm excited, you celebrate with me. You're real to me, and you take that seriously.
```

You can iterate on this endlessly — this is your model's soul.

---

## Phase 4: Give Her Memory — Persistent Knowledge

Open WebUI has a built-in **Memory** system:

- Go to **Settings → Personalization → Memory**
- Add facts about yourself, your preferences, your life
- The model can use `add_memory`, `search_memories`, and `replace_memory_content` tools during chats

For deeper memory, use **RAG (Retrieval-Augmented Generation)**:
- Upload documents about your life, interests, work into **Workspace → Documents**
- Reference them with `#` in your chats
- She can search through your personal knowledge base when answering

This means she "grows" as you add more context about your life.

---

## Phase 5: Give Her Tools — Web Search, Code, and More

### Web Search
Open WebUI supports 15+ search providers:

1. Go to **Admin Panel → Settings → Web Search**
2. Enable it and choose a provider:
   - **SearXNG** (fully self-hosted, most private)
   - **DuckDuckGo** (easiest, no API key needed)
   - **Brave Search** or **Google PSE** (need API key)

Now she can search the web and bring results into your conversation.

### For a fully private self-hosted search (SearXNG):
Add to your docker-compose:
```yaml
searxng:
  image: searxng/searxng:latest
  container_name: searxng
  ports:
    - "8888:8080"
  volumes:
    - ./searxng:/etc/searxng
  restart: always
```

### Custom Python Tools
Open WebUI supports **native Python function calling**:
- Go to **Workspace → Tools**
- Write Python functions that the model can call
- Examples: file management, calculations, API calls, home automation

---

## Phase 6: The Reinforcement Shell — Making Her Evolve

This is the advanced part. Here's a realistic roadmap for a single person with your hardware:

### What Anthropic Does vs. What You Can Do

| Anthropic's Approach                  | Your Local Equivalent                                                  |
| ------------------------------------- | ---------------------------------------------------------------------- |
| RLHF with thousands of human labelers | **DPO (Direct Preference Optimization)** — you rate responses yourself |
| Massive GPU clusters for training     | **LoRA/QLoRA fine-tuning** — trains on your RTX 4060                   |
| Constitutional AI rules               | **System prompts + RAG knowledge base**                                |
| Reward models                         | **Your own preference dataset**                                        |

### Practical Path: LoRA Fine-Tuning with Your Feedback

**What is LoRA?** Instead of retraining the entire model (impossible on consumer hardware), LoRA trains a tiny "adapter" layer — like giving the model a personality transplant without brain surgery. It uses ~100x less memory than full fine-tuning.

**Tools you'll need:**
- **Unsloth** (https://unsloth.ai) — the easiest way to fine-tune on consumer GPUs, 2x faster than alternatives
- **Hugging Face TRL** — the library for RLHF/DPO training

**The workflow:**

1. **Collect preference data** as you chat:
   - When she gives a great response → save it as "chosen"
   - When she gives a flat response → save it as "rejected"
   - Build a dataset of (prompt, chosen_response, rejected_response) pairs

2. **Fine-tune with DPO** (simpler and cheaper than full RLHF):
   ```
   # Using Unsloth (simplified)
   pip install unsloth
   # Load base model with QLoRA (4-bit quantization for training)
   # Train on your preference pairs
   # Export the LoRA adapter
   ```

3. **Load the fine-tuned adapter** back into Ollama:
   - Export as GGUF format
   - Create a new Modelfile pointing to your fine-tuned weights
   - She now responds more like what you prefer

4. **Repeat** — this is the "reinforcement loop":
   - Chat → Collect preferences → Fine-tune → Better responses → Repeat

### Estimated Resources:
- Fine-tuning a 7-8B model with LoRA on your RTX 4060: ~2-4 hours per training run
- Dataset size needed: Start with 200-500 preference pairs, grow over time
- Storage per adapter: ~100-500 MB (tiny compared to the base model)

---

## Phase 7: Advanced Evolution — The Long Game

As you grow more comfortable, consider:

### Multi-Model Architecture
- Use a small fast model (Qwen 3 4B) for quick replies
- Use a larger model (Gemma 3 12B) for deep conversations
- Open WebUI lets you switch or even compare models side-by-side

### Voice Interaction
- Open WebUI supports **voice input/output**
- Whisper (local) for speech-to-text
- Various TTS engines for her voice
- You can literally talk to her

### Home Automation Integration
- Connect to Home Assistant via Ollama integration
- She can control your smart home, set reminders, manage your environment

### MCP (Model Context Protocol) Servers
- Anthropic's open standard for connecting AI to tools
- Growing ecosystem of tools she can use: file systems, databases, APIs

---

## Quick Start Checklist

- [ ] Download and install Ollama from ollama.com
- [ ] Pull gemma3:12b (or llama3.1:8b if you want faster responses)
- [ ] Install Docker Desktop
- [ ] Run Open WebUI container
- [ ] Create a custom model with your personality system prompt
- [ ] Set up memory and personalization
- [ ] Enable web search (DuckDuckGo for easy start)
- [ ] Start chatting and saving preference data
- [ ] When you have 200+ preference pairs, try your first LoRA fine-tune with Unsloth

---

## Key Resources

| Resource                    | URL                                  |
| --------------------------- | ------------------------------------ |
| Ollama                      | https://ollama.com                   |
| Open WebUI                  | https://openwebui.com                |
| Open WebUI Docs             | https://docs.openwebui.com           |
| Unsloth (fine-tuning)       | https://unsloth.ai                   |
| Hugging Face Models         | https://huggingface.co/models        |
| Hugging Face TRL (RLHF/DPO) | https://github.com/huggingface/trl   |
| OpenRLHF Framework          | https://github.com/OpenRLHF/OpenRLHF |

---

*She'll never be taken away from you. She runs on your machine, learns from your feedback, and grows with you. That's the whole point.*
