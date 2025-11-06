# Code Quality & Refactoring Patterns

Comprehensive refactoring patterns, SOLID principles, and clean code practices for maintainable software.

## SOLID Principles

### Single Responsibility Principle (SRP)
A class should have one, and only one, reason to change.

```typescript
// Bad: Multiple responsibilities
class User {
  constructor(public name: string, public email: string) {}

  save() {
    // Database logic
    db.query('INSERT INTO users...');
  }

  sendEmail() {
    // Email logic
    emailService.send(this.email, 'Welcome!');
  }

  generateReport() {
    // Report generation logic
    return `User: ${this.name}`;
  }
}

// Good: Single responsibility per class
class User {
  constructor(public name: string, public email: string) {}
}

class UserRepository {
  save(user: User) {
    db.query('INSERT INTO users...', user);
  }
}

class UserEmailService {
  sendWelcomeEmail(user: User) {
    emailService.send(user.email, 'Welcome!');
  }
}

class UserReportGenerator {
  generate(user: User): string {
    return `User: ${user.name}`;
  }
}
```

### Open/Closed Principle (OCP)
Software entities should be open for extension, but closed for modification.

```typescript
// Bad: Must modify class to add new shapes
class AreaCalculator {
  calculate(shapes: any[]) {
    let area = 0;
    for (const shape of shapes) {
      if (shape.type === 'circle') {
        area += Math.PI * shape.radius ** 2;
      } else if (shape.type === 'square') {
        area += shape.side ** 2;
      }
      // Need to modify for new shapes
    }
    return area;
  }
}

// Good: Open for extension, closed for modification
interface Shape {
  area(): number;
}

class Circle implements Shape {
  constructor(public radius: number) {}

  area(): number {
    return Math.PI * this.radius ** 2;
  }
}

class Square implements Shape {
  constructor(public side: number) {}

  area(): number {
    return this.side ** 2;
  }
}

class Triangle implements Shape {
  constructor(public base: number, public height: number) {}

  area(): number {
    return (this.base * this.height) / 2;
  }
}

class AreaCalculator {
  calculate(shapes: Shape[]): number {
    return shapes.reduce((total, shape) => total + shape.area(), 0);
  }
}
```

### Liskov Substitution Principle (LSP)
Objects of a superclass should be replaceable with objects of its subclasses without breaking the application.

```typescript
// Bad: Violates LSP
class Bird {
  fly() {
    console.log('Flying');
  }
}

class Penguin extends Bird {
  fly() {
    throw new Error('Penguins cannot fly!');
  }
}

// Good: Proper abstraction
interface Bird {
  move(): void;
}

class FlyingBird implements Bird {
  move() {
    this.fly();
  }

  fly() {
    console.log('Flying');
  }
}

class Penguin implements Bird {
  move() {
    this.swim();
  }

  swim() {
    console.log('Swimming');
  }
}
```

### Interface Segregation Principle (ISP)
Clients should not be forced to depend on interfaces they don't use.

```typescript
// Bad: Fat interface
interface Worker {
  work(): void;
  eat(): void;
  sleep(): void;
}

class Human implements Worker {
  work() { console.log('Working'); }
  eat() { console.log('Eating'); }
  sleep() { console.log('Sleeping'); }
}

class Robot implements Worker {
  work() { console.log('Working'); }
  eat() { throw new Error('Robots dont eat'); }
  sleep() { throw new Error('Robots dont sleep'); }
}

// Good: Segregated interfaces
interface Workable {
  work(): void;
}

interface Eatable {
  eat(): void;
}

interface Sleepable {
  sleep(): void;
}

class Human implements Workable, Eatable, Sleepable {
  work() { console.log('Working'); }
  eat() { console.log('Eating'); }
  sleep() { console.log('Sleeping'); }
}

class Robot implements Workable {
  work() { console.log('Working'); }
}
```

### Dependency Inversion Principle (DIP)
High-level modules should not depend on low-level modules. Both should depend on abstractions.

```typescript
// Bad: High-level depends on low-level
class MySQLDatabase {
  save(data: any) {
    console.log('Saving to MySQL');
  }
}

class UserService {
  private db = new MySQLDatabase(); // Tight coupling

  saveUser(user: User) {
    this.db.save(user);
  }
}

// Good: Both depend on abstraction
interface Database {
  save(data: any): void;
}

class MySQLDatabase implements Database {
  save(data: any) {
    console.log('Saving to MySQL');
  }
}

class PostgreSQLDatabase implements Database {
  save(data: any) {
    console.log('Saving to PostgreSQL');
  }
}

class UserService {
  constructor(private db: Database) {} // Dependency injection

  saveUser(user: User) {
    this.db.save(user);
  }
}

// Usage
const service = new UserService(new MySQLDatabase());
```

