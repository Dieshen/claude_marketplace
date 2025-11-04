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
