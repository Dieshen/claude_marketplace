# Contributing to Narcoleptic Fox Plugin Marketplace

Thank you for your interest in contributing! This guide will help you add your plugins to our marketplace.

## Adding a Plugin

### Option 1: Plugin in This Repository

1. Create your plugin directory under `plugins/`:
   ```
   plugins/your-plugin-name/
   ```

2. Add required files:
   - `plugin.json` - Plugin manifest
   - `commands/` - Command files (optional)
   - `agents/` - Agent files (optional)
   - `hooks/` - Hook configurations (optional)

3. Add entry to `.claude-plugin/marketplace.json`:
   ```json
   {
     "name": "your-plugin-name",
     "source": "./plugins/your-plugin-name",
     "description": "Brief description",
     "version": "1.0.0",
     "author": {
       "name": "Your Name"
     }
   }
   ```

4. Submit a pull request

### Option 2: External Plugin Repository

1. Ensure your plugin repository has proper `plugin.json` in the root or follows the plugin structure

2. Add entry to `.claude-plugin/marketplace.json`:
   ```json
   {
     "name": "your-plugin-name",
     "source": {
       "source": "github",
       "repo": "your-username/your-plugin-repo"
     },
     "description": "Brief description"
   }
   ```

3. Submit a pull request

## Plugin Requirements

### Required Files

- `plugin.json` - Manifest with plugin metadata
- At least one command, agent, hook, or MCP server

### Plugin Manifest Schema

```json
{
  "name": "plugin-name",
  "description": "Clear, concise description",
  "version": "1.0.0",
  "author": {
    "name": "Your Name",
    "email": "optional@example.com"
  },
  "license": "MIT",
  "keywords": ["relevant", "tags"],
  "commands": "./commands",
  "agents": "./agents"
}
```

## Quality Guidelines

1. **Clear Documentation**: Include README with usage examples
2. **Semantic Versioning**: Follow semver for version numbers
3. **Testing**: Test your plugin before submitting
4. **License**: Include appropriate license (MIT preferred)
5. **No Malicious Code**: All code will be reviewed

## Testing Your Plugin

Before submitting:

```bash
# Add your local marketplace
/plugin marketplace add ./path/to/this/repo

# Install your plugin
/plugin install your-plugin-name@narcoleptic-fox-plugins

# Test functionality
# ... use your plugin commands/features
```

## Review Process

1. Submit pull request
2. Automated checks run
3. Manual code review
4. Feedback or approval
5. Merge and publish

## Questions?

Open an issue or contact: contact@narcolepticfox.com

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
