#!/bin/bash
# DeepSeek OpenClaw Integration Setup Script
# This script helps you integrate DeepSeek API Platform into your OpenClaw configuration

set -e

echo "🧠 DeepSeek OpenClaw Integration Setup"
echo "======================================"

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "❌ jq is required but not installed. Please install jq first."
    echo "   Ubuntu/Debian: sudo apt-get install jq"
    echo "   macOS: brew install jq"
    exit 1
fi

# Check if openclaw.json exists
OPENCLAW_CONFIG="${1:-$HOME/.openclaw/openclaw.json}"
if [ ! -f "$OPENCLAW_CONFIG" ]; then
    echo "❌ OpenClaw config not found at: $OPENCLAW_CONFIG"
    echo "   Please specify the path to your openclaw.json file:"
    echo "   ./setup.sh /path/to/openclaw.json"
    exit 1
fi

echo "📁 Using OpenClaw config: $OPENCLAW_CONFIG"

# Create backup
BACKUP_FILE="${OPENCLAW_CONFIG}.backup.$(date +%Y%m%d_%H%M%S)"
cp "$OPENCLAW_CONFIG" "$BACKUP_FILE"
echo "📋 Created backup: $BACKUP_FILE"

# Check if deepseek provider already exists
if jq -e '.models.providers.deepseek' "$OPENCLAW_CONFIG" > /dev/null 2>&1; then
    echo "⚠️  DeepSeek provider already exists in config. Skipping provider configuration."
    PROVIDER_EXISTS=true
else
    PROVIDER_EXISTS=false
fi

# Merge configuration
if [ "$PROVIDER_EXISTS" = false ]; then
    echo "🔄 Merging DeepSeek provider configuration..."
    
    # Create temporary files
    CONFIG_DIR=$(dirname "$0")
    DEEPSEEK_CONFIG="$CONFIG_DIR/deepseek-config.json"
    
    if [ ! -f "$DEEPSEEK_CONFIG" ]; then
        echo "❌ DeepSeek config file not found: $DEEPSEEK_CONFIG"
        exit 1
    fi
    
    # Merge using jq
    jq --slurpfile deepseek "$DEEPSEEK_CONFIG" '
        .models.providers = (.models.providers + $deepseek[0].models.providers) |
        .agents.defaults.models = (.agents.defaults.models + $deepseek[0].agents.defaults.models)
    ' "$OPENCLAW_CONFIG" > "${OPENCLAW_CONFIG}.tmp" && mv "${OPENCLAW_CONFIG}.tmp" "$OPENCLAW_CONFIG"
    
    echo "✅ DeepSeek provider configuration added"
fi

# Check environment variable setup
echo ""
echo "🔑 Environment Variable Setup"
echo "----------------------------"
echo "To use DeepSeek models, you need to set your API key as an environment variable:"
echo ""
echo "1. Export in your current shell:"
echo "   export DEEPSEEK_API_KEY=\"your-api-key-here\""
echo ""
echo "2. Or add to your shell profile (~/.bashrc, ~/.zshrc, etc.):"
echo "   echo 'export DEEPSEEK_API_KEY=\"your-api-key-here\"' >> ~/.bashrc"
echo ""
echo "3. Get your API key from: https://platform.deepseek.com/api_keys"
echo ""
echo "🔐 Auth Profile Setup (Optional)"
echo "--------------------------------"
echo "For persistent API key storage (instead of environment variable), you can"
echo "add an auth profile using the included script:"
echo ""
echo "  ./add-deepseek-auth.sh \"your-api-key-here\""
echo ""
echo "This will store your API key in OpenClaw's secure auth profiles."
echo ""
echo "📋 Verification"
echo "--------------"
echo "Run the following commands to verify installation:"
echo ""
echo "  # List available models (using environment variable)"
echo "  DEEPSEEK_API_KEY=\"your-key\" openclaw models list | grep deepseek"
echo ""
echo "  # List available models (using auth profile)"
echo "  openclaw models list | grep deepseek"
echo ""
echo "  # Test with a simple query (using environment variable)"
echo "  DEEPSEEK_API_KEY=\"your-key\" openclaw 'Hello from DeepSeek!'"
echo ""
echo "🎉 Setup complete! Choose one of these authentication methods:"
echo ""
echo "  1. Set DEEPSEEK_API_KEY environment variable (takes precedence)"
echo "  2. Add auth profile with ./add-deepseek-auth.sh (persistent storage)"