# Architecture Decision Record (ADR) Generator Skill

Generate Architecture Decision Records to document important architectural decisions.

## ADR Template

```markdown
# ADR-{number}: {Title}

## Status
{Proposed | Accepted | Deprecated | Superseded by ADR-XXX}

## Context
What is the issue that we're seeing that is motivating this decision or change?

## Decision
What is the change that we're proposing and/or doing?

## Consequences
What becomes easier or more difficult to do because of this change?

### Positive
- ...
- ...

### Negative
- ...
- ...

### Neutral
- ...

## Alternatives Considered
What other options were evaluated?

### Alternative 1: {Name}
**Description**: ...

**Pros**:
- ...

**Cons**:
- ...

**Why not chosen**: ...

### Alternative 2: {Name}
**Description**: ...

**Pros**:
- ...

**Cons**:
- ...

**Why not chosen**: ...

## Implementation Notes
Any specific implementation details or considerations.

## References
- Link to relevant documentation
- Link to related ADRs
- Link to discussions
```

## Common ADR Topics

### 1. Technology Selection
- Programming languages
- Frameworks and libraries
- Databases
- Cloud providers
- Message queues
- Caching solutions

### 2. Architecture Patterns
- Microservices vs Monolith
- Event-driven architecture
- CQRS and Event Sourcing
- API Gateway patterns
- Service mesh adoption

### 3. Data Management
- Database choice (SQL vs NoSQL)
- Data modeling approach
- Caching strategy
- Data migration strategy
- Backup and recovery

### 4. Security
- Authentication mechanism
- Authorization approach
- Encryption standards
- Secret management
- API security

### 5. Development Practices
- Branching strategy
- Code review process
- Testing strategy
- CI/CD pipeline
- Deployment strategy

### 6. Infrastructure
- Hosting platform
- Containerization strategy
- Orchestration platform
- Monitoring and logging
- Disaster recovery

## Example ADR

```markdown
# ADR-001: Use PostgreSQL for Primary Database

## Status
Accepted

## Context
We need to select a database for our new e-commerce platform. The system needs to:
- Handle complex relational data (users, orders, products, inventory)
- Support ACID transactions for financial data
- Scale to millions of records
- Provide good query performance
- Support full-text search
- Be well-supported and documented

## Decision
We will use PostgreSQL 16 as our primary database.

## Consequences

### Positive
- **ACID compliance**: Ensures data consistency for financial transactions
- **Rich data types**: JSON, arrays, and custom types provide flexibility
- **Full-text search**: Built-in FTS capabilities reduce dependency on external search engines
- **Mature ecosystem**: Excellent tooling, extensions, and community support
- **Strong consistency**: Suitable for financial and inventory data
- **Performance**: Query planner and indexing options provide good performance
- **Cost-effective**: Open-source with no licensing fees
- **Extensions**: PostGIS for location, pg_cron for scheduling, etc.

### Negative
- **Vertical scaling**: Harder to scale horizontally compared to NoSQL
- **Operational complexity**: Requires expertise for tuning and maintenance
- **Read replicas**: Additional setup for read-heavy scaling
- **Storage**: Can be more storage-intensive than some alternatives

### Neutral
- **Learning curve**: Team has SQL experience, so moderate learning curve
- **Hosting**: Available on all major cloud providers

## Alternatives Considered

### Alternative 1: MySQL
**Description**: Popular open-source relational database

**Pros**:
- Widely used and supported
- Good performance for read-heavy workloads
- Large ecosystem

**Cons**:
- Less advanced features than PostgreSQL
- JSON support not as robust
- Less powerful full-text search
- Some storage engines lack ACID compliance

**Why not chosen**: PostgreSQL offers more advanced features that align better with our requirements (JSON, full-text search, complex queries).

### Alternative 2: MongoDB
**Description**: Document-oriented NoSQL database

**Pros**:
- Flexible schema
- Horizontal scaling
- Fast writes
- Good for rapidly changing data models

**Cons**:
- Eventually consistent (can be configured for strong consistency with performance impact)
- Less suitable for complex relational queries
- Transactions across collections more complex
- Not ideal for financial data

**Why not chosen**: Our data is highly relational and requires strong ACID guarantees for financial transactions.

### Alternative 3: Amazon DynamoDB
**Description**: Fully managed NoSQL database service

**Pros**:
- Fully managed, no ops overhead
- Excellent scalability
- Low latency
- Pay per usage

**Cons**:
- Vendor lock-in
- Limited query capabilities
- More expensive at scale
- Requires different data modeling approach

**Why not chosen**: Relational model better fits our use case, and we want to avoid vendor lock-in.

## Implementation Notes

1. **Version**: Use PostgreSQL 16 for latest features
2. **Hosting**: Deploy on AWS RDS for managed service benefits
3. **Extensions**: Enable pg_trgm for fuzzy search, pg_stat_statements for monitoring
4. **Connection Pooling**: Use PgBouncer for connection management
5. **Backup**: Daily automated backups with point-in-time recovery
6. **Monitoring**: CloudWatch metrics + custom dashboard
7. **Read Replicas**: Configure 2 read replicas for read-heavy queries
8. **Migration**: Use TypeORM migrations for schema changes

## References
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [AWS RDS PostgreSQL](https://aws.amazon.com/rds/postgresql/)
- [Database Comparison Spike](https://company.com/docs/db-comparison)
- [Team Discussion Thread](https://company.slack.com/archives/C123/p456)
```

