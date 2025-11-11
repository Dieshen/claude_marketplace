# Narcoleptic Fox Claude Code Plugin Marketplace

A collection of professional development tools and plugins for Claude Code.

## Installation

Add this marketplace to your Claude Code installation:

```bash
/plugin marketplace add Dieshen/claude_marketplace
```

## Available Plugins

### 🏗️ CRISP Architecture Suite
**Category**: Architecture | **Command**: `/scaffold`

Clean, Reusable, Isolated, Simple, Pragmatic scaffolding patterns for modern applications. Helps you design and build well-structured projects with:
- Industry-standard architecture patterns (Layered, Hexagonal, Clean Architecture)
- Project scaffolding for various scales and tech stacks
- Best practices for separation of concerns
- Dependency injection patterns
- Testing strategies

**Use when**: Starting new projects, refactoring existing codebases, or establishing team standards.

---

### 🔷 Enterprise .NET Patterns
**Category**: Backend/.NET | **Command**: `/dotnet-patterns`

Comprehensive ASP.NET Core, Entity Framework, and security best practices for .NET 8, 9, and 10:
- Modern Minimal APIs and Controller-based patterns
- Entity Framework Core optimization and patterns
- JWT, OAuth2, and policy-based authorization
- CQRS with MediatR
- Repository and Unit of Work patterns
- Performance optimization techniques
- Production-ready error handling and logging

**Use when**: Building enterprise .NET applications, microservices, or APIs.

---

### 🌐 Blazor Development
**Category**: Frontend/.NET | **Command**: `/blazor-patterns`

Blazor component lifecycle patterns and real-time communication:
- Component lifecycle management (OnInitialized, OnParametersSet, OnAfterRender)
- SignalR integration for real-time features
- State management decision frameworks (parameters, cascading values, scoped services, Fluxor)
- Server vs WebAssembly architecture choices and hybrid patterns
- JavaScript interop patterns and safety
- Performance optimization (ShouldRender, virtualization, primitive parameters)
- Memory leak prevention and resource disposal
- Critical pitfalls and anti-patterns

**Use when**: Building Blazor Server or WebAssembly applications, implementing real-time features, or optimizing Blazor performance.

---

### ⚡ Rust Performance Toolkit
**Category**: Backend/Rust | **Command**: `/rust-patterns`

Rust best practices, async patterns, and performance optimization:
- Tokio async runtime patterns
- Zero-cost abstractions and ownership patterns
- Concurrent programming with channels and mutexes
- Error handling with Result and Option
- Performance profiling and benchmarking
- Web frameworks (Axum, Actix-web)
- Memory management best practices

**Use when**: Building high-performance Rust applications, async services, or systems programming.

---

### 🦀 Rust Embedded Systems
**Category**: Embedded/Rust | **Command**: `/rust-embedded-patterns`

Embedded Rust patterns for no_std environments and low-level optimization:
- no_std development and peripheral access (PAC/HAL/Driver layers)
- Interrupt handling with RTIC and Embassy async
- Memory optimization (zero-copy, stack vs heap, DMA safety)
- SIMD optimization and inline assembly
- WebAssembly binary size reduction
- Unsafe Rust patterns with safety guarantees
- Type-state machines and cross-compilation
- Real-time constraints and hardware timing

**Use when**: Building embedded systems, bare-metal firmware, WASM modules, or optimizing low-level Rust code.

---

### 🌐 Cross-Stack Microservices
**Category**: Microservices | **Command**: `/microservices`

Production-ready microservice templates for Go, .NET, and Rust:
- Complete service templates with health checks and observability
- Docker and Kubernetes deployment manifests
- gRPC and REST API patterns
- Distributed tracing with OpenTelemetry
- Service mesh integration
- Database integration patterns
- CI/CD pipeline examples

**Use when**: Building microservices architectures, choosing tech stacks, or setting up deployment infrastructure.

---

### 🏢 SaaS Architecture
**Category**: SaaS/Architecture | **Command**: `/saas-patterns`

Multi-tenant SaaS patterns and production operations:
- Multi-tenancy isolation models (silo, pool, bridge, hybrid)
- Feature flags and progressive rollout patterns
- Billing integration with Stripe (subscriptions, metering, webhooks, dunning)
- Observability for multi-tenant systems (logs, metrics, traces per tenant)
- Authentication and authorization (Auth0 Organizations, RBAC, ABAC, ReBAC)
- Data isolation and security layers (defense in depth)
- Scaling strategies (auto-scaling, sharding, caching, connection pooling)
- Critical anti-patterns to avoid

**Use when**: Building SaaS products, implementing multi-tenancy, integrating billing systems, or scaling production systems.

---

### ⚛️ Modern Frontend
**Category**: Frontend | **Command**: `/frontend-patterns`

