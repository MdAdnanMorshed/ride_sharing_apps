import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ride_sharing_apps/helper/status.dart';

import 'google_sign_in_page.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleSignIn _googleSignIn = GoogleSignIn();

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  final myController = TextEditingController();
  Position _currentPosition;
  String _currentAddress;

    GoogleSignInAccount _googleUserInfo;


  @override
  void initState() {
    // TODO: implement initState
    print('_HomePageState.initState'+ 'Current Location');
    _getCurrentLocation();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     _googleUserInfo = ModalRoute.of(context).settings.arguments;

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text('Home'),
              actions: [
                InkWell(
                    onTap: () {
                      print('LogOut ');
                      _googleSignIn.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GoogleSignInPage()),
                      );
                    },
                    child: Center(child: Text('LogOut')))
              ],
            ),
            body:
            AppsStatus.isLoggedIn?
            Center(
              child: Column(
                children: [

                  Image.network(
                   _googleUserInfo.photoUrl,
                   width: 200,
                   height: 200,

                 ),
                  Text('Name:' +
                      _googleUserInfo.displayName +
                      '\nMail :' +
                      _googleUserInfo.email),

                  TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: _currentAddress
                    ),
                    controller: myController,
                  ),

                ],
              ),
            ):CircularProgressIndicator(semanticsValue: 'Loading....',)
        ));
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        print("CurrentPosition :");
        print(_currentPosition);
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
        "${place.name}, ${place.subLocality}, ${place.postalCode},${place.country}}";
        print('address :');
        print(_currentAddress);
      });
    } catch (e) {
      print(e);
    }
  }
}

/*
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Retrieve Text Input',
      home: MyCustomForm(),
    );
  }
}

// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds data related to the Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    myController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    myController.dispose();
    super.dispose();
  }

  void _printLatestValue() {
    print('Second text field: ${myController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Retrieve Text Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (text) {
                print('First text field: $text');
              },
            ),
            TextField(
              controller: myController,
            ),
          ],
        ),
      ),
    );
  }
}
 */