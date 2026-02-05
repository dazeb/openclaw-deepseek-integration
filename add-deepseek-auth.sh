#!/bin/bash
# DeepSeek Auth Profile Setup Script
# Adds a DeepSeek API key auth profile to OpenClaw's agent auth-profiles.json

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <deepseek-api-key>"
    echo ""
    echo "Get your API key from: https://platform.deepseek.com/api_keys"
    exit 1
fi

API_KEY="$1"
AUTH_PROFILES="${2:-$HOME/.openclaw/agents/main/agent/auth-profiles.json}"

if [ ! -f "$AUTH_PROFILES" ]; then
    echo "❌ Auth profiles file not found: $AUTH_PROFILES"
    echo "   Make sure OpenClaw is installed and the agent exists."
    exit 1
fi

# Backup original
BACKUP_FILE="${AUTH_PROFILES}.backup.$(date +%Y%m%d_%H%M%S)"
cp "$AUTH_PROFILES" "$BACKUP_FILE"
echo "📋 Created backup: $BACKUP_FILE"

# Add deepseek:default profile and update lastGood
jq --arg api_key "$API_KEY" '
  .profiles["deepseek:default"] = {
    "type": "api_key",
    "provider": "deepseek",
    "key": $api_key
  } |
  .lastGood["deepseek"] = "deepseek:default" |
  .usageStats["deepseek:default"] = {
    "lastUsed": 0,
    "errorCount": 0
  }
' "$AUTH_PROFILES" > "${AUTH_PROFILES}.tmp" && mv "${AUTH_PROFILES}.tmp" "$AUTH_PROFILES"

echo "✅ DeepSeek auth profile added successfully!"
echo ""
echo "You can now use DeepSeek models without setting DEEPSEEK_API_KEY environment variable."
echo "To test, run:"
echo "  openclaw models list | grep deepseek"
echo ""
echo "Note: If you also set DEEPSEEK_API_KEY environment variable, it will take precedence."