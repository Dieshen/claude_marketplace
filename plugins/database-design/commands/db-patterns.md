# Database Design & Optimization Patterns

Comprehensive database design, optimization, and performance patterns for SQL and NoSQL databases.

## SQL Database Design Patterns

### Schema Design Best Practices

#### Normalization (3NF)
```sql
-- Properly normalized schema
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_profiles (
    user_id INTEGER PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    bio TEXT,
    avatar_url VARCHAR(500)
);

CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    published_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tags (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    slug VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE post_tags (
    post_id INTEGER REFERENCES posts(id) ON DELETE CASCADE,
    tag_id INTEGER REFERENCES tags(id) ON DELETE CASCADE,
    PRIMARY KEY (post_id, tag_id)
);
```

#### Denormalization for Performance
```sql
-- Denormalized for read performance
CREATE TABLE post_view (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    username VARCHAR(50) NOT NULL,
    user_avatar VARCHAR(500),
    post_id INTEGER NOT NULL,
    post_title VARCHAR(255) NOT NULL,
    post_content TEXT,
    post_published_at TIMESTAMP,
    tags TEXT[], -- Array of tag names
    comment_count INTEGER DEFAULT 0,
    like_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Materialized view for complex aggregations
CREATE MATERIALIZED VIEW user_statistics AS
SELECT
    u.id,
    u.username,
    COUNT(DISTINCT p.id) as post_count,
    COUNT(DISTINCT c.id) as comment_count,
    COUNT(DISTINCT l.id) as like_count,
    MAX(p.created_at) as last_post_at
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
LEFT JOIN comments c ON u.id = c.user_id
LEFT JOIN likes l ON u.id = l.user_id
GROUP BY u.id, u.username;

-- Refresh materialized view
REFRESH MATERIALIZED VIEW CONCURRENTLY user_statistics;
```

### Indexing Strategies

#### B-Tree Indexes (Default)
```sql
-- Single column index
CREATE INDEX idx_posts_user_id ON posts(user_id);

-- Composite index (order matters!)
CREATE INDEX idx_posts_user_published ON posts(user_id, published_at DESC);

-- Partial index (for specific conditions)
CREATE INDEX idx_posts_published ON posts(published_at)
WHERE published_at IS NOT NULL;

-- Unique index
CREATE UNIQUE INDEX idx_users_email_lower ON users(LOWER(email));
```

#### Specialized Indexes
```sql
-- GIN index for full-text search
CREATE INDEX idx_posts_content_fts ON posts
USING GIN(to_tsvector('english', content));

-- Search using full-text index
SELECT * FROM posts
WHERE to_tsvector('english', content) @@ to_tsquery('english', 'database & optimization');

-- JSONB GIN index
CREATE TABLE settings (
    user_id INTEGER PRIMARY KEY,
    preferences JSONB NOT NULL DEFAULT '{}'
);

CREATE INDEX idx_settings_preferences ON settings USING GIN(preferences);

-- Query JSONB efficiently
SELECT * FROM settings
WHERE preferences @> '{"theme": "dark"}';

-- GiST index for geometric and range types
CREATE INDEX idx_events_date_range ON events USING GIST(date_range);

-- Hash index (PostgreSQL 10+, for equality only)
CREATE INDEX idx_users_uuid ON users USING HASH(uuid);
```

#### Index Maintenance
```sql
-- Analyze index usage
SELECT
    schemaname,
    tablename,
    indexname,
    idx_scan,
    idx_tup_read,
    idx_tup_fetch
FROM pg_stat_user_indexes
ORDER BY idx_scan ASC;

-- Find unused indexes
SELECT
    schemaname,
    tablename,
    indexname
FROM pg_stat_user_indexes
WHERE idx_scan = 0
AND indexname NOT LIKE 'pg_toast%';

-- Reindex to rebuild fragmented indexes
REINDEX INDEX CONCURRENTLY idx_posts_user_id;
REINDEX TABLE CONCURRENTLY posts;
```

### Query Optimization

#### EXPLAIN ANALYZE
```sql
-- Analyze query execution plan
EXPLAIN ANALYZE
SELECT
    u.username,
    p.title,
    COUNT(c.id) as comment_count
FROM users u
JOIN posts p ON u.id = p.user_id
LEFT JOIN comments c ON p.id = c.post_id
WHERE p.published_at > NOW() - INTERVAL '30 days'
GROUP BY u.username, p.title
ORDER BY comment_count DESC
LIMIT 10;

-- Key metrics to look for:
-- - Seq Scan vs Index Scan
-- - Nested Loop vs Hash Join vs Merge Join
-- - Actual time vs Estimated rows
-- - Buffers (shared hit ratio)
```

