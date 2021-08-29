import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
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
  final sourceLocationController = TextEditingController();
  final destinationLocationController = TextEditingController();
  Position _currentPosition;
  String _currentAddress = 'Source Location';
  GoogleSignInAccount _googleUserInfo;

  PickResult selectedPlace;
  double _sourceLat = 23.7780984;
  double _sourceLng = 23.7780984;

  double _destinationLat = 90.3606115;
  double _destinationLng = 90.3606115;

  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _currentPosition1;

  @override
  void initState() {
    _getCurrentLocation();
    _currentPosition1 = CameraPosition(
      target: LatLng(_sourceLat, _sourceLng),
      zoom: 12,
    );
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
            body: AppsStatus.isLoggedIn
                ? Center(
                    child: Column(
                      children: [
                        /*  Image.network(
                          _googleUserInfo.photoUrl,
                          width: 200,
                          height: 200,
                        ),
                        Text('Name:' +
                            _googleUserInfo.displayName +
                            '\nMail :' +
                            _googleUserInfo.email),*/

                        //     _sourceDestinationInputText(),
                        _buildMapShowPicker(),
                      ],
                    ),
                  )
                : CircularProgressIndicator(
                    semanticsValue: 'Loading....',
                  )));
  }

  _userProfileUI() {}

  _buildMapShowPicker() {
    return Stack(
      children: [
        Container(
          height: 700,
          width: 400,
          child: GoogleMap(
            zoomControlsEnabled: false,
            initialCameraPosition: _currentPosition1,
            markers: {
              Marker(
                markerId: MarkerId('current'),
                position: LatLng(_sourceLat, _sourceLng),
              )
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),

        ///Source
        Positioned(
            left: 2,
            //top: 20,
            child: Container(
              width: 350,
              // height: 100,
              color: Colors.grey.shade50,
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: _currentAddress),
                controller: sourceLocationController,
              ),
            )),

        SizedBox(
          height: 5,
        ),

        ///Destination
        Positioned(
          left: 2,
          top: 80,
          child: selectedPlace == null
              ? Container(
                  color: Colors.grey.shade50,
                  width: 350,
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: TextField(
                    onTap: () {
                      print('Pick Up Destination Location ');
                      pickUpDestinationFromMap();
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Destination Location Here '),
                    controller: destinationLocationController,
                  ),
                )
              : Container(
                  width: 350,
                  color: Colors.grey.shade50,
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: TextField(
                    onTap: () {
                      pickUpDestinationFromMap();
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: selectedPlace.formattedAddress ?? ""),
                    //controller: destinationLocationController,
                  ),
                ),
        ),

        /// Button
        ///
        ElevatedButton(
            onPressed: () {
              _calDistanceSourceToDestination().then((value) {
                print('Distance' + value.toString());
              });
            },
            child: Text('Distance Add '))
      ],
    );
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

  Widget pickUpDestinationFromMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PlacePicker(
            apiKey: 'AIzaSyCXmFGriFOWjViwXVslmLQp0Vn09DmlEfs',
            // initialPosition: ,
            useCurrentLocation: true,
            selectInitialPosition: true,
            usePlaceDetailSearch: true,
            onPlacePicked: (result) {
              selectedPlace = result;

              _destinationLat = selectedPlace.geometry.location.lat;
              _destinationLng = selectedPlace.geometry.location.lng;

              print('Select Address : ' + selectedPlace.toString());
              print('lat :' + selectedPlace.geometry.location.lat.toString());
              print('lng :' + selectedPlace.geometry.location.lng.toString());

              Navigator.of(context).pop();
              setState(() {});
            },
          );
        },
      ),
    );
  }

  Future<double> _calDistanceSourceToDestination() async {
    return geolocator.distanceBetween(
        _sourceLat, _sourceLng, _destinationLat, _destinationLng);
  }
}
