# Testing & Quality Assurance Patterns

Comprehensive testing strategies and patterns across languages and frameworks.

## Unit Testing Patterns

### Test Structure: Arrange-Act-Assert (AAA)

```typescript
// TypeScript with Jest
describe('UserService', () => {
  it('should create user with valid data', async () => {
    // Arrange
    const userData = { email: 'test@example.com', name: 'Test User' };
    const mockRepository = {
      save: jest.fn().mockResolvedValue({ id: 1, ...userData })
    };
    const service = new UserService(mockRepository);

    // Act
    const result = await service.createUser(userData);

    // Assert
    expect(result.id).toBe(1);
    expect(result.email).toBe(userData.email);
    expect(mockRepository.save).toHaveBeenCalledWith(userData);
  });
});
```

### Python with pytest

```python
import pytest
from myapp.services import UserService
from unittest.mock import Mock, AsyncMock

class TestUserService:
    @pytest.fixture
    def mock_repository(self):
        repo = Mock()
        repo.save = AsyncMock(return_value={'id': 1, 'email': 'test@example.com'})
        return repo

    @pytest.fixture
    def service(self, mock_repository):
        return UserService(mock_repository)

    @pytest.mark.asyncio
    async def test_create_user_with_valid_data(self, service, mock_repository):
        # Arrange
        user_data = {'email': 'test@example.com', 'name': 'Test User'}

        # Act
        result = await service.create_user(user_data)

        # Assert
        assert result['id'] == 1
        assert result['email'] == user_data['email']
        mock_repository.save.assert_called_once_with(user_data)
```

### Go Table-Driven Tests

```go
package user_test

import (
    "testing"
    "github.com/stretchr/testify/assert"
    "github.com/stretchr/testify/mock"
)

type MockRepository struct {
    mock.Mock
}

func (m *MockRepository) Save(user *User) error {
    args := m.Called(user)
    return args.Error(0)
}

func TestUserService_CreateUser(t *testing.T) {
    tests := []struct {
        name        string
        input       *User
        mockSetup   func(*MockRepository)
        wantErr     bool
        errContains string
    }{
        {
            name: "valid user",
            input: &User{Email: "test@example.com", Name: "Test"},
            mockSetup: func(m *MockRepository) {
                m.On("Save", mock.Anything).Return(nil)
            },
            wantErr: false,
        },
        {
            name: "invalid email",
            input: &User{Email: "invalid", Name: "Test"},
            mockSetup: func(m *MockRepository) {},
            wantErr: true,
            errContains: "invalid email",
        },
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            // Arrange
            mockRepo := new(MockRepository)
            tt.mockSetup(mockRepo)
            service := NewUserService(mockRepo)

            // Act
            err := service.CreateUser(tt.input)

            // Assert
            if tt.wantErr {
                assert.Error(t, err)
                assert.Contains(t, err.Error(), tt.errContains)
            } else {
                assert.NoError(t, err)
                mockRepo.AssertExpectations(t)
            }
        })
    }
}
```

### Rust with rstest

```rust
#[cfg(test)]
mod tests {
    use super::*;
    use rstest::*;
    use mockall::predicate::*;
    use mockall::mock;

    mock! {
        Repository {}
        impl UserRepository for Repository {
            fn save(&self, user: &User) -> Result<User, Error>;
        }
    }

    #[fixture]
    fn user_data() -> UserData {
        UserData {
            email: "test@example.com".to_string(),
            name: "Test User".to_string(),
        }
    }

    #[rstest]
    fn test_create_user_success(user_data: UserData) {
        // Arrange
        let mut mock_repo = MockRepository::new();
        mock_repo
            .expect_save()
            .times(1)
            .returning(|user| Ok(user.clone()));

        let service = UserService::new(mock_repo);

        // Act
        let result = service.create_user(user_data.clone());

        // Assert
        assert!(result.is_ok());
        let user = result.unwrap();
        assert_eq!(user.email, user_data.email);
    }

    #[rstest]
    #[case("invalid-email", "Test", "invalid email")]
    #[case("test@example.com", "", "name required")]
    fn test_create_user_validation_errors(
        #[case] email: &str,
        #[case] name: &str,
        #[case] expected_error: &str
    ) {
        let mock_repo = MockRepository::new();
        let service = UserService::new(mock_repo);

        let user_data = UserData {
            email: email.to_string(),
            name: name.to_string(),
        };

        let result = service.create_user(user_data);
        assert!(result.is_err());
        assert!(result.unwrap_err().to_string().contains(expected_error));
    }
}
```

