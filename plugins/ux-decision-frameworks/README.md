# UX Decision Frameworks Plugin

A comprehensive UI/UX decision-making plugin for Claude Code based on 150,000+ hours of research from Nielsen Norman Group, Baymard Institute, Material Design, and Apple Human Interface Guidelines.

## Overview

This plugin provides immediately actionable decision frameworks and patterns for making informed UX decisions without additional research. Instead of searching for "should I use a modal or drawer?", you can use these research-backed frameworks to make confident decisions.

## What's Included

### Commands (Interactive Decision Tools)

**`/decision-frameworks`** - Main decision framework tool
- Overlay selection (modal/drawer/popover/tooltip)
- Navigation pattern selection
- Loading indicator selection
- Form validation timing
- Touch target sizing by context

**`/overlay-selector`** - Interactive overlay decision tool
- Step-by-step decision tree for choosing overlays
- Specifications for modals, drawers, popovers, tooltips
- Accessible code examples
- Common anti-patterns to avoid

**`/navigation-patterns`** - Navigation pattern selector
- Bottom tab bars, navigation drawers, top navigation
- Platform-specific implementations (iOS, Android, Web)
- Breadcrumb guidance
- Sidebar navigation

**`/form-design`** - Form design expert
- Label placement (research-backed: top-aligned always)
- Validation timing framework
- Error message writing
- Field width guidelines
- Production-ready form templates

**`/accessibility-checker`** - WCAG 2.1 compliance expert
- WCAG 2.1 AA/AAA audit checklist
- Common ARIA patterns
- Contrast ratio checker
- Screen reader testing guide
- Quick accessibility fixes

**`/mobile-patterns`** - Mobile UX patterns
- Touch target sizing (position-based)
- One-handed thumb zones
- Bottom sheets
- Pull-to-refresh
- Platform conventions (iOS vs Android)
- Haptic feedback (iOS)

**`/loading-states`** - Loading & feedback patterns
- Skeleton screens vs spinners vs progress bars
- Optimistic UI patterns
- Toast notifications vs inline alerts
- Progressive image loading
- Performance perception techniques

### Agents (Complex Task Automation)

**`ux-audit-agent`** - Comprehensive UX audits
- Systematic evaluation against Nielsen's 10 heuristics
- WCAG 2.1 accessibility audit
- Visual design review
- Prioritized recommendations with code examples
- Impact/effort matrix for prioritization

**`component-builder`** - Research-backed component builder
- Builds production-ready, accessible components
- Complete state management (default, hover, focus, active, disabled, loading, error)
- Full TypeScript support
- Comprehensive documentation
- Research citations for design decisions

## Key Research Findings

### Nielsen Norman Group
- **Visible navigation:** 20% higher task success than hidden patterns
- **F-pattern reading:** First words on left get more attention
- **Cognitive load:** 7±2 item limit for working memory
- **Loading timing:** <1s no indicator, 1-2s spinner, >10s progress bar

### Baymard Institute
- **Form design:** 35% average conversion increase with proper design
- **Single column:** Prevents 3x more interpretation errors
- **26% abandon:** Due to complex checkouts

### Material Design & Apple HIG
- **Touch targets:** 48×48dp (Android), 44-48pt (iOS) minimum
- **Spacing:** 8dp/pt minimum between targets
- **Thumb zones:** 49% one-handed use, 75% thumb-driven

### WCAG 2.1
- **Contrast:** 4.5:1 for normal text, 3:1 for large text/UI
- **Focus indicators:** 3:1 contrast, 2px minimum thickness
- **Touch targets:** 44×44px minimum (Level AAA)

## Usage Examples

### Example 1: Choosing an Overlay Pattern

```bash
# Use the overlay selector command
/overlay-selector

# Claude will ask questions:
"What content needs to be displayed?"
"Is this a critical action?"
"Will users need to see the main page?"

# Then provides recommendation with code
```

### Example 2: Designing a Form

```bash
# Use the form design expert
/form-design

# Get guidance on:
- Label placement (top-aligned, not placeholders)
- Validation timing (onBlur, not during typing)
- Error display (inline + summary)
- Field width guidelines
```

### Example 3: Running a UX Audit

```bash
# Launch the UX audit agent
# This agent will systematically evaluate your interface

# Get detailed report with:
- Critical issues (WCAG violations)
- Usability problems (Nielsen's heuristics)
- Prioritized recommendations
- Code examples for fixes
```

