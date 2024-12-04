import 'package:flutter/material.dart';
import 'Views/mobile/protrait/Home.dart';
// import 'package:device_preview/device_preview.dart';

void main() {
  // runApp(
  //     DevicePreview(
  //       builder: (context)=> const MyApp()
  //     )
  // );
  runApp(
   const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

