# Performance Optimization Workflow

Analyze and optimize code performance.

## Analysis Steps

1. **Algorithm Complexity**
   - Identify O(n²) or worse algorithms
   - Suggest more efficient alternatives
   - Analyze space complexity

2. **Database Queries**
   - Find N+1 query problems
   - Check for missing indexes
   - Identify slow queries

3. **Frontend Performance**
   - Unnecessary re-renders
   - Large bundle sizes
   - Missing code splitting
   - Unoptimized images

4. **Caching Opportunities**
   - Repeated computations
   - API calls that could be cached
   - Database queries

5. **Memory Usage**
   - Memory leaks
   - Large object retention
   - Inefficient data structures

## Recommendations

For each issue found, provide:
- Current performance impact
- Suggested optimization
- Expected improvement
- Implementation effort (Low/Medium/High)
- Code example

## Priority

Focus on:
1. User-facing performance issues
2. High-traffic code paths
3. Database bottlenecks
4. Memory leaks
