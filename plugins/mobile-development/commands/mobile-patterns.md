# Mobile Development Patterns

Comprehensive mobile development patterns for React Native and Flutter with offline-first architecture and best practices.

## React Native Patterns

### Project Structure
```
src/
├── components/        # Reusable UI components
├── screens/          # Screen components
├── navigation/       # Navigation configuration
├── services/         # API and business logic
├── state/           # State management
├── hooks/           # Custom hooks
├── utils/           # Utility functions
└── types/           # TypeScript types
```

### Navigation with React Navigation

```typescript
// navigation/AppNavigator.tsx
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';

type RootStackParamList = {
  Home: undefined;
  Profile: { userId: string };
  Settings: undefined;
};

const Stack = createNativeStackNavigator<RootStackParamList>();
const Tab = createBottomTabNavigator();

function TabNavigator() {
  return (
    <Tab.Navigator>
      <Tab.Screen name="Home" component={HomeScreen} />
      <Tab.Screen name="Profile" component={ProfileScreen} />
      <Tab.Screen name="Settings" component={SettingsScreen} />
    </Tab.Navigator>
  );
}

export function AppNavigator() {
  return (
    <NavigationContainer>
      <Stack.Navigator>
        <Stack.Screen name="Main" component={TabNavigator} />
        <Stack.Screen name="Details" component={DetailsScreen} />
      </Stack.Navigator>
    </NavigationContainer>
  );
}
```

### State Management with Zustand

```typescript
import { create } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';
import AsyncStorage from '@react-native-async-storage/async-storage';

interface User {
  id: string;
  name: string;
  email: string;
}

interface UserStore {
  user: User | null;
  isLoading: boolean;
  error: string | null;
  login: (email: string, password: string) => Promise<void>;
  logout: () => void;
  updateProfile: (data: Partial<User>) => Promise<void>;
}

export const useUserStore = create<UserStore>()(
  persist(
    (set, get) => ({
      user: null,
      isLoading: false,
      error: null,

      login: async (email, password) => {
        set({ isLoading: true, error: null });
        try {
          const user = await authService.login(email, password);
          set({ user, isLoading: false });
        } catch (error) {
          set({ error: error.message, isLoading: false });
        }
      },

      logout: () => {
        set({ user: null });
      },

      updateProfile: async (data) => {
        const currentUser = get().user;
        if (!currentUser) return;

        set({ isLoading: true });
        try {
          const updated = await userService.update(currentUser.id, data);
          set({ user: updated, isLoading: false });
        } catch (error) {
          set({ error: error.message, isLoading: false });
        }
      },
    }),
    {
      name: 'user-storage',
      storage: createJSONStorage(() => AsyncStorage),
    }
  )
);
```

### Offline-First with React Query

```typescript
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { persistQueryClient } from '@tanstack/react-query-persist-client';
import { createAsyncStoragePersister } from '@tanstack/query-async-storage-persister';
import AsyncStorage from '@react-native-async-storage/async-storage';
import NetInfo from '@react-native-community/netinfo';

// Setup persistence
const asyncStoragePersister = createAsyncStoragePersister({
  storage: AsyncStorage,
});

persistQueryClient({
  queryClient,
  persister: asyncStoragePersister,
});

// Custom hook for online status
export function useOnlineStatus() {
  const [isOnline, setIsOnline] = useState(true);

  useEffect(() => {
    return NetInfo.addEventListener(state => {
      setIsOnline(state.isConnected ?? false);
    });
  }, []);

  return isOnline;
}

// Offline-capable query
export function usePosts() {
  const isOnline = useOnlineStatus();

  return useQuery({
    queryKey: ['posts'],
    queryFn: fetchPosts,
    staleTime: 5 * 60 * 1000, // 5 minutes
    cacheTime: 24 * 60 * 60 * 1000, // 24 hours
    enabled: isOnline,
    refetchOnMount: isOnline,
  });
}

// Offline-capable mutation with queue
export function useCreatePost() {
  const queryClient = useQueryClient();
  const isOnline = useOnlineStatus();

  return useMutation({
    mutationFn: createPost,
    onMutate: async (newPost) => {
      // Cancel outgoing refetches
      await queryClient.cancelQueries({ queryKey: ['posts'] });

      // Snapshot previous value
      const previousPosts = queryClient.getQueryData(['posts']);

      // Optimistically update
      queryClient.setQueryData(['posts'], (old: any) => [...old, newPost]);

      return { previousPosts };
    },
    onError: (err, newPost, context) => {
      // Rollback on error
      queryClient.setQueryData(['posts'], context?.previousPosts);

      if (!isOnline) {
        // Queue for later
        queueMutation('createPost', newPost);
      }
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['posts'] });
    },
  });
}
```

## Flutter Patterns

### Project Structure
```
lib/
├── main.dart
├── app/
│   ├── routes.dart
│   └── theme.dart
├── features/
│   ├── auth/
│   │   ├── models/
│   │   ├── providers/
│   │   ├── screens/
│   │   └── widgets/
│   └── home/
├── core/
│   ├── services/
│   ├── utils/
│   └── constants/
└── shared/
    └── widgets/
```

### Navigation with GoRouter

```dart
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'profile/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return ProfileScreen(userId: id);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
  redirect: (context, state) {
    final isLoggedIn = authService.isAuthenticated;
    final isAuthRoute = state.matchedLocation.startsWith('/auth');

    if (!isLoggedIn && !isAuthRoute) {
      return '/auth/login';
    }
    if (isLoggedIn && isAuthRoute) {
      return '/';
    }
    return null;
  },
);

// Usage
void main() {
  runApp(MaterialApp.router(
    routerConfig: router,
  ));
}
```