### Example 4: Building an Accessible Component

```bash
# Use the component builder agent

# Get production-ready components with:
- Full WCAG 2.1 AA compliance
- Complete state management
- TypeScript types
- Accessibility documentation
- Research citations
```

## Decision Framework Examples

### Overlay Selection

```
STEP 1: Is the interaction critical/blocking?
├─ YES → Modal
└─ NO → Continue to Step 2

STEP 2: Should page context remain visible?
├─ NO → Modal (if complex) or Full-page transition
└─ YES → Continue to Step 3

STEP 3: Is content element-specific?
├─ YES → Continue to Step 4
└─ NO → Drawer (for filters, settings, lists)

STEP 4: Is content interactive or informational only?
├─ Interactive → Popover
└─ Informational only → Tooltip
```

### Navigation Pattern

```
IF destinations = 2 → Segmented control (iOS) / Tabs (Android)
IF destinations = 3-5 + Equal importance → Bottom tabs
IF destinations > 5 OR Mixed importance → Navigation drawer
```

### Loading Indicator

```
IF duration < 1 second → NO INDICATOR
IF duration 1-2 seconds → Minimal spinner
IF duration 2-10 seconds (full page) → Skeleton screen
IF duration > 10 seconds → Progress bar with estimate
```

## Anti-Patterns Flagged

The plugin actively warns about common UX mistakes:

- ❌ Placeholder as label (WCAG violation)
- ❌ Hamburger menu on desktop (reduces engagement 50%)
- ❌ Validating during typing (hostile UX)
- ❌ Touch targets <44px (accessibility fail)
- ❌ Generic error messages ("Invalid input")
- ❌ Interactive links in toasts (WCAG violation)

## Accessibility Standards

All patterns and components meet:
- **WCAG 2.1 Level AA** minimum (AAA when possible)
- **Keyboard navigation** fully supported
- **Screen reader compatible** (VoiceOver, TalkBack, NVDA)
- **Touch target sizing** per platform guidelines
- **Color contrast** compliant

## Platform Support

Includes patterns and specifications for:
- **Web Desktop** - Responsive design, keyboard-first
- **Web Mobile** - Touch-optimized, thumb zones
- **iOS** - Apple HIG conventions, haptic feedback
- **Android** - Material Design 3, bottom navigation
- **Cross-platform** - React Native, Flutter considerations

## Research Sources

- **Nielsen Norman Group** - Usability heuristics, interaction patterns
- **Baymard Institute** - 150,000+ hours of e-commerce UX research
- **Material Design** - Google's design system
- **Apple HIG** - iOS and macOS human interface guidelines
- **WCAG 2.1/2.2** - Web accessibility standards
- **W3C ARIA** - Accessible Rich Internet Applications
- **Academic Research** - Cognitive load theory (Sweller), working memory (Miller), choice paradox (Schwartz)

## Benefits

✅ **Make informed decisions** - Research-backed frameworks eliminate guesswork
✅ **Save time** - No need to search for UX best practices
✅ **Ensure accessibility** - WCAG 2.1 compliance built-in
✅ **Improve conversions** - Apply proven patterns (e.g., Baymard's 35% increase)
✅ **Avoid common mistakes** - Anti-pattern warnings prevent UX pitfalls
✅ **Platform-appropriate** - iOS, Android, Web conventions respected
✅ **Production-ready code** - Copy-paste accessible components

## Installation

This plugin is part of the Claude Marketplace. To use:

1. Install via Claude Code marketplace
2. Access commands with `/` prefix (e.g., `/form-design`)
3. Launch agents for complex tasks

## Contributing

This plugin synthesizes authoritative UX research into actionable frameworks. Contributions should:
- Reference credible sources (NNG, Baymard, W3C, Material Design, Apple HIG)
- Include specific measurements and specifications
- Provide code examples
- Maintain accessibility standards

## License

MIT License - See LICENSE file for details

## Author

Brock / Narcoleptic Fox LLC
- Email: contact@narcolepticfox.com
- GitHub: https://github.com/Dieshen/claude_marketplace

## Version

1.0.0 - Initial release with comprehensive decision frameworks, accessibility tools, and component builders based on 150,000+ hours of UX research.
