# Marketplace Setup Guide

Quick guide to get your Claude Code plugin marketplace up and running on GitHub.

## 1. Repository Setup

### Create or Clone Repository

```bash
# If creating new repository
git init
git add .
git commit -m "Initial marketplace setup"
git remote add origin https://github.com/Dieshen/claude_marketplace.git
git push -u origin main

# If adding to existing repository
git add .claude-plugin/
git commit -m "Add Claude Code plugin marketplace"
git push
```

### Required Structure

Your repository should have:
```
.
├── .claude-plugin/
│   └── marketplace.json          # Marketplace configuration
├── plugins/                       # Plugin directory (optional)
│   └── example-plugin/
│       ├── plugin.json
│       └── commands/
├── .gitignore
├── LICENSE
├── README.md
└── CONTRIBUTING.md
```

## 2. Testing Locally

Before publishing, test your marketplace:

```bash
# Clone your repository
git clone https://github.com/Dieshen/claude_marketplace.git
cd claude_marketplace

# Add marketplace locally
/plugin marketplace add .

# Verify plugins appear
/plugin

# Install and test a plugin
/plugin install example-plugin@dieshen-plugins
```

## 3. Publishing to GitHub

1. **Push to GitHub**: Ensure all files are committed and pushed
2. **Make repository public**: Required for public marketplace access
3. **Add topics**: Tag repo with `claude-code`, `plugins`, `marketplace`
4. **Set description**: Add clear repository description

## 4. Distribution

Users can add your marketplace with:

```bash
# GitHub shorthand (recommended)
/plugin marketplace add Dieshen/claude_marketplace

# Full git URL
/plugin marketplace add https://github.com/Dieshen/claude_marketplace.git

# For private repos with access
/plugin marketplace add https://github.com/Dieshen/claude_marketplace.git
```

## 5. Adding Your First Plugin

### In-Repository Plugin

1. Create plugin directory:
   ```bash
   mkdir -p plugins/my-first-plugin/commands
   ```

2. Create `plugins/my-first-plugin/plugin.json`:
   ```json
   {
     "name": "my-first-plugin",
     "description": "My first Claude Code plugin",
     "version": "1.0.0",
     "author": {
       "name": "Brock"
     },
     "commands": "./commands"
   }
   ```

3. Add command file in `plugins/my-first-plugin/commands/hello.md`

4. Update `.claude-plugin/marketplace.json`:
   ```json
   {
     "plugins": [
       {
         "name": "my-first-plugin",
         "source": "./plugins/my-first-plugin",
         "description": "My first Claude Code plugin",
         "version": "1.0.0"
       }
     ]
   }
   ```

5. Commit and push:
   ```bash
   git add .
   git commit -m "Add my-first-plugin"
   git push
   ```

### External Plugin

To add a plugin from another repository, just add to marketplace.json:

```json
{
  "plugins": [
    {
      "name": "external-plugin",
      "source": {
        "source": "github",
        "repo": "owner/plugin-repo"
      },
      "description": "Plugin from external repository"
    }
  ]
}
```

## 6. Versioning

Use semantic versioning for your marketplace:

```json
{
  "metadata": {
    "version": "1.0.0"
  }
}
```

- **Major (1.x.x)**: Breaking changes to marketplace structure
- **Minor (x.1.x)**: New plugins added
- **Patch (x.x.1)**: Bug fixes, documentation updates

## 7. Team Configuration (Optional)

For team-wide deployment, add to project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "dieshen-plugins": {
      "source": {
        "source": "github",
        "repo": "Dieshen/claude_marketplace"
      }
    }
  },
  "enabledPlugins": [
    "plugin-name@dieshen-plugins"
  ]
}
```

## 8. Validation

Validate your marketplace setup:

```bash
# Check JSON syntax
claude plugin validate .

# List marketplaces
/plugin marketplace list

# Update marketplace
/plugin marketplace update dieshen-plugins

# List available plugins
/plugin
```

## Troubleshooting

### Marketplace won't load
- Check `.claude-plugin/marketplace.json` exists
- Verify JSON is valid
- Ensure repository is accessible

### Plugin won't install
- Verify plugin source path is correct
- Check plugin.json exists (if strict: true)
- Test plugin source manually

### Updates not appearing
- Run `/plugin marketplace update marketplace-name`
- Check git repository is up to date
- Clear cache if needed

## Next Steps

1. Add your actual plugins
2. Update README with plugin descriptions
3. Set up GitHub Actions for validation (optional)
4. Share with your team
5. Promote in Claude Code community

## Resources

- [Claude Code Plugin Documentation](https://docs.claude.com/en/docs/claude-code/plugins)
- [Plugin Development Guide](https://docs.claude.com/en/docs/claude-code/plugins#develop-more-complex-plugins)
- [Marketplace Documentation](https://docs.claude.com/en/docs/claude-code/plugin-marketplaces)

## Support

- **Issues**: https://github.com/Dieshen/claude_marketplace/issues
- **Email**: contact@narcolepticfox.com
