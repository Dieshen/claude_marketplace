# API Documentation Generator Skill

Automatically generate comprehensive API documentation from code.

## OpenAPI 3.0 Generation

### From Express.js/TypeScript

```typescript
/**
 * @openapi
 * /api/users:
 *   get:
 *     summary: List all users
 *     tags: [Users]
 *     parameters:
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *         description: Page number
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *         description: Items per page
 *     responses:
 *       200:
 *         description: Success
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 users:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/User'
 *                 pagination:
 *                   $ref: '#/components/schemas/Pagination'
 */
app.get('/api/users', async (req, res) => {
  // Implementation
});
```

### Complete OpenAPI Spec Template

```yaml
openapi: 3.0.0
info:
  title: My API
  version: 1.0.0
  description: Comprehensive API for managing users and resources
  contact:
    name: API Support
    email: support@example.com
  license:
    name: MIT
    url: https://opensource.org/licenses/MIT

servers:
  - url: https://api.example.com/v1
    description: Production server
  - url: https://staging-api.example.com/v1
    description: Staging server
  - url: http://localhost:3000/v1
    description: Development server

tags:
  - name: Users
    description: User management endpoints
  - name: Authentication
    description: Authentication endpoints

paths:
  /auth/login:
    post:
      summary: User login
      tags: [Authentication]
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required:
                - email
                - password
              properties:
                email:
                  type: string
                  format: email
                  example: user@example.com
                password:
                  type: string
                  format: password
                  example: SecurePass123!
      responses:
        '200':
          description: Login successful
          content:
            application/json:
              schema:
                type: object
                properties:
                  token:
                    type: string
                    example: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
                  user:
                    $ref: '#/components/schemas/User'
        '401':
          description: Invalid credentials
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'

  /users:
    get:
      summary: List users
      tags: [Users]
      security:
        - BearerAuth: []
      parameters:
        - $ref: '#/components/parameters/PageParam'
        - $ref: '#/components/parameters/LimitParam'
        - in: query
          name: search
          schema:
            type: string
          description: Search term
      responses:
        '200':
          description: Success
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items:
                      $ref: '#/components/schemas/User'
                  pagination:
                    $ref: '#/components/schemas/Pagination'

    post:
      summary: Create user
      tags: [Users]
      security:
        - BearerAuth: []
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
        '400':
          $ref: '#/components/responses/BadRequest'
        '401':
          $ref: '#/components/responses/Unauthorized'

  /users/{id}:
    parameters:
      - $ref: '#/components/parameters/UserIdParam'

    get:
      summary: Get user by ID
      tags: [Users]
      security:
        - BearerAuth: []
      responses:
        '200':
          description: Success
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
        '404':
          $ref: '#/components/responses/NotFound'

    patch:
      summary: Update user
      tags: [Users]
      security:
        - BearerAuth: []
      requestBody:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/UpdateUserInput'
      responses:
        '200':
          description: User updated
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'

    delete:
      summary: Delete user
      tags: [Users]
      security:
        - BearerAuth: []
      responses:
        '204':
          description: User deleted
        '404':
          $ref: '#/components/responses/NotFound'

components:
  securitySchemes:
    BearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT

  parameters:
    UserIdParam:
      in: path
      name: id
      required: true
      schema:
        type: string
      description: User ID

    PageParam:
      in: query
      name: page
      schema:
        type: integer
        minimum: 1
        default: 1
      description: Page number

    LimitParam:
      in: query
      name: limit
      schema:
        type: integer
        minimum: 1
        maximum: 100
        default: 20
      description: Items per page

  schemas:
    User:
      type: object
      required:
        - id
        - email
        - name
      properties:
        id:
          type: string
          example: usr_123abc
        email:
          type: string
          format: email
          example: user@example.com
        name:
          type: string
          example: John Doe
        role:
          type: string
          enum: [user, admin]
          default: user
        createdAt:
          type: string
          format: date-time
        updatedAt:
          type: string
          format: date-time

    CreateUserInput:
      type: object
      required:
        - email
        - name
        - password
      properties:
        email:
          type: string
          format: email
        name:
          type: string
          minLength: 1
          maxLength: 100
        password:
          type: string
          format: password
          minLength: 8

    UpdateUserInput:
      type: object
      properties:
        name:
          type: string
        email:
          type: string
          format: email

    Pagination:
      type: object
      properties:
        page:
          type: integer
        limit:
          type: integer
        totalPages:
          type: integer
        totalItems:
          type: integer
        hasNext:
          type: boolean
        hasPrevious:
          type: boolean

    Error:
      type: object
      properties:
        code:
          type: string
        message:
          type: string
        details:
          type: object

  responses:
    BadRequest:
      description: Bad request
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'

    Unauthorized:
      description: Unauthorized
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'

    NotFound:
      description: Not found
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
```

