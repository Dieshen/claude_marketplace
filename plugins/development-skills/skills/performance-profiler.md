# Performance Profiler Skill

Analyze code performance and provide optimization recommendations.

## Performance Analysis Checklist

### 1. Algorithm Complexity
- [ ] Time complexity documented (O(n), O(n²), etc.)
- [ ] Space complexity analyzed
- [ ] No nested loops where not necessary
- [ ] Efficient data structures chosen
- [ ] Binary search used instead of linear where possible

### 2. Database Performance
- [ ] Queries use appropriate indexes
- [ ] No N+1 query problems
- [ ] Connection pooling implemented
- [ ] Batch operations used for bulk updates
- [ ] Query execution plans analyzed

### 3. Caching
- [ ] Expensive computations cached
- [ ] API responses cached appropriately
- [ ] Cache invalidation strategy in place
- [ ] CDN used for static assets
- [ ] Redis/Memcached for distributed caching

### 4. Network & I/O
- [ ] API calls batched where possible
- [ ] Compression enabled (gzip, brotli)
- [ ] HTTP/2 or HTTP/3 used
- [ ] Keep-alive connections
- [ ] Parallel requests for independent data

### 5. Frontend Performance
- [ ] Code splitting implemented
- [ ] Lazy loading for routes/components
- [ ] Images optimized and lazy loaded
- [ ] Virtual scrolling for long lists
- [ ] Debouncing/throttling on events
- [ ] Memoization for expensive renders

### 6. Memory Management
- [ ] No memory leaks
- [ ] Event listeners cleaned up
- [ ] Large objects garbage collected
- [ ] Streams used for large files
- [ ] WeakMap/WeakSet for cached objects

## Performance Profiling Tools

### Node.js
```javascript
// Built-in profiler
node --prof app.js
node --prof-process isolate-0xnnnnnnnnnnnn-v8.log > processed.txt

// Chrome DevTools
node --inspect app.js
// Then open chrome://inspect

// Clinic.js
clinic doctor -- node app.js
clinic flame -- node app.js
clinic bubbleprof -- node app.js
```

### Browser
```javascript
// Performance API
performance.mark('start');
// ... code to measure
performance.mark('end');
performance.measure('myOperation', 'start', 'end');
const measures = performance.getEntriesByType('measure');
console.log(measures[0].duration);

// Chrome DevTools Performance tab
// Record → Run code → Stop → Analyze flame graph
```

### Python
```python
import cProfile
import pstats

# Profile function
cProfile.run('my_function()', 'output.prof')

# Analyze results
stats = pstats.Stats('output.prof')
stats.sort_stats('cumulative')
stats.print_stats(20)  # Top 20 functions

# Line profiler
from line_profiler import LineProfiler
lp = LineProfiler()
lp.add_function(my_function)
lp.run('my_function()')
lp.print_stats()
```

## Common Performance Issues & Fixes

### Issue 1: N+1 Queries
```typescript
// ❌ Bad: N+1 queries
const users = await User.findAll();
for (const user of users) {
  user.posts = await Post.findAll({ where: { userId: user.id } });
}

// ✅ Good: Single query with join
const users = await User.findAll({
  include: [{ model: Post }]
});

// ✅ Better: DataLoader for batching
const postLoader = new DataLoader(async (userIds) => {
  const posts = await Post.findAll({
    where: { userId: { $in: userIds } }
  });
  return userIds.map(id => posts.filter(p => p.userId === id));
});
```

### Issue 2: Inefficient Loops
```typescript
// ❌ Bad: O(n²)
function findDuplicates(arr: number[]): number[] {
  const duplicates = [];
  for (let i = 0; i < arr.length; i++) {
    for (let j = i + 1; j < arr.length; j++) {
      if (arr[i] === arr[j]) {
        duplicates.push(arr[i]);
      }
    }
  }
  return duplicates;
}

// ✅ Good: O(n)
function findDuplicates(arr: number[]): number[] {
  const seen = new Set();
  const duplicates = new Set();
  for (const num of arr) {
    if (seen.has(num)) {
      duplicates.add(num);
    }
    seen.add(num);
  }
  return Array.from(duplicates);
}
```

### Issue 3: Large Lists Without Virtualization
```typescript
// ❌ Bad: Renders all 10,000 items
{items.map(item => <ItemCard key={item.id} {...item} />)}

// ✅ Good: Virtual scrolling
import { FixedSizeList } from 'react-window';

<FixedSizeList
  height={600}
  itemCount={items.length}
  itemSize={80}
  width="100%"
>
  {({ index, style }) => (
    <div style={style}>
      <ItemCard {...items[index]} />
    </div>
  )}
</FixedSizeList>
```

### Issue 4: Unnecessary Re-renders
```typescript
// ❌ Bad: Re-renders on every parent render
function ExpensiveComponent({ data }) {
  const processed = processData(data);  // Runs every render
  return <div>{processed}</div>;
}

// ✅ Good: Memoized
const ExpensiveComponent = React.memo(({ data }) => {
  const processed = useMemo(() => processData(data), [data]);
  return <div>{processed}</div>;
});
```

### Issue 5: Blocking Operations
```typescript
// ❌ Bad: Blocks event loop
function processLargeFile() {
  const data = fs.readFileSync('large-file.json');  // Blocks!
  return JSON.parse(data);
}

// ✅ Good: Async
async function processLargeFile() {
  const data = await fs.promises.readFile('large-file.json', 'utf8');
  return JSON.parse(data);
}

// ✅ Better: Streaming
function processLargeFileStream() {
  return new Promise((resolve, reject) => {
    const stream = fs.createReadStream('large-file.json');
    let data = '';
    stream.on('data', chunk => data += chunk);
    stream.on('end', () => resolve(JSON.parse(data)));
    stream.on('error', reject);
  });
}
```

