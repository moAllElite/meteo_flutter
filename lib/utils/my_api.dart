import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:geocode/geocode.dart';
import 'package:location/location.dart';
import 'package:meteo/utils/my_key.dart';

class Api{

   myApi (LocationData locationData, Coordinates coordinatesCity,context)async{
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
      const String baseAPI="https://api.openweathermap.org/data/2.5/weather?";
      String coordsString="lat=$lat&lon=$long";
      String units="&units==metrics";
      String bo=coordsString + theKey +units;
      String totalString = baseAPI + coordsString  + theKey  ;
      final url = Uri.tryParse(totalString);
      try{
        var client = http.Client();
        final response= await client.get(url!);
        if ( response.statusCode == 200 ){
         var repApi=response.body;
        var _data=jsonDecode(repApi);
         print(_data);
        }else if( response.statusCode == 401 ){
          print("Unauthorized  request bro code :${response.statusCode}");
        }else if( response.statusCode == 500 ){
          print("Error server  code :${response.statusCode}");
        } else {
          print("bad request bro code :${response.statusCode}");
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }
}