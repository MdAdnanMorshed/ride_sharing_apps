
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ride_sharing_apps/home.dart';

import 'common_widgets/GoogleSignInButtonWidget.dart';
import 'helper/status.dart';

class GoogleSignInPage extends StatefulWidget {
  @override
  _GoogleSignInPageState createState() => _GoogleSignInPageState();
}

class _GoogleSignInPageState extends State<GoogleSignInPage> {


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
                 AppsStatus.isLoggedIn=true;
                 _userObj = userData;
                 print('************************************');
                print('_userObj mail Info : '+_userObj.toString());
                Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => HomePage(),
                       settings: RouteSettings(
                         arguments: _userObj,
                       ),
                   ),
                 );
               });
             }).catchError((e) {
              print(e);
             });


           },
         ),
       ),
     )
    );
  }
}
