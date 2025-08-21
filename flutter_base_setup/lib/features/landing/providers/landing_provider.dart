import 'package:flutter_riverpod/flutter_riverpod.dart';

// final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

final bottomNavIndexProvider = StateProvider<int>((ref) {
  return 0;
});


// we will do : 


// to read the current index from the provider

// var index = ref.watch(bottomNavIndexProvider);

// or

// ref.watch(bottomNavIndexProvider.notifier).state = newIndex;

// to change the state of the provider

// it holds a single integer value 
// representing currently selected bottom navigation index.
// so whenever the index changes, the app will rebuild with the new index.