## Best Practices

### 1. Number ADRs Sequentially
Use ADR-001, ADR-002, etc. Never reuse numbers.

### 2. Keep ADRs Immutable
Once accepted, don't modify. Create new ADR to supersede if needed.

### 3. Be Specific
Include concrete technical details, not vague statements.

### 4. Document Trade-offs
Every decision has pros and cons. Document both honestly.

### 5. Link Related ADRs
Reference related decisions to show evolution.

### 6. Update Status
Mark as Deprecated or Superseded when decision changes.

### 7. Include Team Input
Document that stakeholders were consulted.

### 8. Write for Future Readers
Someone reading 2 years later should understand why the decision was made.

### 9. Keep It Concise
Aim for 1-2 pages. Link to detailed analysis separately.

### 10. Review Periodically
Revisit ADRs annually to ensure they're still relevant.

## ADR Lifecycle

1. **Proposed**: Initial draft, under discussion
2. **Accepted**: Team has agreed, implementation can proceed
3. **Implemented**: Decision has been executed
4. **Deprecated**: No longer recommended but not formally replaced
5. **Superseded**: Replaced by a newer ADR

## Storage

Store ADRs in version control:
```
docs/
  architecture/
    decisions/
      001-use-postgresql.md
      002-adopt-microservices.md
      003-use-react-native.md
      README.md (index of all ADRs)
```

## Index Template

```markdown
# Architecture Decision Records

## Active
- [ADR-001: Use PostgreSQL for Primary Database](001-use-postgresql.md)
- [ADR-002: Adopt Microservices Architecture](002-adopt-microservices.md)

## Superseded
- [ADR-003: Use Redux for State Management](003-use-redux.md) - Superseded by ADR-010

## Deprecated
- None
```

## Lightweight Alternative

For smaller decisions, use a simplified format:

```markdown
# Decision: {Title}

## Context
Brief context (2-3 sentences)

## Decision
What we're doing (2-3 sentences)

## Trade-offs
- **Pro**: ...
- **Pro**: ...
- **Con**: ...
- **Con**: ...
```

## Review Checklist

Before accepting an ADR:
- [ ] Context clearly explains the problem
- [ ] Decision is specific and actionable
- [ ] Consequences (positive and negative) are documented
- [ ] At least 2 alternatives were considered
- [ ] Trade-offs are honestly assessed
- [ ] Implementation notes provide enough detail
- [ ] References are included
- [ ] Stakeholders have reviewed
- [ ] ADR number is assigned
- [ ] Status is set correctly
