import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
  theme: ThemeData(
    // brightness: Brightness.dark,
    primaryColor: Colors.blueGrey
  ),
  home: Scaffold(
    backgroundColor: Colors.blue,
    appBar: AppBar(
      shadowColor: Colors.teal,
      title: const Text('MaterialApp Theme'),
    ),
    body: Column(
      children: [

        Center(
          child: Text(
          'Hello, Flutter!',
          style: TextStyle(fontSize: 24, color: Colors.blueGrey),
                ),
        ),

        Center(
          child: Text(
          'Welcome to Flutter',
          style: TextStyle(fontSize: 24, color: Colors.white),
            ),
        ),


        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text('text1'),
          SizedBox(width: 20,),
          Text('text2'),
          SizedBox(width: 20,),
          Text('text3'),
        ],)


      ] 
  ),
)
    );




  }
}