Vue 3 Composition API, React hooks, and modern TypeScript patterns:
- Vue 3 composables and Pinia state management
- React custom hooks and Context API
- TypeScript-first development patterns
- Form handling and validation
- Performance optimization techniques
- Accessibility best practices
- Component composition patterns

**Use when**: Building modern web frontends with Vue 3 or React.

---

### 🔒 Defense-Grade Security
**Category**: Security | **Command**: `/security-patterns`

NIST compliance, cryptography, and secure development practices:
- NIST SP 800-53 security controls
- FIPS 140-2 approved cryptographic implementations
- Multi-factor authentication (TOTP)
- Secure session management
- Password policies (NIST SP 800-63B)
- Input validation and sanitization
- Security logging and monitoring
- Key management and rotation

**Use when**: Implementing security controls, meeting compliance requirements, or hardening applications.

---

### 📚 Novelcrafter Export
**Category**: Writing/Publishing | **Command**: `/export`

Export and format Novelcrafter content for publication:
- Standard manuscript format for agent submissions
- EPUB generation for eBook publishing
- DOCX export with proper formatting
- Markdown conversion
- Word count and structure analysis
- Submission package preparation
- Query letter templates

**Use when**: Preparing manuscripts for submission, self-publishing, or sharing with beta readers.

---

### ⚛️ React Best Practices
**Category**: Frontend/React | **Command**: `/react-bp`

Modern React development with hooks, TypeScript, and production-ready patterns:
- Functional components with TypeScript
- Custom hooks for reusable logic (useFetch, useDebounce, useLocalStorage)
- Performance optimization (React.memo, useMemo, useCallback)
- Context API for state management
- Form handling with validation
- Error boundaries and error handling
- Testing with React Testing Library
- Code splitting and lazy loading

**Use when**: Building React applications, optimizing performance, or establishing React coding standards.

---

### 🐹 Go Best Practices
**Category**: Backend/Go | **Command**: `/go-bp`

Idiomatic Go patterns and production-ready development:
- Error handling patterns and custom error types
- Goroutines, channels, and concurrency patterns
- Worker pools and pipeline patterns
- Context usage for cancellation and timeouts
- HTTP server patterns and middleware
- Interface design and composition
- Testing with table-driven tests and mocks
- Graceful shutdown patterns

**Use when**: Writing idiomatic Go code, building concurrent systems, or optimizing Go applications.

---

### 💚 Vue.js Best Practices
**Category**: Frontend/Vue | **Command**: `/vue-bp`

Vue 3 Composition API and modern Vue development:
- Script setup with TypeScript
- Composables for reusable logic
- Pinia for state management
- Reactivity system best practices (ref vs reactive)
- Generic components with TypeScript
- Performance optimization (computed, v-memo, virtual scrolling)
- Provide/Inject pattern
- Testing with Vue Test Utils and Vitest

**Use when**: Building Vue 3 applications, creating composables, or establishing Vue coding standards.

---

### 🧪 Testing & QA Suite
**Category**: Testing/QA | **Command**: `/testing-patterns`

Comprehensive testing strategies and patterns across languages and frameworks:
- Unit testing patterns (AAA, test builders, fixtures)
- Integration testing with databases and APIs
- End-to-end testing with Playwright
- Test coverage and quality metrics
- Mocking and stubbing strategies
- Contract testing with Pact
- Performance testing
- Framework-specific patterns (Jest, pytest, Go testing, Rust testing)

**Use when**: Implementing test suites, improving test coverage, or establishing testing standards.

---

### 🗄️ Database Design & Optimization
**Category**: Database | **Command**: `/db-patterns`

Database design, optimization, and performance patterns for SQL and NoSQL:
- Schema design and normalization strategies
- Indexing strategies (B-tree, GIN, GiST, hash)
- Query optimization with EXPLAIN ANALYZE
- Connection pooling best practices
- Database migration patterns (zero-downtime)
- NoSQL schema design (MongoDB, Redis patterns)
- Performance monitoring and tuning
- Caching strategies

**Use when**: Designing databases, optimizing queries, or solving performance issues.

---

### 🚀 DevOps & Infrastructure as Code
**Category**: DevOps | **Command**: `/devops-patterns`

DevOps practices and Infrastructure as Code with modern tooling:
- Terraform modules and best practices
- Multi-stage Docker builds
- Kubernetes deployment patterns
- CI/CD pipelines with GitHub Actions
- Monitoring and observability setup
- Security scanning and compliance
- Container orchestration
- GitOps workflows

**Use when**: Setting up infrastructure, implementing CI/CD, or deploying to production.

---

### 🌐 API Design Patterns
**Category**: API | **Command**: `/api-patterns`

API design patterns for REST, GraphQL, and gRPC:
- RESTful API design principles
- GraphQL schema and resolver patterns
- gRPC service definitions
- API versioning strategies
- Authentication and authorization (JWT, API keys)
- Rate limiting and throttling
- API documentation with OpenAPI
- Error handling and response formats