#### Avoiding N+1 Queries
```sql
-- Bad: N+1 query problem
-- Query 1: Get all posts
SELECT * FROM posts LIMIT 10;

-- Query 2-11: Get author for each post (N queries)
SELECT * FROM users WHERE id = ?;

-- Good: Use JOIN to fetch in one query
SELECT
    p.*,
    u.username,
    u.email
FROM posts p
JOIN users u ON p.user_id = u.id
LIMIT 10;

-- Good: Use subquery or CTE
WITH post_authors AS (
    SELECT DISTINCT user_id FROM posts LIMIT 10
)
SELECT u.* FROM users u
WHERE u.id IN (SELECT user_id FROM post_authors);
```

#### Query Optimization Techniques
```sql
-- Use EXISTS instead of COUNT when checking existence
-- Bad
SELECT * FROM users u
WHERE (SELECT COUNT(*) FROM posts WHERE user_id = u.id) > 0;

-- Good
SELECT * FROM users u
WHERE EXISTS (SELECT 1 FROM posts WHERE user_id = u.id);

-- Use DISTINCT ON for getting first row per group (PostgreSQL)
SELECT DISTINCT ON (user_id)
    user_id,
    created_at,
    content
FROM posts
ORDER BY user_id, created_at DESC;

-- Use window functions instead of subqueries
-- Get each user's latest post
SELECT
    user_id,
    title,
    created_at,
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_at DESC) as rn
FROM posts
WHERE rn = 1;

-- Batch updates instead of row-by-row
-- Bad
UPDATE posts SET view_count = view_count + 1 WHERE id = ?; -- Called N times

-- Good
UPDATE posts
SET view_count = view_count + v.increment
FROM (VALUES (1, 5), (2, 3), (3, 10)) AS v(id, increment)
WHERE posts.id = v.id;
```

### Connection Pooling

#### Node.js (pg pool)
```typescript
import { Pool } from 'pg';

const pool = new Pool({
  host: 'localhost',
  port: 5432,
  database: 'myapp',
  user: 'postgres',
  password: 'password',
  max: 20, // Maximum pool size
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});

// Use pool for queries
async function getUserById(id: number) {
  const client = await pool.connect();
  try {
    const result = await client.query('SELECT * FROM users WHERE id = $1', [id]);
    return result.rows[0];
  } finally {
    client.release(); // Always release back to pool
  }
}

// Or use pool.query directly (handles acquire/release)
async function getUsers() {
  const result = await pool.query('SELECT * FROM users LIMIT 100');
  return result.rows;
}

// Transaction with pool
async function transferFunds(fromId: number, toId: number, amount: number) {
  const client = await pool.connect();
  try {
    await client.query('BEGIN');

    await client.query(
      'UPDATE accounts SET balance = balance - $1 WHERE user_id = $2',
      [amount, fromId]
    );

    await client.query(
      'UPDATE accounts SET balance = balance + $1 WHERE user_id = $2',
      [amount, toId]
    );

    await client.query('COMMIT');
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
}
```

#### Python (SQLAlchemy)
```python
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import QueuePool

# Create engine with connection pool
engine = create_engine(
    'postgresql://user:password@localhost/dbname',
    poolclass=QueuePool,
    pool_size=10,
    max_overflow=20,
    pool_pre_ping=True,  # Verify connections before using
    pool_recycle=3600,   # Recycle connections after 1 hour
)

Session = sessionmaker(bind=engine)

# Use session
def get_user(user_id: int):
    session = Session()
    try:
        user = session.query(User).filter(User.id == user_id).first()
        return user
    finally:
        session.close()

# Context manager for automatic cleanup
from contextlib import contextmanager

@contextmanager
def get_db_session():
    session = Session()
    try:
        yield session
        session.commit()
    except Exception:
        session.rollback()
        raise
    finally:
        session.close()

# Usage
with get_db_session() as session:
    user = session.query(User).filter(User.id == 1).first()
    user.name = "Updated Name"
```

### Database Migration Patterns

#### Migrations with TypeORM (Node.js)
```typescript
// migrations/1234567890-CreateUsers.ts
import { MigrationInterface, QueryRunner, Table } from 'typeorm';

export class CreateUsers1234567890 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.createTable(
      new Table({
        name: 'users',
        columns: [
          {
            name: 'id',
            type: 'int',
            isPrimary: true,
            isGenerated: true,
            generationStrategy: 'increment',
          },
          {
            name: 'email',
            type: 'varchar',
            length: '255',
            isUnique: true,
          },
          {
            name: 'created_at',
            type: 'timestamp',
            default: 'CURRENT_TIMESTAMP',
          },
        ],
      })
    );

    await queryRunner.createIndex(
      'users',
      new TableIndex({
        name: 'idx_users_email',
        columnNames: ['email'],
      })
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropTable('users');
  }
}
```

