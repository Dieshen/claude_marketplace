# API Design Patterns

Comprehensive API design patterns for REST, GraphQL, gRPC with security, versioning, and best practices.

## RESTful API Design

### Resource-Based URL Design

```
Good URL Design:
GET    /api/v1/users              - List users
GET    /api/v1/users/{id}         - Get specific user
POST   /api/v1/users              - Create user
PUT    /api/v1/users/{id}         - Update user (full)
PATCH  /api/v1/users/{id}         - Update user (partial)
DELETE /api/v1/users/{id}         - Delete user

GET    /api/v1/users/{id}/posts   - Get user's posts
POST   /api/v1/users/{id}/posts   - Create post for user

Bad URL Design:
GET    /api/v1/getAllUsers
POST   /api/v1/createNewUser
GET    /api/v1/user-posts/{id}
```

### HTTP Status Codes

```
Success:
200 OK                 - Successful GET, PUT, PATCH, DELETE
201 Created            - Successful POST
204 No Content         - Successful DELETE with no response body

Client Errors:
400 Bad Request        - Invalid request data
401 Unauthorized       - Missing or invalid authentication
403 Forbidden          - Authenticated but not authorized
404 Not Found          - Resource doesn't exist
409 Conflict           - Resource conflict (duplicate)
422 Unprocessable      - Validation errors
429 Too Many Requests  - Rate limit exceeded

Server Errors:
500 Internal Server    - Server error
502 Bad Gateway        - Upstream error
503 Service Unavailable - Temporary unavailability
```

### Request/Response Format

```typescript
// Consistent response structure
interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: {
    code: string;
    message: string;
    details?: any;
  };
  meta?: {
    timestamp: string;
    requestId: string;
  };
}

// Success response
{
  "success": true,
  "data": {
    "id": "123",
    "name": "John Doe",
    "email": "john@example.com"
  },
  "meta": {
    "timestamp": "2024-01-01T12:00:00Z",
    "requestId": "req_abc123"
  }
}

// Error response
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": {
      "email": ["Email is required", "Email format is invalid"]
    }
  },
  "meta": {
    "timestamp": "2024-01-01T12:00:00Z",
    "requestId": "req_abc123"
  }
}

// Paginated list response
{
  "success": true,
  "data": {
    "items": [...],
    "pagination": {
      "page": 1,
      "pageSize": 20,
      "totalPages": 5,
      "totalItems": 95,
      "hasNext": true,
      "hasPrevious": false
    }
  }
}
```

### Node.js/Express Implementation

```typescript
import express from 'express';
import { z } from 'zod';

const app = express();
app.use(express.json());

// Validation schema
const userSchema = z.object({
  name: z.string().min(1).max(100),
  email: z.string().email(),
  age: z.number().int().positive().optional(),
});

// Middleware: Request validation
const validate = (schema: z.ZodSchema) => {
  return (req: Request, res: Response, next: NextFunction) => {
    try {
      schema.parse(req.body);
      next();
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(422).json({
          success: false,
          error: {
            code: 'VALIDATION_ERROR',
            message: 'Invalid input data',
            details: error.errors,
          },
        });
      }
      next(error);
    }
  };
};

// Middleware: Error handler
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  console.error(err);

  if (err instanceof ApiError) {
    return res.status(err.statusCode).json({
      success: false,
      error: {
        code: err.code,
        message: err.message,
      },
      meta: {
        timestamp: new Date().toISOString(),
        requestId: req.id,
      },
    });
  }

  res.status(500).json({
    success: false,
    error: {
      code: 'INTERNAL_ERROR',
      message: 'An unexpected error occurred',
    },
  });
});

// Routes
app.get('/api/v1/users', async (req, res) => {
  const page = parseInt(req.query.page as string) || 1;
  const pageSize = parseInt(req.query.pageSize as string) || 20;

  const result = await userService.list({ page, pageSize });

  res.json({
    success: true,
    data: {
      items: result.items,
      pagination: {
        page,
        pageSize,
        totalPages: Math.ceil(result.total / pageSize),
        totalItems: result.total,
        hasNext: page * pageSize < result.total,
        hasPrevious: page > 1,
      },
    },
  });
});

app.get('/api/v1/users/:id', async (req, res) => {
  const user = await userService.findById(req.params.id);

  if (!user) {
    throw new NotFoundError('User not found');
  }

  res.json({
    success: true,
    data: user,
  });
});

app.post('/api/v1/users', validate(userSchema), async (req, res) => {
  const user = await userService.create(req.body);

  res.status(201).json({
    success: true,
    data: user,
  });
});

app.patch('/api/v1/users/:id', async (req, res) => {
  const user = await userService.update(req.params.id, req.body);

  res.json({
    success: true,
    data: user,
  });
});

app.delete('/api/v1/users/:id', async (req, res) => {
  await userService.delete(req.params.id);

  res.status(204).send();
});
```

