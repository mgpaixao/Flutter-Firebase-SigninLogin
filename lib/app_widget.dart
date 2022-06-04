import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aula4/splash/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';

class AppWidget extends StatefulWidget {
  AppWidget({Key? key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  void initState() {
    Firebase.initializeApp();
    super.initState();
  }

  final Future<FirebaseApp> app = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
          future: app,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return SplashPage();
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
