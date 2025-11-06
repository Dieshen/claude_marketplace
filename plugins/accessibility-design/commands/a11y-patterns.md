# Accessibility & Inclusive Design Patterns

Comprehensive accessibility patterns following WCAG 2.2 guidelines and ARIA best practices.

## WCAG 2.2 Principles (POUR)

### Perceivable
Information and UI components must be presentable to users in ways they can perceive.

### Operable
UI components and navigation must be operable.

### Understandable
Information and operation of UI must be understandable.

### Robust
Content must be robust enough to be interpreted by various user agents, including assistive technologies.

## Semantic HTML

```html
<!-- Good: Semantic structure -->
<header>
  <nav aria-label="Main navigation">
    <ul>
      <li><a href="/">Home</a></li>
      <li><a href="/about">About</a></li>
    </ul>
  </nav>
</header>

<main>
  <article>
    <h1>Page Title</h1>
    <p>Content...</p>
  </article>

  <aside aria-label="Related content">
    <h2>Related Articles</h2>
  </aside>
</main>

<footer>
  <p>&copy; 2024 Company Name</p>
</footer>

<!-- Bad: Non-semantic -->
<div class="header">
  <div class="nav">
    <div class="link">Home</div>
  </div>
</div>
```

## ARIA Attributes

### Landmarks
```html
<nav aria-label="Primary navigation">
<main role="main">
<aside aria-label="Sidebar">
<footer role="contentinfo">
```

### Live Regions
```html
<!-- Announce changes immediately -->
<div role="alert" aria-live="assertive">
  Error: Please correct the form errors.
</div>

<!-- Announce when convenient -->
<div aria-live="polite" aria-atomic="true">
  5 new messages
</div>

<!-- Status messages -->
<div role="status" aria-live="polite">
  Item added to cart
</div>
```

### Form Accessibility

```html
<!-- Proper labeling -->
<label for="email">Email Address</label>
<input
  type="email"
  id="email"
  name="email"
  required
  aria-required="true"
  aria-describedby="email-error email-help"
/>
<span id="email-help">We'll never share your email</span>
<span id="email-error" role="alert" aria-live="polite">
  <!-- Error message appears here -->
</span>

<!-- Grouped inputs -->
<fieldset>
  <legend>Contact Preferences</legend>
  <div>
    <input type="checkbox" id="email-pref" name="contact" value="email" />
    <label for="email-pref">Email</label>
  </div>
  <div>
    <input type="checkbox" id="phone-pref" name="contact" value="phone" />
    <label for="phone-pref">Phone</label>
  </div>
</fieldset>

<!-- Radio groups -->
<fieldset>
  <legend>Subscription Type</legend>
  <div>
    <input type="radio" id="free" name="subscription" value="free" checked />
    <label for="free">Free</label>
  </div>
  <div>
    <input type="radio" id="premium" name="subscription" value="premium" />
    <label for="premium">Premium</label>
  </div>
</fieldset>
```

## Keyboard Navigation

```typescript
// React component with keyboard support
function DropdownMenu({ items }) {
  const [isOpen, setIsOpen] = useState(false);
  const [focusedIndex, setFocusedIndex] = useState(0);
  const buttonRef = useRef<HTMLButtonElement>(null);
  const menuRef = useRef<HTMLDivElement>(null);

  const handleKeyDown = (e: KeyboardEvent) => {
    switch (e.key) {
      case 'Enter':
      case ' ':
        e.preventDefault();
        setIsOpen(!isOpen);
        break;

      case 'Escape':
        setIsOpen(false);
        buttonRef.current?.focus();
        break;

      case 'ArrowDown':
        e.preventDefault();
        if (!isOpen) {
          setIsOpen(true);
        } else {
          setFocusedIndex((prev) => (prev + 1) % items.length);
        }
        break;

      case 'ArrowUp':
        e.preventDefault();
        if (isOpen) {
          setFocusedIndex((prev) => (prev - 1 + items.length) % items.length);
        }
        break;

      case 'Home':
        e.preventDefault();
        setFocusedIndex(0);
        break;

      case 'End':
        e.preventDefault();
        setFocusedIndex(items.length - 1);
        break;
    }
  };

  return (
    <div onKeyDown={handleKeyDown}>
      <button
        ref={buttonRef}
        aria-haspopup="true"
        aria-expanded={isOpen}
        onClick={() => setIsOpen(!isOpen)}
      >
        Menu
      </button>

      {isOpen && (
        <div
          ref={menuRef}
          role="menu"
          aria-orientation="vertical"
        >
          {items.map((item, index) => (
            <button
              key={item.id}
              role="menuitem"
              tabIndex={index === focusedIndex ? 0 : -1}
              onClick={() => item.onClick()}
            >
              {item.label}
            </button>
          ))}
        </div>
      )}
    </div>
  );
}
```

## Focus Management

```typescript
// Trap focus in modal
function Modal({ isOpen, onClose, children }) {
  const modalRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!isOpen) return;

    const modal = modalRef.current;
    if (!modal) return;

    const focusableElements = modal.querySelectorAll(
      'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
    );

    const firstElement = focusableElements[0] as HTMLElement;
    const lastElement = focusableElements[focusableElements.length - 1] as HTMLElement;

    // Focus first element
    firstElement?.focus();

    const handleTabKey = (e: KeyboardEvent) => {
      if (e.key !== 'Tab') return;

      if (e.shiftKey) {
        // Shift + Tab
        if (document.activeElement === firstElement) {
          e.preventDefault();
          lastElement?.focus();
        }
      } else {
        // Tab
        if (document.activeElement === lastElement) {
          e.preventDefault();
          firstElement?.focus();
        }
      }
    };

    modal.addEventListener('keydown', handleTabKey);

    return () => {
      modal.removeEventListener('keydown', handleTabKey);
    };
  }, [isOpen]);

  if (!isOpen) return null;

  return (
    <div
      ref={modalRef}
      role="dialog"
      aria-modal="true"
      aria-labelledby="modal-title"
    >
      <h2 id="modal-title">Modal Title</h2>
      {children}
      <button onClick={onClose}>Close</button>
    </div>
  );
}
```