## Generate from Code

### TypeScript/Express
```typescript
import swaggerJsdoc from 'swagger-jsdoc';
import swaggerUi from 'swagger-ui-express';

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'My API',
      version: '1.0.0',
    },
  },
  apis: ['./src/routes/*.ts'],
};

const specs = swaggerJsdoc(options);
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(specs));
```

### Python/FastAPI (Auto-generated)
```python
from fastapi import FastAPI, Query
from pydantic import BaseModel

app = FastAPI(
    title="My API",
    description="API documentation",
    version="1.0.0"
)

class User(BaseModel):
    id: str
    email: str
    name: str

@app.get("/users", response_model=list[User])
async def list_users(
    page: int = Query(1, ge=1, description="Page number"),
    limit: int = Query(20, ge=1, le=100, description="Items per page")
):
    """
    List all users with pagination.

    Returns a paginated list of users.
    """
    pass
# Docs auto-generated at /docs
```

## README API Documentation

```markdown
# API Documentation

## Base URL
```
https://api.example.com/v1
```

## Authentication
All endpoints require Bearer token authentication:
```
Authorization: Bearer YOUR_TOKEN_HERE
```

## Endpoints

### List Users
```http
GET /users?page=1&limit=20
```

**Query Parameters**:
- `page` (integer, optional): Page number, default 1
- `limit` (integer, optional): Items per page, default 20, max 100
- `search` (string, optional): Search term

**Response 200**:
```json
{
  "data": [
    {
      "id": "usr_123",
      "email": "user@example.com",
      "name": "John Doe",
      "role": "user",
      "createdAt": "2024-01-01T00:00:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "totalPages": 5,
    "totalItems": 95
  }
}
```

### Create User
```http
POST /users
Content-Type: application/json

{
  "email": "newuser@example.com",
  "name": "New User",
  "password": "SecurePass123!"
}
```

**Response 201**:
```json
{
  "id": "usr_456",
  "email": "newuser@example.com",
  "name": "New User",
  "role": "user",
  "createdAt": "2024-01-01T00:00:00Z"
}
```

## Error Responses

All errors follow this format:
```json
{
  "code": "ERROR_CODE",
  "message": "Human-readable message",
  "details": {}
}
```

### Status Codes
- `200` - Success
- `201` - Created
- `204` - No Content
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `422` - Validation Error
- `429` - Rate Limit Exceeded
- `500` - Internal Server Error

## Rate Limiting
- 100 requests per minute per IP
- 1000 requests per hour per user

## Code Examples

### JavaScript/Fetch
```javascript
const response = await fetch('https://api.example.com/v1/users', {
  headers: {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'application/json'
  }
});
const data = await response.json();
```

### Python/Requests
```python
import requests

response = requests.get(
    'https://api.example.com/v1/users',
    headers={'Authorization': f'Bearer {token}'}
)
data = response.json()
```

### cURL
```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
     https://api.example.com/v1/users
```
```

## Postman Collection

Generate Postman collection from OpenAPI:
```bash
openapi2postmanv2 -s openapi.yaml -o postman_collection.json
```

## Best Practices

1. **Be Comprehensive**: Document all endpoints, parameters, and responses
2. **Provide Examples**: Include real request/response examples
3. **Document Errors**: Show all possible error responses
4. **Code Samples**: Provide examples in multiple languages
5. **Keep Updated**: Auto-generate from code when possible
6. **Version APIs**: Include version in URL or headers
7. **Security**: Document authentication clearly
8. **Rate Limits**: Specify rate limiting rules
9. **Changelog**: Maintain API changelog
10. **Interactive Docs**: Use Swagger UI or similar

## Tools

- **Swagger UI**: Interactive API documentation
- **Redoc**: Beautiful API documentation
- **Postman**: API testing and documentation
- **Insomnia**: API client and documentation
- **Stoplight**: API design and documentation platform
