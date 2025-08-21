import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1️⃣ Create Notifier class
class UsernameNotifier extends StateNotifier<String> {
  UsernameNotifier() : super("Guest"); // initial value = "Guest"

  void changeName(String newName) {
    state = newName; // update state with new string
  }
}

// 2️⃣ Create Provider for this Notifier
final usernameProvider = StateNotifierProvider<UsernameNotifier, String>(
  (ref) => UsernameNotifier(),
);

// 3️⃣ Main entry point
void main() {
  runApp(
    ProviderScope( // 👈 Required for Riverpod
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: UsernameScreen(),
    );
  }
}

// 4️⃣ Screen that uses the provider
class UsernameScreen extends ConsumerWidget {
  const UsernameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final username = ref.watch(usernameProvider); // read state

    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Hello, $username!",
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Change username
                ref.read(usernameProvider.notifier).changeName("John Doe");
              },
              child: Text("Set Username to John Doe"),
            ),
          ],
        ),
      ),
    );
  }
}