## Test Data Builders Pattern

### TypeScript

```typescript
class UserBuilder {
  private user: Partial<User> = {
    email: 'test@example.com',
    name: 'Test User',
    role: 'user',
    active: true,
  };

  withEmail(email: string): this {
    this.user.email = email;
    return this;
  }

  withRole(role: string): this {
    this.user.role = role;
    return this;
  }

  inactive(): this {
    this.user.active = false;
    return this;
  }

  build(): User {
    return this.user as User;
  }
}

// Usage in tests
const adminUser = new UserBuilder()
  .withEmail('admin@example.com')
  .withRole('admin')
  .build();

const inactiveUser = new UserBuilder()
  .inactive()
  .build();
```

### Python Factory Boy

```python
import factory
from factory import fuzzy
from myapp.models import User, Post

class UserFactory(factory.Factory):
    class Meta:
        model = User

    email = factory.Sequence(lambda n: f'user{n}@example.com')
    name = factory.Faker('name')
    role = 'user'
    active = True

class AdminUserFactory(UserFactory):
    role = 'admin'

class PostFactory(factory.Factory):
    class Meta:
        model = Post

    title = factory.Faker('sentence')
    content = factory.Faker('text')
    author = factory.SubFactory(UserFactory)
    published_at = factory.Faker('date_time_this_year')

# Usage in tests
def test_user_can_create_post():
    user = UserFactory()
    post = PostFactory(author=user)
    assert post.author.id == user.id

def test_admin_has_permissions():
    admin = AdminUserFactory()
    assert admin.role == 'admin'
```

## Integration Testing Patterns

### Database Integration Tests (TypeScript)

```typescript
import { DataSource } from 'typeorm';

describe('UserRepository Integration Tests', () => {
  let dataSource: DataSource;
  let repository: UserRepository;

  beforeAll(async () => {
    // Setup test database
    dataSource = new DataSource({
      type: 'postgres',
      host: 'localhost',
      port: 5433, // Test DB port
      database: 'test_db',
      entities: [User],
      synchronize: true,
    });
    await dataSource.initialize();
    repository = new UserRepository(dataSource);
  });

  afterAll(async () => {
    await dataSource.destroy();
  });

  beforeEach(async () => {
    // Clean database before each test
    await dataSource.synchronize(true);
  });

  it('should persist and retrieve user', async () => {
    const userData = { email: 'test@example.com', name: 'Test' };

    const saved = await repository.save(userData);
    expect(saved.id).toBeDefined();

    const retrieved = await repository.findById(saved.id);
    expect(retrieved?.email).toBe(userData.email);
  });

  it('should enforce unique email constraint', async () => {
    const userData = { email: 'unique@example.com', name: 'Test' };

    await repository.save(userData);

    await expect(
      repository.save(userData)
    ).rejects.toThrow(/duplicate key/);
  });
});
```

### API Integration Tests (Python with pytest)

```python
import pytest
from httpx import AsyncClient
from myapp.main import app

@pytest.fixture
async def client():
    async with AsyncClient(app=app, base_url="http://test") as ac:
        yield ac

@pytest.fixture
async def authenticated_client(client):
    # Login and get token
    response = await client.post("/auth/login", json={
        "email": "test@example.com",
        "password": "password123"
    })
    token = response.json()["access_token"]
    client.headers["Authorization"] = f"Bearer {token}"
    return client

@pytest.mark.asyncio
async def test_create_user_endpoint(client):
    response = await client.post("/users", json={
        "email": "new@example.com",
        "name": "New User"
    })

    assert response.status_code == 201
    data = response.json()
    assert data["email"] == "new@example.com"
    assert "id" in data

@pytest.mark.asyncio
async def test_get_protected_resource(authenticated_client):
    response = await authenticated_client.get("/users/me")

    assert response.status_code == 200
    assert response.json()["email"] == "test@example.com"
```