## Color Contrast

```css
/* WCAG AA requires 4.5:1 for normal text, 3:1 for large text */
/* WCAG AAA requires 7:1 for normal text, 4.5:1 for large text */

.button-primary {
  /* Good contrast: 7.2:1 */
  background: #0066cc;
  color: #ffffff;
}

.button-secondary {
  /* Good contrast: 4.6:1 */
  background: #f0f0f0;
  color: #333333;
}

/* Don't rely on color alone */
.error {
  color: #cc0000;
}

.error::before {
  content: '⚠ '; /* Visual indicator */
}

.error[aria-invalid="true"] {
  /* Also announced to screen readers */
}
```

## Skip Links

```html
<a href="#main-content" class="skip-link">
  Skip to main content
</a>

<style>
.skip-link {
  position: absolute;
  top: -40px;
  left: 0;
  background: #000;
  color: #fff;
  padding: 8px;
  z-index: 100;
}

.skip-link:focus {
  top: 0;
}
</style>
```

## Images and Alt Text

```html
<!-- Informative image -->
<img src="chart.png" alt="Sales increased by 25% in Q4 2024" />

<!-- Decorative image -->
<img src="decorative.png" alt="" role="presentation" />

<!-- Complex image -->
<figure>
  <img src="complex-chart.png" alt="Detailed sales data" />
  <figcaption>
    <details>
      <summary>Chart description</summary>
      <p>Detailed text description of the chart data...</p>
    </details>
  </figcaption>
</figure>

<!-- Icon with text -->
<button>
  <svg aria-hidden="true"><path d="..." /></svg>
  <span>Delete</span>
</button>

<!-- Icon without text -->
<button aria-label="Delete item">
  <svg aria-hidden="true"><path d="..." /></svg>
</button>
```

## Screen Reader-Only Content

```css
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border-width: 0;
}

.sr-only-focusable:focus {
  position: static;
  width: auto;
  height: auto;
  overflow: visible;
  clip: auto;
  white-space: normal;
}
```

```html
<button>
  <svg aria-hidden="true">...</svg>
  <span class="sr-only">Settings</span>
</button>
```

## Responsive and Touch-Friendly

```css
/* Minimum touch target size: 44x44px */
button,
a {
  min-height: 44px;
  min-width: 44px;
  padding: 12px 24px;
}

/* Ensure adequate spacing */
.button-group button {
  margin: 4px;
}
```

## Headings Hierarchy

```html
<!-- Good: Logical hierarchy -->
<h1>Page Title</h1>
  <h2>Section 1</h2>
    <h3>Subsection 1.1</h3>
    <h3>Subsection 1.2</h3>
  <h2>Section 2</h2>

<!-- Bad: Skipped levels -->
<h1>Page Title</h1>
  <h3>Section</h3> <!-- Skipped h2 -->
```

## Tables

```html
<table>
  <caption>Monthly Sales Report</caption>
  <thead>
    <tr>
      <th scope="col">Month</th>
      <th scope="col">Sales</th>
      <th scope="col">Growth</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">January</th>
      <td>$10,000</td>
      <td>+5%</td>
    </tr>
  </tbody>
</table>
```

## Loading States

```typescript
function DataList() {
  const { data, isLoading } = useQuery('data');

  if (isLoading) {
    return (
      <div role="status" aria-live="polite" aria-busy="true">
        <span className="sr-only">Loading data...</span>
        <Spinner aria-hidden="true" />
      </div>
    );
  }

  return (
    <div role="region" aria-label="Data list">
      {data.map(item => <Item key={item.id} {...item} />)}
    </div>
  );
}
```

## Testing Accessibility

### Automated Testing
```typescript
import { axe, toHaveNoViolations } from 'jest-axe';

expect.extend(toHaveNoViolations);

test('page has no accessibility violations', async () => {
  const { container } = render(<App />);
  const results = await axe(container);
  expect(results).toHaveNoViolations();
});
```

### Manual Testing Checklist
- [ ] Keyboard navigation works
- [ ] Screen reader announces correctly
- [ ] Color contrast meets WCAG AA
- [ ] Forms have proper labels
- [ ] Images have alt text
- [ ] Headings are hierarchical
- [ ] Focus indicators are visible
- [ ] Touch targets are adequate
- [ ] No color-only information
- [ ] Text can be resized to 200%

## Reduced Motion

```css
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

```typescript
function AnimatedComponent() {
  const prefersReducedMotion = useMediaQuery('(prefers-reduced-motion: reduce)');

  return (
    <motion.div
      animate={{ opacity: 1 }}
      transition={{ duration: prefersReducedMotion ? 0 : 0.3 }}
    >
      Content
    </motion.div>
  );
}
```

## Best Practices

1. **Use semantic HTML**
2. **Provide text alternatives**
3. **Ensure keyboard accessibility**
4. **Maintain sufficient color contrast**
5. **Create logical heading structure**
6. **Label form inputs properly**
7. **Make focus indicators visible**
8. **Support screen readers**
9. **Test with real assistive technologies**
10. **Follow WCAG 2.2 guidelines**
