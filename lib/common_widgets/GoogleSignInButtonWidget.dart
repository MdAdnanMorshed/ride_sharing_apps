import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class GoogleSignInButtonWidget extends StatelessWidget {
  final String title;
  final Function onPressed;

  const GoogleSignInButtonWidget(
      {Key key, @required this.title, @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 20.0,
            top: 15.0,
            bottom: 15.0,
            child: Image.asset(
              'assets/images/google_logo.png',
            ),
          ),
          OutlineButton(
            onPressed: onPressed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            focusColor: Colors.green,
            color: Colors.teal,
            borderSide: BorderSide(
              color: Colors.teal,
            ),
            highlightedBorderColor: Colors.teal,
            child: Center(
              child: Text(
                title,
                style: TextStyle(fontSize: 20,color: Colors.teal,fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
