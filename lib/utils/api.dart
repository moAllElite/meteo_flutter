import 'package:geocode/geocode.dart';
import 'package:location/location.dart';
import 'package:meteo/utils/my_key.dart';

class Api{
  myApi({required Coordinates coordinatesCity,required LocationData locationData}){
    double?  lat;
    double? long;
    if (coordinatesCity != Coordinates(latitude: 0.0,longitude: 0.0)){
      lat=coordinatesCity.latitude;
      long=coordinatesCity.longitude;
    }else if(locationData.longitude != null &&  locationData.latitude != null){
        lat=locationData.latitude;
        long=locationData.longitude;
    }
    if( lat !=null && long != null){
      MyKey.key;
    }
  }
}