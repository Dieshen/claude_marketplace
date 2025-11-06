# AI/ML Integration Patterns

Comprehensive patterns for integrating AI/ML capabilities with LangChain, RAG, vector databases, and prompt engineering.

## LangChain Integration

### Basic LLM Setup

```typescript
import { ChatOpenAI } from 'langchain/chat_models/openai';
import { HumanMessage, SystemMessage } from 'langchain/schema';

const model = new ChatOpenAI({
  openAIApiKey: process.env.OPENAI_API_KEY,
  modelName: 'gpt-4-turbo-preview',
  temperature: 0.7,
});

async function chat(userMessage: string) {
  const messages = [
    new SystemMessage('You are a helpful assistant.'),
    new HumanMessage(userMessage),
  ];

  const response = await model.invoke(messages);
  return response.content;
}
```

### Chains for Sequential Processing

```typescript
import { LLMChain } from 'langchain/chains';
import { PromptTemplate } from 'langchain/prompts';

const summaryTemplate = `
Summarize the following text in 2-3 sentences:

Text: {text}

Summary:`;

const prompt = new PromptTemplate({
  template: summaryTemplate,
  inputVariables: ['text'],
});

const chain = new LLMChain({
  llm: model,
  prompt,
});

const result = await chain.call({ text: 'Long text here...' });
```

## RAG (Retrieval Augmented Generation)

### Vector Store Setup

```typescript
import { OpenAIEmbeddings } from 'langchain/embeddings/openai';
import { PineconeStore } from 'langchain/vectorstores/pinecone';
import { Pinecone } from '@pinecone-database/pinecone';
import { RecursiveCharacterTextSplitter } from 'langchain/text_splitter';

// Initialize Pinecone
const pinecone = new Pinecone({
  apiKey: process.env.PINECONE_API_KEY,
});

const index = pinecone.Index('my-index');

// Create embeddings
const embeddings = new OpenAIEmbeddings({
  openAIApiKey: process.env.OPENAI_API_KEY,
});

// Split documents
const textSplitter = new RecursiveCharacterTextSplitter({
  chunkSize: 1000,
  chunkOverlap: 200,
});

const docs = await textSplitter.createDocuments([longText]);

// Store in vector database
await PineconeStore.fromDocuments(docs, embeddings, {
  pineconeIndex: index,
  namespace: 'my-namespace',
});
```

### RAG Chain

```typescript
import { RetrievalQAChain } from 'langchain/chains';
import { ChatOpenAI } from 'langchain/chat_models/openai';

// Create vector store
const vectorStore = await PineconeStore.fromExistingIndex(embeddings, {
  pineconeIndex: index,
  namespace: 'my-namespace',
});

// Create retriever
const retriever = vectorStore.asRetriever({
  k: 4, // Return top 4 most relevant documents
});

// Create RAG chain
const chain = RetrievalQAChain.fromLLM(
  new ChatOpenAI({ modelName: 'gpt-4' }),
  retriever
);

// Query
const response = await chain.call({
  query: 'What is the return policy?',
});

console.log(response.text);
```

### Advanced RAG with Contextual Compression

```typescript
import { ContextualCompressionRetriever } from 'langchain/retrievers/contextual_compression';
import { LLMChainExtractor } from 'langchain/retrievers/document_compressors/chain_extract';

const baseRetriever = vectorStore.asRetriever();

const compressor = LLMChainExtractor.fromLLM(
  new ChatOpenAI({
    modelName: 'gpt-3.5-turbo',
    temperature: 0,
  })
);

const retriever = new ContextualCompressionRetriever({
  baseCompressor: compressor,
  baseRetriever,
});

const relevantDocs = await retriever.getRelevantDocuments(
  'What is the pricing structure?'
);
```

## Prompt Engineering

### Few-Shot Learning

```typescript
import { FewShotPromptTemplate, PromptTemplate } from 'langchain/prompts';

const examples = [
  {
    question: 'Who is the CEO of Tesla?',
    answer: 'Elon Musk is the CEO of Tesla.',
  },
  {
    question: 'When was Apple founded?',
    answer: 'Apple was founded in 1976.',
  },
];

const examplePrompt = new PromptTemplate({
  inputVariables: ['question', 'answer'],
  template: 'Q: {question}\nA: {answer}',
});

const fewShotPrompt = new FewShotPromptTemplate({
  examples,
  examplePrompt,
  prefix: 'Answer the following questions accurately:',
  suffix: 'Q: {input}\nA:',
  inputVariables: ['input'],
});

const formatted = await fewShotPrompt.format({
  input: 'Who founded Microsoft?',
});
```

### Structured Output

```typescript
import { z } from 'zod';
import { StructuredOutputParser } from 'langchain/output_parsers';

const parser = StructuredOutputParser.fromZodSchema(
  z.object({
    name: z.string().describe('The person\'s name'),
    age: z.number().describe('The person\'s age'),
    occupation: z.string().describe('The person\'s occupation'),
  })
);

const prompt = PromptTemplate.fromTemplate(
  `Extract information about the person.

{format_instructions}

Text: {text}

Output:`
);

const input = await prompt.format({
  text: 'John Doe is a 30-year-old software engineer.',
  format_instructions: parser.getFormatInstructions(),
});

const response = await model.invoke(input);
const parsed = await parser.parse(response.content);
// { name: 'John Doe', age: 30, occupation: 'software engineer' }
```

