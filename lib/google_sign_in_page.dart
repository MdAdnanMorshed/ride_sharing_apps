
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ride_sharing_apps/home.dart';

import 'common_widgets/GoogleSignInButtonWidget.dart';

class GoogleSignInPage extends StatefulWidget {
  @override
  _GoogleSignInPageState createState() => _GoogleSignInPageState();
}

class _GoogleSignInPageState extends State<GoogleSignInPage> {
  bool _isLoggedIn = false;

  GoogleSignInAccount _userObj;

  GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
     Scaffold(
       body: Center(
         child: GoogleSignInButtonWidget(
           title: 'Sign in with Google',
           onPressed: () {
             print('Google Sign In');
             _googleSignIn.signIn().then((userData) {
               setState(() {
                 _isLoggedIn = true;
                 _userObj = userData;
                 print('************************************');
                print('_userObj mail Info : '+_userObj.toString());
               });
             }).catchError((e) {
               print('*----------------------------------------------------');
              print(e);
             });

             /* Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage(_userObj)),
              );*/
           },
         ),
       ),
     )
    );
  }
}
