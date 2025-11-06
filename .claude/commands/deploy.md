# Deployment Workflow

Execute a safe deployment to the specified environment.

## Pre-Deployment Checks

1. Run all tests
2. Check test coverage meets threshold
3. Verify no linting errors
4. Security scan passes
5. Build succeeds
6. All dependencies up to date

## Deployment Steps

1. **Build**
   - Create production build
   - Optimize assets
   - Generate source maps

2. **Docker** (if applicable)
   - Build Docker image
   - Tag with version
   - Push to registry

3. **Deploy**
   - Update deployment manifest
   - Apply to cluster
   - Monitor rollout status

4. **Verify**
   - Health checks passing
   - Smoke tests pass
   - Monitor error rates
   - Check response times

5. **Post-Deployment**
   - Update documentation
   - Notify team
   - Monitor metrics

## Rollback Plan

If deployment fails:
1. Identify the issue
2. Execute rollback
3. Verify rollback success
4. Post-mortem analysis

## Environments

- `development`: Auto-deploy on push
- `staging`: Manual approval required
- `production`: Requires all checks + approval