## GraphQL API Design

### Schema Definition

```graphql
# schema.graphql
type User {
  id: ID!
  email: String!
  name: String!
  posts(first: Int, after: String): PostConnection!
  createdAt: DateTime!
}

type Post {
  id: ID!
  title: String!
  content: String!
  author: User!
  published: Boolean!
  createdAt: DateTime!
  updatedAt: DateTime!
}

type PostConnection {
  edges: [PostEdge!]!
  pageInfo: PageInfo!
  totalCount: Int!
}

type PostEdge {
  cursor: String!
  node: Post!
}

type PageInfo {
  hasNextPage: Boolean!
  hasPreviousPage: Boolean!
  startCursor: String
  endCursor: String
}

type Query {
  user(id: ID!): User
  users(first: Int, after: String): UserConnection!
  post(id: ID!): Post
  posts(first: Int, after: String): PostConnection!
}

type Mutation {
  createUser(input: CreateUserInput!): User!
  updateUser(id: ID!, input: UpdateUserInput!): User!
  deleteUser(id: ID!): Boolean!
  createPost(input: CreatePostInput!): Post!
}

input CreateUserInput {
  email: String!
  name: String!
}

input UpdateUserInput {
  email: String
  name: String
}

input CreatePostInput {
  title: String!
  content: String!
  authorId: ID!
}

scalar DateTime
```

### Resolver Implementation (TypeScript)

```typescript
import { GraphQLError } from 'graphql';

const resolvers = {
  Query: {
    user: async (_parent, { id }, context) => {
      if (!context.user) {
        throw new GraphQLError('Unauthorized', {
          extensions: { code: 'UNAUTHENTICATED' },
        });
      }

      const user = await context.dataSources.userService.findById(id);

      if (!user) {
        throw new GraphQLError('User not found', {
          extensions: { code: 'NOT_FOUND' },
        });
      }

      return user;
    },

    users: async (_parent, { first = 20, after }, context) => {
      const result = await context.dataSources.userService.list({
        first,
        after,
      });

      return {
        edges: result.items.map(item => ({
          cursor: item.cursor,
          node: item,
        })),
        pageInfo: {
          hasNextPage: result.hasNextPage,
          hasPreviousPage: result.hasPreviousPage,
          startCursor: result.startCursor,
          endCursor: result.endCursor,
        },
        totalCount: result.totalCount,
      };
    },
  },

  Mutation: {
    createUser: async (_parent, { input }, context) => {
      if (!context.user) {
        throw new GraphQLError('Unauthorized', {
          extensions: { code: 'UNAUTHENTICATED' },
        });
      }

      try {
        const user = await context.dataSources.userService.create(input);
        return user;
      } catch (error) {
        if (error.code === 'DUPLICATE_EMAIL') {
          throw new GraphQLError('Email already exists', {
            extensions: { code: 'BAD_USER_INPUT' },
          });
        }
        throw error;
      }
    },
  },

  User: {
    posts: async (parent, { first, after }, context) => {
      return context.dataSources.postService.listByUser(parent.id, {
        first,
        after,
      });
    },
  },

  Post: {
    author: async (parent, _args, context) => {
      return context.dataSources.userService.findById(parent.authorId);
    },
  },
};

// DataLoader for N+1 prevention
import DataLoader from 'dataloader';

const createLoaders = (dataSources) => ({
  userLoader: new DataLoader(async (userIds) => {
    const users = await dataSources.userService.findByIds(userIds);
    return userIds.map(id => users.find(user => user.id === id));
  }),
});
```

