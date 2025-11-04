# Narcoleptic Fox Claude Code Plugin Marketplace

A collection of professional development tools and plugins for Claude Code.

## Installation

Add this marketplace to your Claude Code installation:

```bash
/plugin marketplace add Dieshen/claude_marketplace
```

## Available Plugins

### 🎨 shadcn-aesthetic
Modern CSS/SCSS architecture based on shadcn/ui design principles. Teaches Claude to generate refined, accessible styling with:
- HSL-based color systems
- Consistent spacing scales
- Subtle shadows and smooth transitions
- Proper focus states
- Modern layout patterns
- Dark mode support

Perfect for building Vibe.UI components or any modern web UI.

## Adding Plugins

### For plugins in this repository

Add relative path entries to the `plugins` array in `.claude-plugin/marketplace.json`:

```json
{
  "name": "plugin-name",
  "source": "./plugins/plugin-name",
  "description": "Plugin description",
  "version": "1.0.0",
  "author": {
    "name": "Brock"
  }
}
```

### For plugins in separate GitHub repositories

```json
{
  "name": "external-plugin",
  "source": {
    "source": "github",
    "repo": "owner/repo"
  },
  "description": "Plugin description"
}
```

## Plugin Structure

Create plugins in the `plugins/` directory:

```
plugins/
  └── your-plugin/
      ├── plugin.json
      ├── commands/
      ├── agents/
      └── hooks/
```

## License

MIT License - see LICENSE file for details

## Contact

- **Email**: contact@narcolepticfox.com
- **Company**: Narcoleptic Fox LLC
