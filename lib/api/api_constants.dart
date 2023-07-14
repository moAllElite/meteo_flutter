import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:location/location.dart';
import 'package:meteo/utils/my_key.dart';

class ApiConstants {
  static const String baseScheme = 'https://';
  static const String baseUrlDomain = 'api.openweathermap.org';
  static const String imagesPath = "/img/w/";
  static const String imagesUrl = baseScheme + baseUrlDomain + imagesPath;
  static const String weatherPath = "/data/2.5/weather";
  static const String forecastPath = "/data/2.5/forecast";
  static const String apiId = MyKey.key;
  Future<void> myApi (LocationData locationData, Coordinates coordinatesCity,context)async{
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
      const String theKey= "&appid=${MyKey.key}";
      String lang= "&lang=${
          Localizations.localeOf(context).languageCode
      }";
      const String baseAPI="api.openweathermap.org/data/2.5/weather?";
      String coordsString="lat=$lat&long=$long";
      String units="&units==metrics";
      String bo=coordsString + theKey +units;
      //String totalString = baseAPI + coordsString  + theKey + units ;
      String way=baseUrlDomain + weatherPath + coordsString +apiId +units;
    }
  }
}