### State Management with Riverpod

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Model
class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});
}

// Repository
class UserRepository {
  Future<User> getUser(String id) async {
    // API call
  }

  Future<User> updateUser(String id, Map<String, dynamic> data) async {
    // API call
  }
}

// Providers
final userRepositoryProvider = Provider((ref) => UserRepository());

final userProvider = FutureProvider.family<User, String>((ref, id) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getUser(id);
});

// Notifier for mutable state
class UserNotifier extends StateNotifier<AsyncValue<User>> {
  UserNotifier(this.repository) : super(const AsyncValue.loading());

  final UserRepository repository;

  Future<void> loadUser(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => repository.getUser(id));
  }

  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    state = await AsyncValue.guard(() => repository.updateUser(id, data));
  }
}

final userNotifierProvider = StateNotifierProvider<UserNotifier, AsyncValue<User>>((ref) {
  return UserNotifier(ref.watch(userRepositoryProvider));
});

// Usage in widget
class ProfileScreen extends ConsumerWidget {
  final String userId;

  const ProfileScreen({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider(userId));

    return userAsync.when(
      data: (user) => Text(user.name),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

### Offline-First with Drift (SQLite)

```dart
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

// Define tables
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get email => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Posts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get title => text()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// Database
@DriftDatabase(tables: [Users, Posts])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(path.join(dbFolder.path, 'app.db'));
      return NativeDatabase(file);
    });
  }

  // Queries
  Future<List<User>> getAllUsers() => select(users).get();

  Stream<List<User>> watchAllUsers() => select(users).watch();

  Future<User> getUserById(int id) =>
      (select(users)..where((u) => u.id.equals(id))).getSingle();

  Future<int> createUser(UsersCompanion user) => into(users).insert(user);

  Future<bool> updateUser(User user) => update(users).replace(user);

  Future<int> deleteUser(int id) =>
      (delete(users)..where((u) => u.id.equals(id))).go();
}

// Service with sync
class UserService {
  final AppDatabase db;
  final ApiClient api;

  UserService(this.db, this.api);

  Future<void> syncUsers() async {
    try {
      final remoteUsers = await api.fetchUsers();

      await db.transaction(() async {
        for (final user in remoteUsers) {
          await db.into(db.users).insertOnConflictUpdate(
            UsersCompanion(
              id: Value(user.id),
              name: Value(user.name),
              email: Value(user.email),
            ),
          );
        }
      });
    } catch (e) {
      print('Sync failed: $e');
    }
  }

  Stream<List<User>> watchUsers() {
    // Start sync in background
    syncUsers();
    // Return live data from local DB
    return db.watchAllUsers();
  }
}
```

## Performance Optimization

### React Native

```typescript
// Use React.memo for component optimization
export const UserCard = React.memo(({ user }: { user: User }) => {
  return (
    <View>
      <Text>{user.name}</Text>
    </View>
  );
});

// Use useMemo for expensive calculations
const sortedUsers = useMemo(() => {
  return users.sort((a, b) => a.name.localeCompare(b.name));
}, [users]);

// Use useCallback for function memoization
const handlePress = useCallback(() => {
  navigation.navigate('Details', { id: user.id });
}, [user.id]);

// FlatList optimization
<FlatList
  data={items}
  renderItem={({ item }) => <ItemCard item={item} />}
  keyExtractor={item => item.id}
  removeClippedSubviews={true}
  maxToRenderPerBatch={10}
  windowSize={21}
  getItemLayout={(data, index) => ({
    length: ITEM_HEIGHT,
    offset: ITEM_HEIGHT * index,
    index,
  })}
/>
```

### Flutter

```dart
// Use const constructors
const Text('Hello');

// ListView optimization
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ItemCard(item: items[index]);
  },
  cacheExtent: 100,
);

// Image caching
CachedNetworkImage(
  imageUrl: user.avatarUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
);
```

## Testing

### React Native Testing Library

```typescript
import { render, fireEvent, waitFor } from '@testing-library/react-native';

describe('LoginScreen', () => {
  it('should submit form with valid credentials', async () => {
    const mockLogin = jest.fn();
    const { getByPlaceholderText, getByText } = render(
      <LoginScreen onLogin={mockLogin} />
    );

    fireEvent.changeText(getByPlaceholderText('Email'), 'test@example.com');
    fireEvent.changeText(getByPlaceholderText('Password'), 'password123');
    fireEvent.press(getByText('Login'));

    await waitFor(() => {
      expect(mockLogin).toHaveBeenCalledWith('test@example.com', 'password123');
    });
  });
});
```

### Flutter Widget Tests

```dart
testWidgets('Counter increments', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());

  expect(find.text('0'), findsOneWidget);
  expect(find.text('1'), findsNothing);

  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();

  expect(find.text('0'), findsNothing);
  expect(find.text('1'), findsOneWidget);
});
```

## Best Practices

1. **Use TypeScript/Dart for type safety**
2. **Implement offline-first architecture**
3. **Optimize list rendering**
4. **Use memo/const for performance**
5. **Handle loading and error states**
6. **Implement proper navigation**
7. **Test on real devices**
8. **Monitor app performance**
9. **Handle permissions properly**
10. **Follow platform guidelines**
