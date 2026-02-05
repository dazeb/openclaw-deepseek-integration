import { emptyPluginConfigSchema } from "openclaw/plugin-sdk";

// Default configuration for DeepSeek provider
const DEEPSEEK_BASE_URL = "https://api.deepseek.com";

const DEEPSEEK_MODELS = [
  {
    id: "deepseek-chat",
    name: "DeepSeek Chat (V3.2)",
    reasoning: false,
    input: ["text"] as const,
    cost: {
      input: 0.00000028,
      output: 0.00000042,
      cacheRead: 0.000000028,
      cacheWrite: 0.00000028,
    },
    contextWindow: 128000,
    maxTokens: 8192,
  },
  {
    id: "deepseek-reasoner",
    name: "DeepSeek Reasoner (V3.2)",
    reasoning: true,
    input: ["text"] as const,
    cost: {
      input: 0.00000028,
      output: 0.00000042,
      cacheRead: 0.000000028,
      cacheWrite: 0.00000028,
    },
    contextWindow: 128000,
    maxTokens: 65536,
  },
];

const deepseekPlugin = {
  id: "deepseek-provider",
  name: "DeepSeek Provider",
  description: "DeepSeek API Platform provider for OpenClaw",
  configSchema: emptyPluginConfigSchema(),
  register(api) {
    // Note: This is a placeholder implementation.
    // OpenClaw's plugin API for API key providers may require additional setup.
    // Currently, DeepSeek is best configured via openclaw.json configuration.
    
    api.runtime.log("DeepSeek provider plugin loaded. Use configuration-based setup instead.");
    
    // TODO: Implement proper provider registration when OpenClaw API supports
    // API key providers via plugins.
  },
};

export default deepseekPlugin;