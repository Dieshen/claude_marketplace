# Deployment Checklist

Quick checklist to get your marketplace live on GitHub.

## Pre-Deployment

- [ ] Choose a repository name (suggestion: `claude-code-marketplace` or `claude-plugins`)
- [ ] Decide: new repo or add to existing repo?
- [ ] Have GitHub credentials ready

## Step 1: Create/Update Repository

### Option A: New Repository
```bash
# Create new repo on GitHub, then:
cd /path/to/outputs
git init
git add .
git commit -m "Initial marketplace setup with shadcn-aesthetic plugin"
git branch -M main
git remote add origin https://github.com/Dieshen/claude_marketplace.git
git push -u origin main
```

### Option B: Add to Existing Repository
```bash
cd /path/to/existing/repo
cp -r /path/to/outputs/.claude-plugin .
cp -r /path/to/outputs/plugins .
git add .claude-plugin plugins
git commit -m "Add Claude Code plugin marketplace"
git push
```

## Step 2: Update Placeholders

- [ ] Replace `YOUR-REPO-NAME` in:
  - [ ] README.md (line ~12)
  - [ ] SETUP.md (multiple locations)
  - [ ] CONTRIBUTING.md
  - [ ] plugins/shadcn-aesthetic/README.md

- [ ] Update contact email if needed:
  - [ ] marketplace.json
  - [ ] All README files

- [ ] Verify GitHub username is correct (`narcoleptic-fox`)

## Step 3: Repository Settings

On GitHub:
- [ ] Set repository to **Public**
- [ ] Add description: "Professional Claude Code plugins for enterprise development"
- [ ] Add topics/tags:
  - [ ] `claude-code`
  - [ ] `claude-plugins`
  - [ ] `plugin-marketplace`
  - [ ] `shadcn`
  - [ ] `blazor`
  - [ ] `vibe-ui`
  - [ ] `css`
  - [ ] `design-system`

## Step 4: Test Installation Locally

```bash
# Test from local directory first
/plugin marketplace add ./path/to/repo

# Verify marketplace appears
/plugin marketplace list

# Try installing plugin
/plugin install shadcn-aesthetic@marketplace-name

# Restart Claude Code

# Test it works
# Ask Claude: "Create a button component with modern CSS"
```

## Step 5: Test Installation from GitHub

```bash
# Remove local marketplace
/plugin marketplace remove local-test-name

# Add from GitHub
/plugin marketplace add Dieshen/claude_marketplace

# Install plugin
/plugin install shadcn-aesthetic@dieshen-plugins

# Restart Claude Code

# Verify it works
```

## Step 6: Validation

Create test file to verify CSS output:

```bash
# In Claude Code terminal
echo "Create a modern button component with primary, secondary, and outline variants. Use Vibe.UI naming conventions." > test-prompt.txt
```

Expected output should include:
- [ ] CSS variables (`var(--primary)`)
- [ ] HSL colors (`hsl(var(--primary))`)
- [ ] Proper spacing (`var(--spacing-2)`)
- [ ] Modern transitions (`150ms cubic-bezier`)
- [ ] Focus-visible states
- [ ] No hard-coded colors
- [ ] No random pixel values

## Step 7: Documentation

- [ ] Add screenshot to README showing install command
- [ ] Create example GIF/video (optional but recommended)
- [ ] Add link to Vibe.UI repository
- [ ] Update marketplace description

## Step 8: Announce

Share your marketplace:
- [ ] Post on X/Twitter (mention @AnthropicAI)
- [ ] Share in Claude Discord (#claude-code channel)
- [ ] Post on relevant subreddits (r/ClaudeAI)
- [ ] Add to [claudecodemarketplace.com](https://claudecodemarketplace.com)
- [ ] Add to [claudemarketplaces.com](https://claudemarketplaces.com)

## Step 9: Monitor

First 48 hours:
- [ ] Watch for GitHub issues
- [ ] Monitor stars
- [ ] Check for installation attempts
- [ ] Respond to feedback quickly

## Step 10: Iterate

Based on feedback:
- [ ] Fix any installation issues
- [ ] Add requested features
- [ ] Improve documentation
- [ ] Plan next plugin

## Quick Commands Reference

```bash
# Add marketplace (replace YOUR-REPO-NAME)
/plugin marketplace add narcoleptic-fox/YOUR-REPO-NAME

# List marketplaces
/plugin marketplace list

# Update marketplace
/plugin marketplace update dieshen-plugins

# Install plugin
/plugin install shadcn-aesthetic@dieshen-plugins

# Browse plugins interactively
/plugin

# Remove plugin
/plugin remove shadcn-aesthetic

# Remove marketplace
/plugin marketplace remove dieshen-plugins
```

## Troubleshooting

### "Marketplace not found"
- Verify repository is public
- Check `.claude-plugin/marketplace.json` exists in repo root
- Verify JSON is valid

### "Plugin won't install"
- Check `plugins/shadcn-aesthetic/plugin.json` exists
- Verify source path in marketplace.json is correct
- Try updating marketplace: `/plugin marketplace update`

### "Skill not activating"
- Verify `SKILL.md` file exists
- Check frontmatter has `name:` and `description:`
- Restart Claude Code
- Try asking explicitly: "Use shadcn aesthetic patterns"

### "CSS output unchanged"
- Plugin may not be loaded - check `/plugin` list
- Skill may need explicit trigger - mention "modern CSS" or "shadcn"
- Try more specific prompt: "Create a button using shadcn-aesthetic patterns"

## Success Indicators

✅ Plugin appears in `/plugin` list
✅ CSS uses CSS variables
✅ Colors are HSL format
✅ Spacing uses consistent scale
✅ No hard-coded colors or random pixels
✅ Dark mode variables present
✅ Focus-visible states included

## Next Plugin Ideas

Once shadcn-aesthetic is stable:
1. **crisp-architect** - CRISP architecture scaffolding
2. **dotnet-enterprise** - .NET patterns and security
3. **rust-performance** - RONN integration and optimization
4. **vibe-ui-generator** - Vibe.UI component creation

## Support

If you run into issues:
1. Check [Claude Code docs](https://docs.claude.com/en/docs/claude-code/plugins)
2. Ask in Claude Discord
3. Open issue on marketplace repo
4. Email: contact@narcolepticfox.com

---

**Ready to deploy?** Just work through this checklist step by step. You got this! 🚀