## gRPC API Design

### Protocol Buffer Definition

```protobuf
syntax = "proto3";

package user.v1;

service UserService {
  rpc GetUser(GetUserRequest) returns (User);
  rpc ListUsers(ListUsersRequest) returns (ListUsersResponse);
  rpc CreateUser(CreateUserRequest) returns (User);
  rpc UpdateUser(UpdateUserRequest) returns (User);
  rpc DeleteUser(DeleteUserRequest) returns (DeleteUserResponse);
  rpc StreamUsers(StreamUsersRequest) returns (stream User);
}

message User {
  string id = 1;
  string email = 2;
  string name = 3;
  int64 created_at = 4;
}

message GetUserRequest {
  string id = 1;
}

message ListUsersRequest {
  int32 page = 1;
  int32 page_size = 2;
}

message ListUsersResponse {
  repeated User users = 1;
  int32 total = 2;
  bool has_next = 3;
}

message CreateUserRequest {
  string email = 1;
  string name = 2;
}

message UpdateUserRequest {
  string id = 1;
  optional string email = 2;
  optional string name = 3;
}

message DeleteUserRequest {
  string id = 1;
}

message DeleteUserResponse {
  bool success = 1;
}

message StreamUsersRequest {
  // Empty for now
}
```

### gRPC Server (Go)

```go
package main

import (
    "context"
    "google.golang.org/grpc"
    "google.golang.org/grpc/codes"
    "google.golang.org/grpc/status"
    pb "myapp/proto/user/v1"
)

type server struct {
    pb.UnimplementedUserServiceServer
    userService UserService
}

func (s *server) GetUser(ctx context.Context, req *pb.GetUserRequest) (*pb.User, error) {
    user, err := s.userService.FindById(ctx, req.Id)
    if err != nil {
        if errors.Is(err, ErrNotFound) {
            return nil, status.Error(codes.NotFound, "user not found")
        }
        return nil, status.Error(codes.Internal, "internal error")
    }

    return &pb.User{
        Id:        user.ID,
        Email:     user.Email,
        Name:      user.Name,
        CreatedAt: user.CreatedAt.Unix(),
    }, nil
}

func (s *server) ListUsers(ctx context.Context, req *pb.ListUsersRequest) (*pb.ListUsersResponse, error) {
    page := req.Page
    if page < 1 {
        page = 1
    }
    pageSize := req.PageSize
    if pageSize < 1 || pageSize > 100 {
        pageSize = 20
    }

    result, err := s.userService.List(ctx, page, pageSize)
    if err != nil {
        return nil, status.Error(codes.Internal, "internal error")
    }

    users := make([]*pb.User, len(result.Items))
    for i, u := range result.Items {
        users[i] = &pb.User{
            Id:        u.ID,
            Email:     u.Email,
            Name:      u.Name,
            CreatedAt: u.CreatedAt.Unix(),
        }
    }

    return &pb.ListUsersResponse{
        Users:   users,
        Total:   int32(result.Total),
        HasNext: result.HasNext,
    }, nil
}

func (s *server) CreateUser(ctx context.Context, req *pb.CreateUserRequest) (*pb.User, error) {
    if req.Email == "" {
        return nil, status.Error(codes.InvalidArgument, "email is required")
    }
    if req.Name == "" {
        return nil, status.Error(codes.InvalidArgument, "name is required")
    }

    user, err := s.userService.Create(ctx, CreateUserInput{
        Email: req.Email,
        Name:  req.Name,
    })
    if err != nil {
        return nil, status.Error(codes.Internal, "internal error")
    }

    return &pb.User{
        Id:        user.ID,
        Email:     user.Email,
        Name:      user.Name,
        CreatedAt: user.CreatedAt.Unix(),
    }, nil
}

func (s *server) StreamUsers(req *pb.StreamUsersRequest, stream pb.UserService_StreamUsersServer) error {
    users, err := s.userService.FindAll(stream.Context())
    if err != nil {
        return status.Error(codes.Internal, "internal error")
    }

    for _, user := range users {
        if err := stream.Send(&pb.User{
            Id:        user.ID,
            Email:     user.Email,
            Name:      user.Name,
            CreatedAt: user.CreatedAt.Unix(),
        }); err != nil {
            return err
        }
    }

    return nil
}
```