## Performance Benchmarking

### JavaScript/TypeScript
```typescript
import Benchmark from 'benchmark';

const suite = new Benchmark.Suite();

suite
  .add('Array.forEach', () => {
    const arr = Array.from({ length: 1000 }, (_, i) => i);
    arr.forEach(x => x * 2);
  })
  .add('for loop', () => {
    const arr = Array.from({ length: 1000 }, (_, i) => i);
    for (let i = 0; i < arr.length; i++) {
      arr[i] * 2;
    }
  })
  .add('Array.map', () => {
    const arr = Array.from({ length: 1000 }, (_, i) => i);
    arr.map(x => x * 2);
  })
  .on('cycle', (event) => {
    console.log(String(event.target));
  })
  .on('complete', function() {
    console.log('Fastest is ' + this.filter('fastest').map('name'));
  })
  .run();
```

### Python
```python
import timeit

def method1():
    return [x * 2 for x in range(1000)]

def method2():
    return list(map(lambda x: x * 2, range(1000)))

time1 = timeit.timeit(method1, number=10000)
time2 = timeit.timeit(method2, number=10000)

print(f"Method 1: {time1:.4f}s")
print(f"Method 2: {time2:.4f}s")
```

## Database Query Optimization

### Analyze Slow Queries
```sql
-- PostgreSQL: Enable slow query logging
ALTER SYSTEM SET log_min_duration_statement = 1000;  -- Log queries > 1s
SELECT pg_reload_conf();

-- View slow queries
SELECT
  calls,
  total_exec_time,
  mean_exec_time,
  max_exec_time,
  query
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 20;

-- Explain query
EXPLAIN ANALYZE
SELECT u.*, COUNT(p.id) as post_count
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
GROUP BY u.id;
```

### Add Indexes
```sql
-- Before: Sequential scan
SELECT * FROM users WHERE email = 'user@example.com';
-- Seq Scan on users (cost=0.00..180.00 rows=1)

-- Add index
CREATE INDEX idx_users_email ON users(email);

-- After: Index scan
-- Index Scan using idx_users_email on users (cost=0.42..8.44 rows=1)
```

## Memory Leak Detection

### Node.js
```javascript
// Detect memory leaks
const heapdump = require('heapdump');

// Take heap snapshot
heapdump.writeSnapshot(`./heap-${Date.now()}.heapsnapshot`);

// Compare snapshots in Chrome DevTools
// Memory → Load → Compare snapshots

// Monitor memory usage
setInterval(() => {
  const used = process.memoryUsage();
  console.log({
    rss: `${Math.round(used.rss / 1024 / 1024)}MB`,
    heapTotal: `${Math.round(used.heapTotal / 1024 / 1024)}MB`,
    heapUsed: `${Math.round(used.heapUsed / 1024 / 1024)}MB`,
    external: `${Math.round(used.external / 1024 / 1024)}MB`,
  });
}, 5000);
```

## Performance Budget

Define acceptable performance metrics:

### Web Application
- **First Contentful Paint (FCP)**: < 1.8s
- **Largest Contentful Paint (LCP)**: < 2.5s
- **Time to Interactive (TTI)**: < 3.8s
- **Total Blocking Time (TBT)**: < 200ms
- **Cumulative Layout Shift (CLS)**: < 0.1
- **Bundle Size**: < 200KB (gzipped)

### API
- **Response Time (p50)**: < 100ms
- **Response Time (p95)**: < 500ms
- **Response Time (p99)**: < 1000ms
- **Throughput**: > 1000 req/s
- **Error Rate**: < 0.1%

### Database
- **Query Time (avg)**: < 50ms
- **Connection Pool**: < 80% utilization
- **Cache Hit Rate**: > 90%

## Optimization Priority

1. **Measure First**: Profile before optimizing
2. **Focus on Bottlenecks**: 20% of code causes 80% of issues
3. **User-Facing First**: Optimize what users experience
4. **Low-Hanging Fruit**: Easy wins first
5. **Monitor Continuously**: Set up alerts for regressions

## Performance Testing

```typescript
// Load testing with autocannon
import autocannon from 'autocannon';

autocannon({
  url: 'http://localhost:3000/api/users',
  connections: 100,
  duration: 30,
  headers: {
    'Authorization': 'Bearer token'
  }
}, (err, result) => {
  console.log('Requests/sec:', result.requests.average);
  console.log('Latency p50:', result.latency.p50);
  console.log('Latency p99:', result.latency.p99);
});
```

## Report Template

```markdown
# Performance Analysis Report

## Executive Summary
- **Current Performance**: X req/s, Yms avg response
- **Target Performance**: A req/s, Bms avg response
- **Gap**: Need to improve by Z%

## Findings

### Critical Issues
1. **N+1 Query in /api/users** (Impact: High)
   - Current: 500ms avg response time
   - Each user triggers 10 additional queries
   - **Recommendation**: Add eager loading with `include`
   - **Expected Impact**: Reduce to 50ms (10x improvement)

### Major Issues
2. **Large Bundle Size** (Impact: Medium)
   - Current: 800KB (gzipped)
   - **Recommendation**: Code splitting, lazy loading
   - **Expected Impact**: Reduce to 200KB

## Optimization Roadmap

1. **Week 1**: Fix N+1 queries (High impact, Low effort)
2. **Week 2**: Implement caching (High impact, Medium effort)
3. **Week 3**: Code splitting (Medium impact, Medium effort)
4. **Week 4**: Database indexing (Medium impact, Low effort)

## Success Metrics
- Response time reduced by 60%
- Throughput increased by 3x
- Error rate reduced to < 0.1%
```
