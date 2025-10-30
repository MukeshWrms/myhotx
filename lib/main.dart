import 'package:flutter/material.dart';
import 'package:myhotx/ui/google_signin_screen.dart';

void main() {
  runApp(const MyHotXApp());
}

class MyHotXApp extends StatelessWidget {
  const MyHotXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyHotX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      home: const GoogleSignInScreen(),
    );
  }
}