**Use when**: Designing APIs, implementing authentication, or documenting endpoints.

---

### 📱 Mobile Development
**Category**: Mobile | **Command**: `/mobile-patterns`

Mobile development patterns for React Native and Flutter:
- Navigation patterns (React Navigation, GoRouter)
- State management (Zustand, Riverpod)
- Offline-first architecture with local databases
- Data synchronization strategies
- Performance optimization
- Platform-specific UI patterns
- Testing strategies
- App deployment and distribution

**Use when**: Building mobile apps, implementing offline features, or optimizing mobile performance.

---

### 🤖 AI/ML Integration
**Category**: AI/ML | **Command**: `/ai-patterns`

AI/ML integration patterns with LangChain and vector databases:
- LangChain setup and chains
- RAG (Retrieval Augmented Generation) pipelines
- Vector database integration (Pinecone, Weaviate, pgvector)
- Prompt engineering techniques
- Memory and conversation management
- Tool-using agents
- Streaming responses
- Cost optimization and caching

**Use when**: Integrating LLMs, building RAG systems, or implementing AI features.

---

### ♿ Accessibility & Inclusive Design
**Category**: Accessibility | **Command**: `/a11y-patterns`

Accessibility patterns following WCAG 2.2 and ARIA best practices:
- Semantic HTML structure
- ARIA attributes and roles
- Keyboard navigation patterns
- Focus management
- Color contrast and visual design
- Screen reader optimization
- Form accessibility
- Testing with automated tools and assistive technologies

**Use when**: Building accessible applications, meeting WCAG compliance, or improving UX for all users.

---

### ✨ Code Quality & Refactoring
**Category**: Code Quality | **Command**: `/refactoring-patterns`

Code quality improvement and refactoring patterns:
- SOLID principles in practice
- Common code smells and fixes
- Refactoring patterns (Extract Method, Replace Conditional, etc.)
- Clean code principles
- Design patterns application
- Dependency injection
- Test-driven refactoring
- Code review best practices

**Use when**: Refactoring legacy code, improving maintainability, or teaching clean code practices.

---

### 🎨 shadcn-aesthetic
**Category**: UI/Design

Modern CSS/SCSS architecture based on shadcn/ui design principles. Teaches Claude to generate refined, accessible styling with:
- HSL-based color systems
- Consistent spacing scales
- Subtle shadows and smooth transitions
- Proper focus states
- Modern layout patterns
- Dark mode support

Perfect for building Vibe.UI components or any modern web UI.

---

### 🛠️ Development Skills
**Category**: Development Skills

Reusable skills for common development tasks:
- **Code Review**: Comprehensive code review checklists and best practices
- **ADR Generator**: Architecture Decision Record templates and workflows
- **API Documentation**: Auto-generate OpenAPI/Swagger specs and README docs
- **Test Case Generator**: Generate comprehensive test cases from requirements
- **Performance Profiler**: Analyze and optimize code performance

**Use when**: Performing code reviews, documenting architecture decisions, generating API docs, writing tests, or profiling performance.

---

### 🔌 MCP Integrations
**Category**: MCP Integrations | **Command**: `/setup-mcps`

Integration guides for Model Context Protocol servers:
- **Database MCP**: Connect to PostgreSQL, MySQL, MongoDB
- **Vector Database MCP**: Integrate Pinecone, Weaviate, Qdrant
- **Cloud Provider MCPs**: AWS, GCP, Azure direct integration
- **Docker/Kubernetes MCP**: Manage containers and clusters
- **GitHub MCP**: Enhanced Git operations and PR reviews

**Use when**: Setting up direct integrations with databases, cloud providers, or external systems.

---

## Hooks & Automation

The marketplace includes pre-configured hooks for automation:

### Pre-Commit Quality Gate
Runs before every commit to ensure code quality:
- Linting (ESLint, Flake8, golangci-lint, Clippy)
- Type checking (TypeScript, mypy)
- Tests (Jest, pytest, go test, cargo test)
- Secret detection

### Auto-Format on Save
Automatically formats code when files are saved:
- Prettier/ESLint for JavaScript/TypeScript
- Black/isort for Python
- gofmt/goimports for Go
- rustfmt for Rust

### Security Scanner
Scans for vulnerabilities:
- Hardcoded secrets
- Dependency vulnerabilities
- SQL injection patterns
- XSS vulnerabilities

### Documentation Generator
Auto-generates documentation:
- OpenAPI/Swagger specs
- TypeDoc/pdoc
- README updates

## Custom Slash Commands

Pre-configured workflow commands:
- `/review` - Full code review workflow
- `/secure` - Security audit
- `/optimize` - Performance optimization
- `/document` - Generate documentation
- `/deploy` - Deployment workflow

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
