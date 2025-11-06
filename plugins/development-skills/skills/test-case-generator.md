# Test Case Generator Skill

Generate comprehensive test cases from requirements and code.

## Test Case Template

```markdown
## Test Case: {ID} - {Title}

**Priority**: Critical | High | Medium | Low
**Type**: Unit | Integration | E2E | Performance | Security
**Status**: Pending | Pass | Fail | Blocked

### Preconditions
- System is running
- User is authenticated
- Database contains test data

### Test Steps
1. Navigate to login page
2. Enter valid credentials
3. Click "Login" button
4. Verify redirect to dashboard

### Expected Results
- User is logged in
- Dashboard displays user's name
- Session token is stored
- Analytics event is fired

### Actual Results
{To be filled during test execution}

### Test Data
```json
{
  "email": "test@example.com",
  "password": "Test123!"
}
```

### Dependencies
- Database seeded with test user
- Email service mocked

### Notes
- Tests authentication flow
- Covers happy path
```

## Generate Unit Tests

### From Function Specification

**Function**: `calculateDiscount(price: number, couponCode: string): number`

**Requirements**:
- Apply 10% discount for "SAVE10"
- Apply 20% discount for "SAVE20"
- Return original price for invalid codes
- Throw error for negative prices

**Generated Tests**:
```typescript
describe('calculateDiscount', () => {
  it('should apply 10% discount with SAVE10 code', () => {
    expect(calculateDiscount(100, 'SAVE10')).toBe(90);
  });

  it('should apply 20% discount with SAVE20 code', () => {
    expect(calculateDiscount(100, 'SAVE20')).toBe(80);
  });

  it('should return original price for invalid code', () => {
    expect(calculateDiscount(100, 'INVALID')).toBe(100);
  });

  it('should return original price for empty code', () => {
    expect(calculateDiscount(100, '')).toBe(100);
  });

  it('should throw error for negative price', () => {
    expect(() => calculateDiscount(-10, 'SAVE10')).toThrow('Price must be positive');
  });

  it('should handle zero price', () => {
    expect(calculateDiscount(0, 'SAVE10')).toBe(0);
  });

  it('should handle decimal prices', () => {
    expect(calculateDiscount(99.99, 'SAVE10')).toBeCloseTo(89.99, 2);
  });

  it('should be case insensitive for coupon codes', () => {
    expect(calculateDiscount(100, 'save10')).toBe(90);
  });
});
```

## Test Matrix Generation

### Feature: User Registration

| Test Case | Email | Password | Name | Expected Result |
|-----------|-------|----------|------|-----------------|
| TC-001 | valid@email.com | Password123! | John Doe | Success |
| TC-002 | invalid-email | Password123! | John Doe | Validation Error |
| TC-003 | valid@email.com | short | John Doe | Password too short |
| TC-004 | valid@email.com | nouppercasenumber! | John Doe | Password requirements not met |
| TC-005 | valid@email.com | Password123! | "" | Name required error |
| TC-006 | duplicate@email.com | Password123! | Jane Doe | Email already exists |
| TC-007 | valid@email.com | Password123! | A | Success (minimum length) |
| TC-008 | valid@email.com | Password123! | {101 chars} | Name too long error |

## Edge Cases Identification

For any feature, generate tests for:

### Input Validation
- Minimum boundary (0, 1, "")
- Maximum boundary (MAX_INT, max length)
- Just below minimum (-1, empty string)
- Just above maximum (MAX_INT + 1, max length + 1)
- Invalid types (null, undefined, NaN)
- Special characters (', ", <, >, &, SQL injection)
- Unicode characters (emoji, RTL text)

### State Transitions
- Initial state → Valid transition → Expected state
- Invalid state transitions
- Concurrent state changes
- Idempotency (multiple identical requests)

### Error Conditions
- Network failures
- Timeout scenarios
- Partial data
- Corrupted data
- Permission denied
- Resource exhaustion

### Performance
- Single item
- Empty list
- Large dataset (10K+ items)
- Concurrent requests
- Memory leaks
- Long-running operations

## Integration Test Generation

### API Endpoint Testing

```typescript
describe('POST /api/users', () => {
  beforeEach(async () => {
    await db.reset();
  });

  it('should create user with valid data', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({
        email: 'test@example.com',
        name: 'Test User',
        password: 'Test123!'
      });

    expect(response.status).toBe(201);
    expect(response.body).toHaveProperty('id');
    expect(response.body.email).toBe('test@example.com');

    // Verify in database
    const user = await db.users.findByEmail('test@example.com');
    expect(user).toBeDefined();
  });

  it('should reject duplicate email', async () => {
    await db.users.create({ email: 'existing@example.com' });

    const response = await request(app)
      .post('/api/users')
      .send({ email: 'existing@example.com', name: 'Test', password: 'Test123!' });

    expect(response.status).toBe(409);
    expect(response.body.code).toBe('EMAIL_EXISTS');
  });

  it('should hash password before storing', async () => {
    const password = 'PlainTextPassword';

    await request(app)
      .post('/api/users')
      .send({ email: 'test@example.com', name: 'Test', password });

    const user = await db.users.findByEmail('test@example.com');
    expect(user.password).not.toBe(password);
    expect(user.password).toMatch(/^\$2[aby]\$.{56}$/); // bcrypt format
  });
});
```

## E2E Test Scenarios

### User Journey: Complete Purchase

```typescript
test('user can complete purchase from product page to confirmation', async ({ page }) => {
  // 1. Login
  await page.goto('/login');
  await page.fill('[name="email"]', 'buyer@example.com');
  await page.fill('[name="password"]', 'Test123!');
  await page.click('button[type="submit"]');
  await expect(page).toHaveURL('/dashboard');

  // 2. Browse and add to cart
  await page.goto('/products/laptop-pro');
  await page.click('[data-testid="add-to-cart"]');
  await expect(page.locator('[data-testid="cart-count"]')).toHaveText('1');

  // 3. Go to cart
  await page.click('[data-testid="cart-icon"]');
  await expect(page).toHaveURL('/cart');
  await expect(page.locator('[data-testid="cart-item"]')).toHaveCount(1);

  // 4. Proceed to checkout
  await page.click('[data-testid="checkout-button"]');
  await expect(page).toHaveURL('/checkout');

  // 5. Fill shipping info
  await page.fill('[name="address"]', '123 Main St');
  await page.fill('[name="city"]', 'New York');
  await page.fill('[name="zip"]', '10001');
  await page.click('[data-testid="continue-payment"]');

  // 6. Fill payment info (test card)
  await page.fill('[name="cardNumber"]', '4242424242424242');
  await page.fill('[name="expiry"]', '12/25');
  await page.fill('[name="cvc"]', '123');

  // 7. Place order
  await page.click('[data-testid="place-order"]');

  // 8. Verify confirmation
  await expect(page).toHaveURL(/\/orders\/[a-zA-Z0-9]+/);
  await expect(page.locator('text=Order Confirmed')).toBeVisible();

  // 9. Verify email sent (mock)
  expect(emailService.send).toHaveBeenCalledWith(
    expect.objectContaining({
      to: 'buyer@example.com',
      subject: expect.stringContaining('Order Confirmation')
    })
  );
});
```

## Test Data Generation

### Factory Pattern

```typescript
class UserFactory {
  static create(overrides?: Partial<User>): User {
    return {
      id: faker.datatype.uuid(),
      email: faker.internet.email(),
      name: faker.name.fullName(),
      role: 'user',
      createdAt: new Date(),
      ...overrides
    };
  }

  static createAdmin(overrides?: Partial<User>): User {
    return this.create({ role: 'admin', ...overrides });
  }

  static createMany(count: number): User[] {
    return Array.from({ length: count }, () => this.create());
  }
}

// Usage
const user = UserFactory.create({ email: 'specific@example.com' });
const admin = UserFactory.createAdmin();
const users = UserFactory.createMany(100);
```

## Checklist for Complete Test Coverage

### Functionality
- [ ] Happy path (expected usage)
- [ ] Alternative paths
- [ ] Error conditions
- [ ] Edge cases
- [ ] Boundary conditions

### Data
- [ ] Valid data
- [ ] Invalid data
- [ ] Missing data (null, undefined)
- [ ] Empty data
- [ ] Extreme values

### State
- [ ] Initial state
- [ ] Valid state transitions
- [ ] Invalid state transitions
- [ ] Final/terminal states

### Integration
- [ ] Database operations
- [ ] External API calls
- [ ] File system operations
- [ ] Third-party services

### Security
- [ ] Authentication required
- [ ] Authorization enforced
- [ ] Input sanitization
- [ ] SQL injection prevention
- [ ] XSS prevention

### Performance
- [ ] Response time acceptable
- [ ] Handles high load
- [ ] No memory leaks
- [ ] Efficient queries

### Usability
- [ ] Error messages clear
- [ ] Loading states shown
- [ ] Success feedback provided
- [ ] Accessibility requirements met

## Best Practices

1. **Test Behavior, Not Implementation**: Focus on what the code does, not how
2. **One Assert Per Test**: Makes failures easier to diagnose
3. **Descriptive Names**: Test name should describe what and why
4. **Arrange-Act-Assert**: Clear test structure
5. **Independent Tests**: No dependencies between tests
6. **Fast Tests**: Unit tests should run in milliseconds
7. **Deterministic**: Same input always produces same output
8. **Readable**: Tests serve as documentation
