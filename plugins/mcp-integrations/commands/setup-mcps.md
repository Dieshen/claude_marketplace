# MCP Server Integration Guide

Complete guide for setting up Model Context Protocol (MCP) servers with Claude Code.

## What are MCP Servers?

MCP servers provide Claude Code with direct access to external systems and data sources. They enable real-time interaction with databases, cloud providers, Docker/Kubernetes, and more.

## Available MCP Servers

### 1. Database MCP
Connect to SQL and NoSQL databases for real-time queries and schema exploration.

### 2. Vector Database MCP
Integrate with Pinecone, Weaviate, or Qdrant for AI/ML workflows.

### 3. Cloud Provider MCPs
Direct integration with AWS, GCP, and Azure services.

### 4. Docker/Kubernetes MCP
Manage containers and clusters directly from Claude Code.

### 5. GitHub MCP
Enhanced Git operations, PR reviews, and issue management.

## Installation

### Prerequisites
```bash
# Node.js 18+ required
node --version

# Claude Code CLI
claude --version
```

### General MCP Setup

1. Install MCP server package:
```bash
npm install -g @modelcontextprotocol/server-{name}
```

2. Configure in Claude Code settings:
```json
{
  "mcpServers": {
    "server-name": {
      "command": "mcp-server-name",
      "args": ["--config", "path/to/config.json"],
      "env": {
        "API_KEY": "your-api-key"
      }
    }
  }
}
```

3. Restart Claude Code to load the MCP server

## Database MCP Setup

### PostgreSQL
```bash
# Install
npm install -g @modelcontextprotocol/server-postgres

# Configure (~/.claude/config.json)
{
  "mcpServers": {
    "postgres": {
      "command": "mcp-server-postgres",
      "args": [],
      "env": {
        "DATABASE_URL": "postgresql://user:pass@localhost:5432/dbname"
      }
    }
  }
}
```

**Usage**:
```
/query SELECT * FROM users WHERE email = 'test@example.com'
/schema users
/indexes users
```

### MongoDB
```bash
# Install
npm install -g @modelcontextprotocol/server-mongodb

# Configure
{
  "mcpServers": {
    "mongodb": {
      "command": "mcp-server-mongodb",
      "env": {
        "MONGODB_URI": "mongodb://localhost:27017/mydb"
      }
    }
  }
}
```

**Usage**:
```
/find users {"email": "test@example.com"}
/aggregate users [{"$group": {"_id": "$role", "count": {"$sum": 1}}}]
```

## Vector Database MCP Setup

### Pinecone
```bash
# Install
npm install -g @modelcontextprotocol/server-pinecone

# Configure
{
  "mcpServers": {
    "pinecone": {
      "command": "mcp-server-pinecone",
      "env": {
        "PINECONE_API_KEY": "your-api-key",
        "PINECONE_ENVIRONMENT": "us-east-1-aws"
      }
    }
  }
}
```

**Usage**:
```
/vector-search "machine learning concepts" --top-k 5
/upsert-vectors [{"id": "vec1", "values": [...], "metadata": {...}}]
/delete-vectors ["vec1", "vec2"]
```

## Cloud Provider MCP Setup

### AWS
```bash
# Install
npm install -g @modelcontextprotocol/server-aws

# Configure
{
  "mcpServers": {
    "aws": {
      "command": "mcp-server-aws",
      "env": {
        "AWS_ACCESS_KEY_ID": "your-access-key",
        "AWS_SECRET_ACCESS_KEY": "your-secret-key",
        "AWS_REGION": "us-east-1"
      }
    }
  }
}
```

**Usage**:
```
/aws s3 ls s3://my-bucket
/aws ec2 describe-instances --filters "Name=tag:Environment,Values=production"
/aws lambda invoke my-function --payload '{"key": "value"}'
/aws rds describe-db-instances
```

### GCP
```bash
# Install
npm install -g @modelcontextprotocol/server-gcp

# Configure
{
  "mcpServers": {
    "gcp": {
      "command": "mcp-server-gcp",
      "env": {
        "GOOGLE_APPLICATION_CREDENTIALS": "/path/to/service-account.json",
        "GCP_PROJECT_ID": "my-project"
      }
    }
  }
}
```

**Usage**:
```
/gcp compute instances list
/gcp storage buckets list
/gcp sql instances list
```

## Docker/Kubernetes MCP Setup

### Docker
```bash
# Install
npm install -g @modelcontextprotocol/server-docker

# Configure
{
  "mcpServers": {
    "docker": {
      "command": "mcp-server-docker",
      "args": ["--socket", "/var/run/docker.sock"]
    }
  }
}
```

