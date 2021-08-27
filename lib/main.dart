import 'package:flutter/material.dart';
import 'package:ride_sharing_apps/helper/status.dart';
import 'package:ride_sharing_apps/home.dart';

import 'google_sign_in_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ride Sharing Apps ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
      AppsStatus.isLoggedIn?HomePage(): GoogleSignInPage(),
    );
  }
}

