import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1️⃣ Notifier for a number
class NumberNotifier extends StateNotifier<int> {
  NumberNotifier() : super(1); // initial value = 1


  void doubleState()
  {
    state *= 2;
  }

  void reset() {
  state = 1; // reset back to initial value
}




}

// 2️⃣ Provider
final numberProvider = StateNotifierProvider<NumberNotifier, int>(
  (ref) => NumberNotifier(),
);


// Now i am Adding a color changing system and a button 


class ColorNotifier extends StateNotifier<Color> {
  ColorNotifier() : super(Colors.red); // initial color

  void switchColor() {
    if (state == Colors.red) {
      state = Colors.blue; // switch to blue
    } else {
      state = Colors.red; // switch back to red
    }
  }
}

final colorProvider = StateNotifierProvider<ColorNotifier, Color>(
  (ref) => ColorNotifier(),
);











void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: NumberScreen(),
    );
  }
}

class NumberScreen extends ConsumerWidget {
  const NumberScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final number = ref.watch(numberProvider); // read state

    final Tcolor = ref.watch(colorProvider); // read color state

    return Scaffold(
      appBar: AppBar(title: Text("Number")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$number", // display current number
              style: TextStyle(fontSize: 48, color: Tcolor),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: (){
                ref.read(colorProvider.notifier).switchColor();
              }
              , child: Text("SwitchColor"),
              
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: (){
                  ref.read(numberProvider.notifier).doubleState();
                },
                child: Text("DoubleValue"),
                
                ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  ref.read(numberProvider.notifier).reset();
                  },
                  child: Text("Reset"),
                  ),


          ],
        ),
      ),
    );
  }
}