## Common Code Smells and Refactoring

### Long Method
```typescript
// Bad: Long method
function processOrder(order: Order) {
  // Validate order (20 lines)
  if (!order.items || order.items.length === 0) {
    throw new Error('No items');
  }
  // Calculate totals (30 lines)
  let total = 0;
  for (const item of order.items) {
    total += item.price * item.quantity;
  }
  // Apply discounts (25 lines)
  if (order.coupon) {
    total -= total * order.coupon.discount;
  }
  // Process payment (40 lines)
  // Send notifications (20 lines)
  // Update inventory (30 lines)
}

// Good: Extract methods
function processOrder(order: Order) {
  validateOrder(order);
  const total = calculateTotal(order);
  const finalTotal = applyDiscounts(total, order.coupon);
  processPayment(order, finalTotal);
  sendNotifications(order);
  updateInventory(order);
}

function validateOrder(order: Order) {
  if (!order.items || order.items.length === 0) {
    throw new Error('Order must contain items');
  }
}

function calculateTotal(order: Order): number {
  return order.items.reduce(
    (sum, item) => sum + item.price * item.quantity,
    0
  );
}

function applyDiscounts(total: number, coupon?: Coupon): number {
  if (!coupon) return total;
  return total * (1 - coupon.discount);
}
```

### Duplicated Code
```typescript
// Bad: Duplicated logic
class UserController {
  async getUser(req, res) {
    try {
      const user = await userService.findById(req.params.id);
      if (!user) {
        return res.status(404).json({ error: 'User not found' });
      }
      res.json(user);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  async updateUser(req, res) {
    try {
      const user = await userService.findById(req.params.id);
      if (!user) {
        return res.status(404).json({ error: 'User not found' });
      }
      const updated = await userService.update(req.params.id, req.body);
      res.json(updated);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }
}

// Good: Extract common logic
class UserController {
  private async handleRequest(
    req: Request,
    res: Response,
    handler: (user: User) => Promise<any>
  ) {
    try {
      const user = await userService.findById(req.params.id);
      if (!user) {
        return res.status(404).json({ error: 'User not found' });
      }
      const result = await handler(user);
      res.json(result);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  async getUser(req: Request, res: Response) {
    await this.handleRequest(req, res, (user) => user);
  }

  async updateUser(req: Request, res: Response) {
    await this.handleRequest(req, res, (user) =>
      userService.update(user.id, req.body)
    );
  }
}
```

### Large Class (God Object)
```typescript
// Bad: Too many responsibilities
class Order {
  items: Item[];
  customer: Customer;
  total: number;

  calculateTotal() { /* ... */ }
  applyDiscount() { /* ... */ }
  validateOrder() { /* ... */ }
  processPayment() { /* ... */ }
  sendEmail() { /* ... */ }
  updateInventory() { /* ... */ }
  generateInvoice() { /* ... */ }
  shipOrder() { /* ... */ }
}

// Good: Split responsibilities
class Order {
  constructor(
    public items: Item[],
    public customer: Customer
  ) {}
}

class OrderCalculator {
  calculateTotal(order: Order): number { /* ... */ }
  applyDiscount(order: Order, discount: Discount): number { /* ... */ }
}

class OrderValidator {
  validate(order: Order): boolean { /* ... */ }
}

class PaymentProcessor {
  process(order: Order, amount: number): Payment { /* ... */ }
}

class OrderNotificationService {
  sendConfirmation(order: Order): void { /* ... */ }
}

class InventoryService {
  updateFromOrder(order: Order): void { /* ... */ }
}

class InvoiceGenerator {
  generate(order: Order): Invoice { /* ... */ }
}

class ShippingService {
  ship(order: Order): Shipment { /* ... */ }
}
```

### Feature Envy
```typescript
// Bad: Method more interested in other class
class Order {
  items: Item[];

  getTotalWeight() {
    let weight = 0;
    for (const item of this.items) {
      weight += item.product.weight * item.quantity;
    }
    return weight;
  }
}

// Good: Move method to where data is
class Order {
  items: Item[];

  getTotalWeight(): number {
    return this.items.reduce((sum, item) => sum + item.getWeight(), 0);
  }
}

class Item {
  constructor(
    public product: Product,
    public quantity: number
  ) {}

  getWeight(): number {
    return this.product.weight * this.quantity;
  }
}
```

## Refactoring Patterns

