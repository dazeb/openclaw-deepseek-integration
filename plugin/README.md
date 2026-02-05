# DeepSeek OpenClaw Plugin (Optional)

This directory contains an optional OpenClaw plugin for DeepSeek API integration.

## Note
The main integration uses configuration-based approach which is recommended for most users. This plugin is provided as an advanced option for users who prefer plugin-based integration.

## Plugin vs Configuration

### Configuration-Based (Recommended)
- Simple JSON configuration in `openclaw.json`
- No compilation needed
- Easy to understand and modify
- Works with all OpenClaw versions

### Plugin-Based (Advanced)
- Programmatic provider registration
- Potential for additional features
- Requires TypeScript compilation
- May need updates for OpenClaw version changes

## Development Status
⚠️ **Experimental**: This plugin is not fully implemented. It serves as a starting point for developers who want to create a full plugin implementation.

## Files
- `openclaw.plugin.json`: Plugin manifest
- `index.ts`: TypeScript source (placeholder)
- `package.json`: Dependencies

## Building the Plugin
```bash
cd plugin
npm install
npm run build
```

## Installation
```bash
openclaw plugins enable ./path/to/plugin
```

## Contributing
Pull requests welcome to complete the plugin implementation.