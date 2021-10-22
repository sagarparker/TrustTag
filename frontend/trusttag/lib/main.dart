import 'package:flutter/material.dart';
import 'package:trusttag/ScanQrCodeScreen.dart';
import 'package:trusttag/TrustHistoryScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.orange,
      ),
      home: ScanQrCodeScreen(),
      routes: {TrustHistoryScreen.routeName: (ctx) => TrustHistoryScreen()},
    );
  }
}