## Memory and Conversation

### Conversation Buffer Memory

```typescript
import { ConversationChain } from 'langchain/chains';
import { BufferMemory } from 'langchain/memory';

const memory = new BufferMemory();

const chain = new ConversationChain({
  llm: model,
  memory,
});

// First turn
await chain.call({ input: 'Hi, my name is John.' });
// Response: Hello John! How can I help you today?

// Second turn (remembers name)
await chain.call({ input: 'What is my name?' });
// Response: Your name is John.
```

### Summary Memory

```typescript
import { ConversationSummaryMemory } from 'langchain/memory';

const memory = new ConversationSummaryMemory({
  llm: new ChatOpenAI({ modelName: 'gpt-3.5-turbo' }),
  maxTokenLimit: 2000,
});

const chain = new ConversationChain({ llm: model, memory });
```

## Agents

### Tool-Using Agent

```typescript
import { initializeAgentExecutorWithOptions } from 'langchain/agents';
import { Calculator } from 'langchain/tools/calculator';
import { SerpAPI } from 'langchain/tools';

const tools = [
  new Calculator(),
  new SerpAPI(process.env.SERPAPI_API_KEY),
];

const executor = await initializeAgentExecutorWithOptions(tools, model, {
  agentType: 'zero-shot-react-description',
  verbose: true,
});

const result = await executor.call({
  input: 'What is the current temperature in San Francisco and what is 25% of 80?',
});
```

### Custom Tool

```typescript
import { DynamicTool } from 'langchain/tools';

const databaseTool = new DynamicTool({
  name: 'database-query',
  description: 'Useful for querying the database. Input should be a SQL query.',
  func: async (query: string) => {
    const results = await db.query(query);
    return JSON.stringify(results);
  },
});

const tools = [databaseTool];

const executor = await initializeAgentExecutorWithOptions(tools, model, {
  agentType: 'zero-shot-react-description',
});
```

## Streaming Responses

```typescript
import { ChatOpenAI } from 'langchain/chat_models/openai';

const model = new ChatOpenAI({
  streaming: true,
  callbacks: [
    {
      handleLLMNewToken(token: string) {
        process.stdout.write(token);
      },
    },
  ],
});

await model.invoke([new HumanMessage('Tell me a story')]);
```

## Embeddings for Semantic Search

```typescript
import { OpenAIEmbeddings } from 'langchain/embeddings/openai';

const embeddings = new OpenAIEmbeddings();

// Generate embeddings
const queryEmbedding = await embeddings.embedQuery('What is machine learning?');

// Store in database with pgvector
await db.query(
  'INSERT INTO documents (content, embedding) VALUES ($1, $2)',
  ['Machine learning is...', queryEmbedding]
);

// Semantic search
const results = await db.query(
  'SELECT content FROM documents ORDER BY embedding <=> $1 LIMIT 5',
  [queryEmbedding]
);
```

## Document Loaders

```typescript
import { PDFLoader } from 'langchain/document_loaders/fs/pdf';
import { CSVLoader } from 'langchain/document_loaders/fs/csv';
import { GithubRepoLoader } from 'langchain/document_loaders/web/github';

// Load PDF
const pdfLoader = new PDFLoader('document.pdf');
const pdfDocs = await pdfLoader.load();

// Load CSV
const csvLoader = new CSVLoader('data.csv');
const csvDocs = await csvLoader.load();

// Load GitHub repo
const githubLoader = new GithubRepoLoader(
  'https://github.com/user/repo',
  { branch: 'main', recursive: true }
);
const githubDocs = await githubLoader.load();
```

## Evaluation

```typescript
import { loadEvaluator } from 'langchain/evaluation';

// Evaluate response quality
const evaluator = await loadEvaluator('qa');

const result = await evaluator.evaluateStrings({
  prediction: 'The capital of France is Paris.',
  input: 'What is the capital of France?',
  reference: 'Paris is the capital of France.',
});

console.log(result);
// { score: 1.0, reasoning: '...' }
```

## Best Practices

### 1. Prompt Design
- Be specific and clear
- Provide context and examples
- Use system messages for role definition
- Iterate and test prompts

### 2. RAG Optimization
- Chunk documents appropriately (1000-2000 chars)
- Use overlap for context preservation
- Implement re-ranking for better results
- Monitor retrieval quality

### 3. Cost Management
- Use appropriate models (GPT-3.5 vs GPT-4)
- Implement caching
- Batch requests when possible
- Monitor token usage

### 4. Error Handling
- Handle rate limits
- Implement retries with exponential backoff
- Validate LLM outputs
- Provide fallbacks

### 5. Security
- Sanitize user inputs
- Implement output filtering
- Rate limit API calls
- Protect API keys

### 6. Testing
- Test prompts with various inputs
- Evaluate output quality
- Monitor for hallucinations
- A/B test different approaches

## Vector Database Options

- **Pinecone**: Managed, scalable
- **Weaviate**: Open-source, feature-rich
- **Qdrant**: Fast, efficient
- **ChromaDB**: Simple, lightweight
- **pgvector**: PostgreSQL extension
- **Milvus**: Open-source, distributed

## Model Selection Guide

- **GPT-4**: Complex reasoning, highest quality
- **GPT-3.5-Turbo**: Fast, cost-effective
- **Claude**: Long context, safety-focused
- **Llama 2**: Open-source, self-hosted
- **Mistral**: Open-source, efficient