## End-to-End Testing

### Playwright (TypeScript)

```typescript
import { test, expect } from '@playwright/test';

test.describe('User Registration Flow', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
  });

  test('should register new user successfully', async ({ page }) => {
    // Navigate to registration
    await page.click('text=Sign Up');

    // Fill form
    await page.fill('[data-testid="email-input"]', 'newuser@example.com');
    await page.fill('[data-testid="password-input"]', 'SecurePass123!');
    await page.fill('[data-testid="name-input"]', 'New User');

    // Submit
    await page.click('[data-testid="submit-button"]');

    // Verify success
    await expect(page.locator('text=Welcome')).toBeVisible();
    await expect(page).toHaveURL(/\/dashboard/);
  });

  test('should show validation errors', async ({ page }) => {
    await page.click('text=Sign Up');

    // Submit empty form
    await page.click('[data-testid="submit-button"]');

    // Check for error messages
    await expect(page.locator('text=Email is required')).toBeVisible();
    await expect(page.locator('text=Password is required')).toBeVisible();
  });

  test('should handle server errors gracefully', async ({ page }) => {
    // Intercept API call and force error
    await page.route('**/api/auth/register', route =>
      route.fulfill({ status: 500, body: 'Server Error' })
    );

    await page.click('text=Sign Up');
    await page.fill('[data-testid="email-input"]', 'test@example.com');
    await page.fill('[data-testid="password-input"]', 'password123');
    await page.click('[data-testid="submit-button"]');

    await expect(page.locator('text=Something went wrong')).toBeVisible();
  });
});

// Page Object Model pattern
class LoginPage {
  constructor(private page: Page) {}

  async navigate() {
    await this.page.goto('/login');
  }

  async login(email: string, password: string) {
    await this.page.fill('[data-testid="email-input"]', email);
    await this.page.fill('[data-testid="password-input"]', password);
    await this.page.click('[data-testid="login-button"]');
  }

  async getErrorMessage() {
    return this.page.locator('[data-testid="error-message"]').textContent();
  }
}

test('login with invalid credentials', async ({ page }) => {
  const loginPage = new LoginPage(page);
  await loginPage.navigate();
  await loginPage.login('wrong@example.com', 'wrongpass');

  const error = await loginPage.getErrorMessage();
  expect(error).toContain('Invalid credentials');
});
```

## Test Coverage and Quality Metrics

### Jest Coverage Configuration

```javascript
// jest.config.js
module.exports = {
  collectCoverageFrom: [
    'src/**/*.{js,ts}',
    '!src/**/*.d.ts',
    '!src/**/*.test.{js,ts}',
    '!src/**/index.{js,ts}',
  ],
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80,
    },
    './src/critical/**/*.ts': {
      branches: 95,
      functions: 95,
      lines: 95,
      statements: 95,
    },
  },
  coverageReporters: ['text', 'lcov', 'html'],
};
```

### pytest-cov Configuration

```ini
# pytest.ini
[tool:pytest]
testpaths = tests
python_files = test_*.py
python_classes = Test*
python_functions = test_*
addopts =
    --cov=myapp
    --cov-report=html
    --cov-report=term-missing
    --cov-fail-under=80
    --cov-branch
```

## Mocking and Stubbing Strategies

### Mocking External APIs

```typescript
// Using MSW (Mock Service Worker)
import { rest } from 'msw';
import { setupServer } from 'msw/node';

const handlers = [
  rest.get('https://api.github.com/users/:username', (req, res, ctx) => {
    const { username } = req.params;
    return res(
      ctx.status(200),
      ctx.json({
        login: username,
        name: 'Test User',
        public_repos: 42,
      })
    );
  }),

  rest.post('https://api.stripe.com/v1/charges', (req, res, ctx) => {
    return res(
      ctx.status(200),
      ctx.json({
        id: 'ch_test_123',
        status: 'succeeded',
        amount: 1000,
      })
    );
  }),
];

const server = setupServer(...handlers);

beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());

test('fetches user from GitHub', async () => {
  const user = await fetchGithubUser('testuser');
  expect(user.name).toBe('Test User');
  expect(user.public_repos).toBe(42);
});
```