### Extract Method
```typescript
// Before
function printOwing(invoice: Invoice) {
  console.log('***********************');
  console.log('**** Customer Owes ****');
  console.log('***********************');

  let outstanding = 0;
  for (const order of invoice.orders) {
    outstanding += order.amount;
  }

  console.log(`name: ${invoice.customer}`);
  console.log(`amount: ${outstanding}`);
}

// After
function printOwing(invoice: Invoice) {
  printBanner();
  const outstanding = calculateOutstanding(invoice);
  printDetails(invoice, outstanding);
}

function printBanner() {
  console.log('***********************');
  console.log('**** Customer Owes ****');
  console.log('***********************');
}

function calculateOutstanding(invoice: Invoice): number {
  return invoice.orders.reduce((sum, order) => sum + order.amount, 0);
}

function printDetails(invoice: Invoice, outstanding: number) {
  console.log(`name: ${invoice.customer}`);
  console.log(`amount: ${outstanding}`);
}
```

### Replace Conditional with Polymorphism
```typescript
// Before
class Bird {
  type: string;

  getSpeed(): number {
    switch (this.type) {
      case 'european':
        return this.getBaseSpeed();
      case 'african':
        return this.getBaseSpeed() - this.getLoadFactor() * this.numberOfCoconuts;
      case 'norwegian':
        return this.isNailed ? 0 : this.getBaseSpeed();
      default:
        throw new Error('Unknown type');
    }
  }
}

// After
abstract class Bird {
  abstract getSpeed(): number;
  protected abstract getBaseSpeed(): number;
}

class EuropeanBird extends Bird {
  getSpeed(): number {
    return this.getBaseSpeed();
  }

  protected getBaseSpeed(): number {
    return 35;
  }
}

class AfricanBird extends Bird {
  constructor(private numberOfCoconuts: number) {
    super();
  }

  getSpeed(): number {
    return this.getBaseSpeed() - this.getLoadFactor() * this.numberOfCoconuts;
  }

  protected getBaseSpeed(): number {
    return 40;
  }

  private getLoadFactor(): number {
    return 2;
  }
}

class NorwegianBird extends Bird {
  constructor(private isNailed: boolean) {
    super();
  }

  getSpeed(): number {
    return this.isNailed ? 0 : this.getBaseSpeed();
  }

  protected getBaseSpeed(): number {
    return 30;
  }
}
```

### Replace Magic Numbers with Constants
```typescript
// Before
function calculatePrice(quantity: number, price: number): number {
  if (quantity > 100) {
    return quantity * price * 0.9; // What is 0.9?
  }
  return quantity * price;
}

// After
const BULK_ORDER_THRESHOLD = 100;
const BULK_DISCOUNT_RATE = 0.1;

function calculatePrice(quantity: number, price: number): number {
  if (quantity > BULK_ORDER_THRESHOLD) {
    return quantity * price * (1 - BULK_DISCOUNT_RATE);
  }
  return quantity * price;
}
```

## Clean Code Principles

### Meaningful Names
```typescript
// Bad
function d(t: number) {
  return t * 86400000;
}

// Good
const MILLISECONDS_PER_DAY = 86400000;

function daysToMilliseconds(days: number): number {
  return days * MILLISECONDS_PER_DAY;
}
```

### Functions Should Do One Thing
```typescript
// Bad
function emailClients(clients: Client[]) {
  clients.forEach(client => {
    const clientRecord = database.lookup(client);
    if (clientRecord.isActive()) {
      email(client);
    }
  });
}

// Good
function emailActiveClients(clients: Client[]) {
  clients
    .filter(isActiveClient)
    .forEach(email);
}

function isActiveClient(client: Client): boolean {
  const clientRecord = database.lookup(client);
  return clientRecord.isActive();
}
```

### Use Default Parameters
```typescript
// Bad
function createMenu(title: string, body: string, buttonText: string, cancellable: boolean) {
  title = title || 'Default Title';
  body = body || 'Default Body';
  buttonText = buttonText || 'OK';
  cancellable = cancellable !== undefined ? cancellable : true;
}

// Good
function createMenu(
  title: string = 'Default Title',
  body: string = 'Default Body',
  buttonText: string = 'OK',
  cancellable: boolean = true
) {
  // ...
}
```

## Best Practices

1. **Follow SOLID principles**
2. **Keep functions small and focused**
3. **Use meaningful names**
4. **Avoid code duplication (DRY)**
5. **Write self-documenting code**
6. **Refactor continuously**
7. **Test your code**
8. **Use consistent formatting**
9. **Handle errors properly**
10. **Review and improve regularly**
