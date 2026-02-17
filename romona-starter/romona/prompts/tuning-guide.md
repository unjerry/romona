# Romona — System Prompt Tuning Guide

The actual prompt lives in `modelfile/Romona.modelfile`. After editing, rebuild:

```bash
docker compose exec ollama ollama create romona -f /modelfiles/Romona.modelfile
```

## Tuning Temperature

| Value | Effect |
|-------|--------|
| 0.5-0.6 | Precise, focused, less creative |
| 0.7-0.8 | Balanced (default: 0.8) |
| 0.9-1.0 | More creative, warmer, occasionally unpredictable |

## Making Her Warmer
- Increase temperature to 0.9
- Add specific emotional behaviors in the system prompt
- Give her opinions, preferences, pet peeves — makes her feel real
- Example: "你喜欢下雨天。你觉得红烧肉是世界上最治愈的食物。"

## Context Window (`num_ctx`)

| Value | Memory | VRAM Usage |
|-------|--------|-----------|
| 4096 | ~3000 words | Light |
| 8192 | ~6000 words (default) | Moderate |
| 16384 | ~12000 words | Heavy (may slow 8GB GPU) |

## 中文优化
- 系统提示词里多写中文，模型会模仿这个语气
- 告诉她用口语：呀、呢、嘛、吧、啦
- 避免"您"，用"你"
- 加入她的中文个性，例如喜欢什么、讨厌什么
