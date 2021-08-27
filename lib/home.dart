
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatelessWidget {

  GoogleSignInAccount _googleUserInfo;

  HomePage(this._googleUserInfo);

  @override
  Widget build(BuildContext context) {
    return Container(child: Text('Name:'),);
  }
}
