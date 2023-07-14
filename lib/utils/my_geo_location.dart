import 'dart:async';

import 'package:geocode/geocode.dart';
import 'package:location/location.dart';

late bool _serviceEnabled;
late  PermissionStatus _permissionGranted;
late LocationData _locationData;
late Stream<LocationData> stream;
//once
getFirstLocation(location)async{
  _serviceEnabled=await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }
  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }
  try{
     _locationData=await location.getLocation()  ;
    print("new location ${_locationData.latitude} / ${_locationData.longitude}");
    (_locationData.latitude,_locationData.longitude);
  }catch(e) {
    Future.error(e);
  }
}

Future<String> coordinateToLocation({required double? latitude,required double? longitude}) async {
  if (latitude == null || longitude == null) return "";
  GeoCode geoCode = GeoCode();
  Address address =
  await geoCode.reverseGeocoding(latitude: latitude, longitude: longitude);
  return Future.value("${address.city}, ${address.region}");
}

Future<Coordinates> locationToCoordinates(String city) async {
    GeoCode geoCode = GeoCode();
    Coordinates coordinates = await geoCode.forwardGeocoding(address: city);
    return coordinates;
}