## API Versioning Strategies

### URL Path Versioning
```
/api/v1/users
/api/v2/users
```

### Header Versioning
```
GET /api/users
Accept: application/vnd.myapp.v2+json
```

### Query Parameter Versioning
```
/api/users?version=2
```

## API Security

### JWT Authentication
```typescript
import jwt from 'jsonwebtoken';

interface JwtPayload {
  userId: string;
  email: string;
}

const authMiddleware = async (req, res, next) => {
  const token = req.headers.authorization?.replace('Bearer ', '');

  if (!token) {
    return res.status(401).json({
      success: false,
      error: { code: 'UNAUTHORIZED', message: 'Authentication required' },
    });
  }

  try {
    const payload = jwt.verify(token, process.env.JWT_SECRET) as JwtPayload;
    req.user = await userService.findById(payload.userId);
    next();
  } catch (error) {
    return res.status(401).json({
      success: false,
      error: { code: 'INVALID_TOKEN', message: 'Invalid or expired token' },
    });
  }
};
```

### Rate Limiting
```typescript
import rateLimit from 'express-rate-limit';
import RedisStore from 'rate-limit-redis';

const limiter = rateLimit({
  store: new RedisStore({
    client: redis,
    prefix: 'rl:',
  }),
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // Limit each IP to 100 requests per windowMs
  message: {
    success: false,
    error: {
      code: 'RATE_LIMIT_EXCEEDED',
      message: 'Too many requests, please try again later',
    },
  },
  standardHeaders: true,
  legacyHeaders: false,
});

app.use('/api/', limiter);
```

### API Key Authentication
```typescript
const apiKeyAuth = async (req, res, next) => {
  const apiKey = req.headers['x-api-key'];

  if (!apiKey) {
    return res.status(401).json({
      success: false,
      error: { code: 'API_KEY_REQUIRED', message: 'API key is required' },
    });
  }

  const key = await apiKeyService.validate(apiKey);

  if (!key || !key.isActive) {
    return res.status(401).json({
      success: false,
      error: { code: 'INVALID_API_KEY', message: 'Invalid API key' },
    });
  }

  req.apiKey = key;
  next();
};
```

## API Documentation with OpenAPI

```yaml
openapi: 3.0.0
info:
  title: My API
  version: 1.0.0
  description: API for managing users and posts

servers:
  - url: https://api.example.com/v1
    description: Production server

paths:
  /users:
    get:
      summary: List users
      parameters:
        - in: query
          name: page
          schema:
            type: integer
          description: Page number
        - in: query
          name: pageSize
          schema:
            type: integer
          description: Number of items per page
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                type: object
                properties:
                  success:
                    type: boolean
                  data:
                    type: object
                    properties:
                      items:
                        type: array
                        items:
                          $ref: '#/components/schemas/User'
                      pagination:
                        $ref: '#/components/schemas/Pagination'
    post:
      summary: Create user
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateUserInput'
      responses:
        '201':
          description: User created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'

components:
  schemas:
    User:
      type: object
      properties:
        id:
          type: string
        email:
          type: string
        name:
          type: string
    CreateUserInput:
      type: object
      required:
        - email
        - name
      properties:
        email:
          type: string
        name:
          type: string
    Pagination:
      type: object
      properties:
        page:
          type: integer
        totalPages:
          type: integer
```

## Best Practices

1. **Use proper HTTP methods and status codes**
2. **Version your APIs**
3. **Implement pagination for list endpoints**
4. **Use consistent response formats**
5. **Validate all inputs**
6. **Implement rate limiting**
7. **Secure with authentication and authorization**
8. **Document your API**
9. **Monitor and log API usage**
10. **Handle errors gracefully**
