# DeepSeek API Platform Integration for OpenClaw

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub Repository](https://img.shields.io/badge/GitHub-Repository-blue)](https://github.com/dazeb/openclaw-deepseek-integration)

This integration adds DeepSeek API Platform support to OpenClaw, allowing you to use DeepSeek's state-of-the-art language models including:
- **DeepSeek Chat (V3.2)**: Non-thinking mode with 128K context
- **DeepSeek Reasoner (V3.2)**: Thinking mode with 128K context and extended reasoning capabilities

## Quick Start

### 1. Get Your API Key
1. Visit [DeepSeek Platform](https://platform.deepseek.com/api_keys)
2. Create an account and generate an API key
3. Copy your API key

### 2. Configure OpenClaw

#### Option A: Manual Configuration (Recommended)

Add the following configuration to your `openclaw.json` file:

```json
{
  "models": {
    "mode": "merge",
    "providers": {
      "deepseek": {
        "baseUrl": "https://api.deepseek.com",
         "apiKey": "${DEEPSEEK_API_KEY:-}",
        "api": "openai-completions",
        "models": [
          {
            "id": "deepseek-chat",
            "name": "DeepSeek Chat (V3.2)",
            "reasoning": false,
            "input": ["text"],
            "cost": {
              "input": 0.00000028,
              "output": 0.00000042,
              "cacheRead": 0.000000028,
              "cacheWrite": 0.00000028
            },
            "contextWindow": 128000,
            "maxTokens": 8192
          },
          {
            "id": "deepseek-reasoner",
            "name": "DeepSeek Reasoner (V3.2)",
            "reasoning": true,
            "input": ["text"],
            "cost": {
              "input": 0.00000028,
              "output": 0.00000042,
              "cacheRead": 0.000000028,
              "cacheWrite": 0.00000028
            },
            "contextWindow": 128000,
            "maxTokens": 65536
          }
        ]
      }
    }
  },
  "agents": {
    "defaults": {
      "models": {
        "deepseek/deepseek-chat": {},
        "deepseek/deepseek-reasoner": {}
      }
    }
  }
}
```

#### Option B: Environment Configuration

Create a `.env` file in your OpenClaw directory:

```bash
DEEPSEEK_API_KEY=your-api-key-here
```

Or export it in your shell:

```bash
export DEEPSEEK_API_KEY="your-api-key-here"
```

### 3. Auth Profile Setup (Optional)

For persistent API key storage (instead of environment variables), you can add an auth profile using the included script:

```bash
./add-deepseek-auth.sh "your-api-key-here"
```

This stores your API key securely in OpenClaw's auth profiles and allows you to use DeepSeek models without setting environment variables.

### 4. Verify Installation

```bash
openclaw models list | grep deepseek
```

You should see:
```
deepseek/deepseek-chat                     text       128k     no    yes   configured
deepseek/deepseek-reasoner                 text       128k     no    yes   configured
```

### 5. Set as Default Model (Optional)

```bash
openclaw models set deepseek/deepseek-reasoner
```

## Model Specifications

| Model | ID | Reasoning | Context Window | Max Output | Input Types | Cost (per token) |
|-------|----|-----------|----------------|------------|-------------|------------------|
| DeepSeek Chat | `deepseek-chat` | `false` | 128,000 | 8,192 | Text | Input: $0.00000028, Output: $0.00000042 |
| DeepSeek Reasoner | `deepseek-reasoner` | `true` | 128,000 | 65,536 | Text | Input: $0.00000028, Output: $0.00000042 |

**Note**: Cache read/write costs are included for accurate token usage tracking.

## Features

- ✅ **OpenAI API Compatibility**: Uses DeepSeek's OpenAI-compatible API
- ✅ **Thinking Mode Support**: Full support for DeepSeek Reasoner's reasoning capabilities
- ✅ **Accurate Cost Tracking**: Per-token pricing for both models
- ✅ **Environment Variable Security**: API key stored securely in environment variables
- ✅ **Auth Profile Support**: Optional persistent API key storage in OpenClaw auth profiles
- ✅ **Automatic Detection**: Models appear in `openclaw models list` automatically

## Usage Examples

### Use DeepSeek Reasoner for complex tasks:
```bash
openclaw models set deepseek/deepseek-reasoner
```

### Use DeepSeek Chat for general tasks:
```bash
openclaw models set deepseek/deepseek-chat
```

### Check model availability:
```bash
openclaw models list --provider deepseek
```

## Troubleshooting

### "Missing env var DEEPSEEK_API_KEY"
Make sure you've set the environment variable:
```bash
export DEEPSEEK_API_KEY="your-api-key"
```

### Models don't appear in list
1. Verify your `openclaw.json` configuration is valid:
   ```bash
   openclaw doctor
   ```
2. Check that the provider is properly configured in `models.providers`
3. Ensure models are added to `agents.defaults.models` allowlist

### API requests fail
1. Verify your API key is valid and has sufficient credits
2. Check DeepSeek API status: https://status.deepseek.com/
3. Ensure you're using the correct base URL: `https://api.deepseek.com`

## Advanced Configuration

### Custom Base URL
If you need to use a different endpoint (e.g., for compatibility):

```json
"baseUrl": "https://api.deepseek.com/v1"
```

### Model Aliases
Add custom aliases for easier reference:

```json
"agents": {
  "defaults": {
    "models": {
      "deepseek/deepseek-chat": {
        "alias": "DeepSeek"
      },
      "deepseek/deepseek-reasoner": {
        "alias": "DeepSeek Thinking"
      }
    }
  }
}
```

## Optional: Plugin Installation (Advanced)

For users who prefer plugin-based integration, an experimental OpenClaw plugin is included in the `plugin/` directory.

### Plugin Features
- Programmatic provider registration
- Potential for future enhancements (API key management, etc.)

### Setup
```bash
cd plugin
npm install
npm run build
openclaw plugins enable ./path/to/plugin
```

**Note**: The configuration-based approach is recommended for most users. The plugin is experimental and may require additional development.

## License

MIT License - See LICENSE file for details.

## Support

- OpenClaw Documentation: https://opencode.ai
- DeepSeek API Documentation: https://api-docs.deepseek.com
- Issues: Please file GitHub issues for bugs or feature requests