### Time Mocking

```typescript
import { jest } from '@jest/globals';

test('schedules task for future execution', () => {
  jest.useFakeTimers();
  const callback = jest.fn();

  scheduleTask(callback, 5000);

  expect(callback).not.toHaveBeenCalled();

  jest.advanceTimersByTime(5000);

  expect(callback).toHaveBeenCalledTimes(1);

  jest.useRealTimers();
});
```

## Snapshot Testing

```typescript
import renderer from 'react-test-renderer';

test('UserCard renders correctly', () => {
  const user = {
    name: 'John Doe',
    email: 'john@example.com',
    avatar: 'https://example.com/avatar.jpg',
  };

  const tree = renderer.create(<UserCard user={user} />).toJSON();
  expect(tree).toMatchSnapshot();
});

// Inline snapshots
test('formats currency correctly', () => {
  expect(formatCurrency(1234.56)).toMatchInlineSnapshot(`"$1,234.56"`);
  expect(formatCurrency(0)).toMatchInlineSnapshot(`"$0.00"`);
});
```

## Contract Testing

```typescript
// Pact consumer test
import { Pact } from '@pact-foundation/pact';

const provider = new Pact({
  consumer: 'FrontendApp',
  provider: 'UserAPI',
});

describe('User API Contract', () => {
  beforeAll(() => provider.setup());
  afterAll(() => provider.finalize());

  test('get user by id', async () => {
    await provider.addInteraction({
      state: 'user exists',
      uponReceiving: 'a request for user',
      withRequest: {
        method: 'GET',
        path: '/users/123',
        headers: { Accept: 'application/json' },
      },
      willRespondWith: {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
        body: {
          id: 123,
          name: 'John Doe',
          email: 'john@example.com',
        },
      },
    });

    const api = new UserAPI(provider.mockService.baseUrl);
    const user = await api.getUser(123);

    expect(user.name).toBe('John Doe');
    await provider.verify();
  });
});
```

## Best Practices

### 1. Test Independence
- Each test should be independent and not rely on other tests
- Use beforeEach/afterEach for setup and teardown
- Avoid shared mutable state

### 2. Test Naming
```typescript
// Good: Describes what is being tested and expected outcome
test('should return 404 when user does not exist', () => {});
test('should send email notification after successful registration', () => {});

// Bad: Vague or unclear
test('test1', () => {});
test('it works', () => {});
```

### 3. Avoid Test Interdependence
```typescript
// Bad
let userId: number;

test('creates user', async () => {
  userId = await createUser({ name: 'Test' });
});

test('updates user', async () => {
  await updateUser(userId, { name: 'Updated' }); // Depends on previous test
});

// Good
test('updates user', async () => {
  const user = await createUser({ name: 'Test' });
  await updateUser(user.id, { name: 'Updated' });
});
```

### 4. Test the Interface, Not Implementation
```typescript
// Bad: Testing implementation details
test('should call internal method', () => {
  const service = new UserService();
  const spy = jest.spyOn(service as any, '_validateEmail');
  service.createUser({ email: 'test@example.com' });
  expect(spy).toHaveBeenCalled();
});

// Good: Testing behavior
test('should reject invalid email', async () => {
  const service = new UserService();
  await expect(
    service.createUser({ email: 'invalid' })
  ).rejects.toThrow('Invalid email');
});
```

### 5. Use Fixtures and Factories
Keep test data DRY and maintainable

### 6. Avoid Testing External Dependencies Directly
Mock external services and APIs

### 7. Keep Tests Fast
- Use in-memory databases for tests
- Mock expensive operations
- Run unit tests in parallel
- Separate slow integration/E2E tests

### 8. Measure What Matters
- Focus on critical paths
- Aim for meaningful coverage, not just high percentages
- Test edge cases and error conditions