#### Alembic Migrations (Python)
```python
# alembic/versions/001_create_users.py
from alembic import op
import sqlalchemy as sa

def upgrade():
    op.create_table(
        'users',
        sa.Column('id', sa.Integer(), primary_key=True),
        sa.Column('email', sa.String(255), unique=True, nullable=False),
        sa.Column('username', sa.String(50), unique=True, nullable=False),
        sa.Column('created_at', sa.DateTime(), server_default=sa.func.now()),
    )

    op.create_index('idx_users_email', 'users', ['email'])

def downgrade():
    op.drop_index('idx_users_email')
    op.drop_table('users')
```

#### Zero-Downtime Migration Strategies
```sql
-- Adding a NOT NULL column safely

-- Step 1: Add column as nullable
ALTER TABLE users ADD COLUMN phone VARCHAR(20);

-- Step 2: Backfill data in batches
UPDATE users SET phone = '000-000-0000' WHERE phone IS NULL;

-- Step 3: Add NOT NULL constraint
ALTER TABLE users ALTER COLUMN phone SET NOT NULL;

-- Renaming a column safely

-- Step 1: Add new column
ALTER TABLE users ADD COLUMN full_name VARCHAR(200);

-- Step 2: Dual-write to both columns in application code
-- Step 3: Backfill data
UPDATE users SET full_name = name WHERE full_name IS NULL;

-- Step 4: Switch reads to new column in application
-- Step 5: Drop old column
ALTER TABLE users DROP COLUMN name;
```

## NoSQL Database Patterns

### MongoDB Schema Design

#### Embedding vs Referencing
```javascript
// Embedding (One-to-Few)
{
  _id: ObjectId("..."),
  username: "johndoe",
  email: "john@example.com",
  addresses: [
    {
      type: "home",
      street: "123 Main St",
      city: "New York",
      zip: "10001"
    },
    {
      type: "work",
      street: "456 Office Blvd",
      city: "New York",
      zip: "10002"
    }
  ]
}

// Referencing (One-to-Many or Many-to-Many)
// Users collection
{
  _id: ObjectId("user1"),
  username: "johndoe",
  email: "john@example.com"
}

// Posts collection
{
  _id: ObjectId("post1"),
  user_id: ObjectId("user1"),
  title: "My Post",
  content: "...",
  created_at: ISODate("2024-01-01")
}

// Extended Reference Pattern (Denormalization)
{
  _id: ObjectId("post1"),
  user: {
    _id: ObjectId("user1"),
    username: "johndoe",
    avatar: "https://..."
  },
  title: "My Post",
  content: "..."
}
```

#### Compound Indexes
```javascript
// Create compound index
db.posts.createIndex({ user_id: 1, created_at: -1 });

// Index with unique constraint
db.users.createIndex({ email: 1 }, { unique: true });

// Partial index
db.orders.createIndex(
  { status: 1, created_at: -1 },
  { partialFilterExpression: { status: { $in: ["pending", "processing"] } } }
);

// Text index for full-text search
db.articles.createIndex({ title: "text", content: "text" });

// Geospatial index
db.locations.createIndex({ coordinates: "2dsphere" });
```

#### Aggregation Pipeline
```javascript
// Complex aggregation example
db.orders.aggregate([
  // Stage 1: Match recent orders
  {
    $match: {
      created_at: { $gte: new Date("2024-01-01") },
      status: "completed"
    }
  },

  // Stage 2: Lookup user data
  {
    $lookup: {
      from: "users",
      localField: "user_id",
      foreignField: "_id",
      as: "user"
    }
  },

  // Stage 3: Unwind user array
  { $unwind: "$user" },

  // Stage 4: Group by user and calculate totals
  {
    $group: {
      _id: "$user._id",
      username: { $first: "$user.username" },
      total_orders: { $sum: 1 },
      total_revenue: { $sum: "$total_amount" },
      avg_order_value: { $avg: "$total_amount" }
    }
  },

  // Stage 5: Sort by revenue
  { $sort: { total_revenue: -1 } },

  // Stage 6: Limit results
  { $limit: 10 }
]);

// Use $facet for multiple aggregations in one query
db.products.aggregate([
  {
    $facet: {
      categoryCounts: [
        { $group: { _id: "$category", count: { $sum: 1 } } }
      ],
      priceRanges: [
        {
          $bucket: {
            groupBy: "$price",
            boundaries: [0, 25, 50, 100, 500],
            default: "500+",
            output: { count: { $sum: 1 } }
          }
        }
      ],
      topRated: [
        { $sort: { rating: -1 } },
        { $limit: 5 }
      ]
    }
  }
]);
```