**Usage**:
```
/docker ps
/docker images
/docker logs container-name --tail 100
/docker exec container-name ls -la
/docker stats
```

### Kubernetes
```bash
# Install
npm install -g @modelcontextprotocol/server-kubernetes

# Configure
{
  "mcpServers": {
    "k8s": {
      "command": "mcp-server-kubernetes",
      "env": {
        "KUBECONFIG": "~/.kube/config"
      }
    }
  }
}
```

**Usage**:
```
/kubectl get pods -n production
/kubectl describe deployment myapp
/kubectl logs deployment/myapp --tail=100
/kubectl get services
/kubectl top pods
```

## GitHub MCP Setup

```bash
# Install
npm install -g @modelcontextprotocol/server-github

# Configure
{
  "mcpServers": {
    "github": {
      "command": "mcp-server-github",
      "env": {
        "GITHUB_TOKEN": "ghp_your_token_here"
      }
    }
  }
}
```

**Usage**:
```
/gh pr list --repo owner/repo
/gh pr view 123
/gh pr review 123 --comment "LGTM"
/gh issue create --title "Bug" --body "Description"
/gh workflow run ci.yml
```

## Security Best Practices

1. **Store credentials securely**:
```bash
# Use environment variables
export DATABASE_URL="postgresql://..."

# Or use a secrets manager
{
  "mcpServers": {
    "postgres": {
      "command": "mcp-server-postgres",
      "env": {
        "DATABASE_URL": "${env:DATABASE_URL}"
      }
    }
  }
}
```

2. **Use read-only access when possible**:
```sql
-- Create read-only database user
CREATE USER readonly_user WITH PASSWORD 'secure_password';
GRANT CONNECT ON DATABASE mydb TO readonly_user;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly_user;
```

3. **Limit permissions**:
- Use least privilege principle
- Create service accounts with minimal permissions
- Regularly rotate credentials

4. **Monitor usage**:
- Log all MCP operations
- Set up alerts for unusual activity
- Review access logs regularly

## Troubleshooting

### MCP Server Not Starting
```bash
# Check if server is installed
which mcp-server-postgres

# Test server manually
mcp-server-postgres

# Check logs
tail -f ~/.claude/logs/mcp-server-name.log
```

### Connection Issues
```bash
# Test database connection
psql postgresql://user:pass@localhost:5432/dbname

# Test API credentials
curl -H "Authorization: Bearer $API_KEY" https://api.provider.com/test
```

### Permission Errors
- Verify credentials are correct
- Check IAM roles/permissions
- Ensure firewall allows connections
- Verify network connectivity

## Creating Custom MCP Servers

### Basic MCP Server Template

```typescript
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';

const server = new Server(
  {
    name: 'my-custom-server',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// Define tools
server.setRequestHandler('tools/list', async () => {
  return {
    tools: [
      {
        name: 'my_tool',
        description: 'Description of what this tool does',
        inputSchema: {
          type: 'object',
          properties: {
            param1: {
              type: 'string',
              description: 'Parameter description',
            },
          },
          required: ['param1'],
        },
      },
    ],
  };
});

// Handle tool calls
server.setRequestHandler('tools/call', async (request) => {
  const { name, arguments: args } = request.params;

  if (name === 'my_tool') {
    const result = await doSomething(args.param1);
    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify(result, null, 2),
        },
      ],
    };
  }

  throw new Error(`Unknown tool: ${name}`);
});

// Start server
const transport = new StdioServerTransport();
await server.connect(transport);
```

## Best Practices

1. **Test MCP servers locally before deploying**
2. **Use version control for MCP configurations**
3. **Document custom MCP servers**
4. **Monitor performance and errors**
5. **Keep MCP servers updated**
6. **Implement proper error handling**
7. **Use connection pooling for databases**
8. **Cache frequently accessed data**
9. **Set appropriate timeouts**
10. **Log operations for debugging**

## Example Workflows

### Database Query & Analysis
```
1. /query SELECT * FROM users WHERE created_at > NOW() - INTERVAL '7 days'
2. Analyze results
3. /query UPDATE users SET status = 'active' WHERE ...
4. Verify changes
```

### Cloud Deployment
```
1. /docker build -t myapp:latest .
2. /docker push myapp:latest
3. /kubectl set image deployment/myapp myapp=myapp:latest
4. /kubectl rollout status deployment/myapp
```

### AI/ML Workflow
```
1. Generate embeddings for documents
2. /vector-search "relevant query" --top-k 10
3. Use results in RAG pipeline
4. /upsert-vectors with new documents
```