### Redis Patterns

#### Caching Strategy
```typescript
import Redis from 'ioredis';

const redis = new Redis({
  host: 'localhost',
  port: 6379,
  retryStrategy: (times) => Math.min(times * 50, 2000),
});

// Cache-aside pattern
async function getUser(userId: string) {
  const cacheKey = `user:${userId}`;

  // Try cache first
  const cached = await redis.get(cacheKey);
  if (cached) {
    return JSON.parse(cached);
  }

  // Cache miss - fetch from database
  const user = await db.users.findById(userId);

  // Store in cache with TTL
  await redis.setex(cacheKey, 3600, JSON.stringify(user));

  return user;
}

// Invalidate cache on update
async function updateUser(userId: string, data: UserData) {
  const user = await db.users.update(userId, data);

  // Invalidate cache
  await redis.del(`user:${userId}`);

  return user;
}

// Rate limiting with Redis
async function checkRateLimit(userId: string, limit: number, window: number) {
  const key = `ratelimit:${userId}`;
  const current = await redis.incr(key);

  if (current === 1) {
    await redis.expire(key, window);
  }

  return current <= limit;
}

// Usage
const allowed = await checkRateLimit('user123', 100, 60); // 100 requests per minute
if (!allowed) {
  throw new Error('Rate limit exceeded');
}

// Distributed locking
async function withLock<T>(
  lockKey: string,
  ttl: number,
  fn: () => Promise<T>
): Promise<T> {
  const lockValue = crypto.randomUUID();
  const acquired = await redis.set(lockKey, lockValue, 'EX', ttl, 'NX');

  if (!acquired) {
    throw new Error('Could not acquire lock');
  }

  try {
    return await fn();
  } finally {
    // Release lock only if we still own it
    const script = `
      if redis.call("get", KEYS[1]) == ARGV[1] then
        return redis.call("del", KEYS[1])
      else
        return 0
      end
    `;
    await redis.eval(script, 1, lockKey, lockValue);
  }
}

// Pub/Sub pattern
const publisher = new Redis();
const subscriber = new Redis();

subscriber.subscribe('notifications', (err, count) => {
  console.log(`Subscribed to ${count} channels`);
});

subscriber.on('message', (channel, message) => {
  console.log(`Received ${message} from ${channel}`);
});

publisher.publish('notifications', JSON.stringify({
  type: 'new_message',
  userId: '123',
  content: 'Hello!'
}));
```

## Database Performance Best Practices

### 1. Use Connection Pooling
Always use connection pools to avoid connection overhead

### 2. Index Strategically
- Index foreign keys and columns used in WHERE, JOIN, ORDER BY
- Avoid over-indexing (impacts write performance)
- Use composite indexes for multi-column queries
- Monitor index usage and remove unused ones

### 3. Optimize Queries
- Use EXPLAIN to analyze query plans
- Avoid SELECT * - fetch only needed columns
- Use pagination for large result sets
- Batch operations when possible

### 4. Cache Frequently Accessed Data
- Use Redis or Memcached for hot data
- Implement cache invalidation strategy
- Consider read replicas for read-heavy workloads

### 5. Partition Large Tables
```sql
-- Range partitioning by date
CREATE TABLE events (
    id SERIAL,
    event_type VARCHAR(50),
    data JSONB,
    created_at TIMESTAMP
) PARTITION BY RANGE (created_at);

CREATE TABLE events_2024_q1 PARTITION OF events
FOR VALUES FROM ('2024-01-01') TO ('2024-04-01');

CREATE TABLE events_2024_q2 PARTITION OF events
FOR VALUES FROM ('2024-04-01') TO ('2024-07-01');
```

### 6. Monitor and Analyze
- Track slow queries
- Monitor connection pool usage
- Analyze query performance trends
- Set up alerts for anomalies

### 7. Use Appropriate Data Types
```sql
-- Good
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    price NUMERIC(10,2),  -- Exact decimal for money
    created_at TIMESTAMP WITH TIME ZONE
);

-- Bad
CREATE TABLE products (
    id VARCHAR(255) PRIMARY KEY,  -- Wasteful for numeric IDs
    price FLOAT,  -- Floating point for money (precision issues)
    created_at VARCHAR(50)  -- String for dates
);
```

### 8. Implement Proper Backup Strategy
- Regular automated backups
- Test restore procedures
- Use point-in-time recovery when possible
- Replicate to multiple regions for disaster recovery
