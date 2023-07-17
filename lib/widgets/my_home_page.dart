import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:meteo/my_flutter_app_icons.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:geocode/geocode.dart';
import 'package:location/location.dart';
import 'package:meteo/models/temperature.dart';
import 'package:meteo/utils/my_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meteo/utils/image_assets.dart';
import 'package:meteo/utils/my_geo_location.dart';
import 'package:meteo/utils/my_key.dart';
import 'package:meteo/widgets/dialog_android.dart';
import 'package:meteo/widgets/custom_text.dart';
import 'package:meteo/widgets/my_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Location location;
  late List<String> villes = [];
  String key = "villes";
  String villeChoisie = "";
  late LocationData locationData;
  String nameCurrent="Ville actuelle";
  var  position;
  late Coordinates cityCordsChosen=Coordinates(latitude: null, longitude: null);

 // List<Map<String,dynamic>> weather=[];
  Map <String ,dynamic>m={ "main": "", "description": "clear sky", "icon": ""};

Temperature temperature=Temperature( {
  "weather":[
    {
      "main": "",
      "description": "",
      "icon": ""
    }
  ],
    "main"
          : {
        "temp": 305.04,
        "temp_min": 0.0,
        "temp_max": 0.0,
        "pressure": 0,
        "humidity": 0
        }
  });


@override
void initState() {
  super.initState();
  obtenir();
  Location location = Location();
  try {
    position = location.getLocation() ;
  } on PlatformException catch (e) {
    Future.error(e);
  }
  listenToStream(location, position);
  getTemperature(cityCordsChosen);
}

String adress = "";
//Each Change
void listenToStream(Location location, locationData) {
  stream = location.onLocationChanged;
  stream.listen((newPosition) {
    //print("new ${newPosition.latitude} ---- ${newPosition.longitude}");
    setState(() {
      locationData = newPosition;
      Future.value(coordinateToLocation(
          latitude: newPosition.latitude,
          longitude: newPosition.longitude))
          .then((value) => adress=value);
      //print(adress);
      MyApi().getTemperature(
        // locationData,
          Coordinates(
            longitude: newPosition.longitude,
            latitude: newPosition.latitude,
          ) ,
          context
      );
    });
  });
}

void coordinatesFromCity(){
  if(villeChoisie != "") {
    locationToCoordinates(villeChoisie).then((value) =>cityCordsChosen=value);
    print("fu $cityCordsChosen");
  }
}

@override
Widget build(BuildContext context) {

  return GestureDetector(
    onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
    child: (Platform.isIOS)
        ? CupertinoPageScaffold(
        navigationBar: (CupertinoNavigationBar(
          backgroundColor: beige,
          middle: customText(widget.title),
        )),
        child: body())
        : Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: Container(
              color: grey,
              child: ListView.builder(
                  itemCount: villes.length + 2,
                  itemBuilder: (context, int i) {
                    if (i == 0) {
                      return DrawerHeader(
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: [
                            customText(
                              "Mes villes",
                              fontSize: 22.0,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  if (Platform.isIOS) {
                                    showCupertinoDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Column(
                                            children: [
                                              customText(
                                                  "Ajoutez une ville"),
                                              CupertinoTextField(
                                                onSubmitted:
                                                    (String value) {
                                                  addCity(value);
                                                },
                                                placeholder: "Ville",
                                                style: GoogleFonts
                                                    .merriweather(),
                                              ),
                                              CupertinoButton(
                                                  child: customText(
                                                      "Ajouté"),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop();
                                                  })
                                            ],
                                          );
                                        });
                                  } else {
                                    dialogAndroid(context,
                                            (value) => addCity(value));
                                  }
                                },
                                style: const ButtonStyle(
                                  backgroundColor:
                                  MaterialStatePropertyAll(
                                      Colors.white),
                                  elevation:
                                  MaterialStatePropertyAll(10.0),
                                ),
                                child: customText("Ajoutez une ville"))
                          ],
                        ),
                      );
                    } else if (i == 1) {
                      return ListTile(
                        title: customText(nameCurrent),
                        onTap: () {
                          setState(() {
                            villeChoisie = "";
                            cityCordsChosen=Coordinates(longitude: null,latitude:null);
                            getTemperature(cityCordsChosen);
                            Navigator.pop(context);
                          });
                        },
                      );
                    } else {
                      String ville = villes[i - 2];
                      return ListTile(
                        title: customText(ville),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            deleteCity(ville);
                          },
                          color: Colors.white,
                        ),
                        onTap: () {
                          setState(() {
                            villeChoisie = ville;
                            Navigator.pop(context);
                            getTemperature(cityCordsChosen);
                            coordinatesFromCity();
                          });
                        },
                      );
                    }
                  })),
        ),

        body:(temperature.main == "")
            ? emptyCity(): body()
    ),
  );
}
Widget emptyCity(){
  return Center(
    child: customText(
      (villeChoisie == ""  ) ? nameCurrent: villeChoisie,
    ),
  );
}
Widget body() {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    decoration:  BoxDecoration(
        image: DecorationImage(
            image:getBackground(),
            fit: BoxFit.cover
        ),

    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:<Widget> [
        customText(
          (villeChoisie == "") ? nameCurrent : villeChoisie,
          fontSize: 40.0,
          fontStyle: FontStyle.italic,
          color:  Colors.white
        ),
        customText(
            temperature.description,
            fontSize: 30.0,
            color:  Colors.white
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
           // Image(image: getIcon()),
            Image.network("https://openweathermap.org/img/wn/${temperature.icon.toString()}@2x.png"),
            customText(
                "${temperature.temp.toInt()}ºC",
                fontSize: 49.0,
                color:  Colors.white
            ),
          ],

        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            extra(
                "${temperature.tempMin.toInt() }ºC",
                MyFlutterApp.long_arrow_alt_down
            ),
            extra(
                "${temperature.tempMax.toInt()}ºC",
                MyFlutterApp.long_arrow_alt_up
            ),
            extra(
                "${temperature.pressure}",
                MyFlutterApp.thermometer
            ),
            extra(
                "${temperature.humidity}%",
                MyFlutterApp.droplet
            ),

          ],
        )
      ],
    ),
  );
}

void obtenir() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  List<String>? maListe = sharedPreferences.getStringList(key);
  if (maListe != null) {
    setState(() {
      villes = maListe;
    });
  }
}

AssetImage getIcon(){
  String icon= temperature.icon.replaceAll("d", "").replaceAll("n", "");
  return AssetImage("images/$icon.png");
}
  void addCity(String value) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  villes.add(value);
  await sharedPreferences.setStringList(key, villes);
  obtenir();
}

  void deleteCity(String str) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  villes.remove(str);
  preferences.setStringList(key, villes);
  obtenir();
}

  AssetImage getBackground(){
  if (temperature.icon.contains("n")){
    print(Future.value(temperature.icon));
    return ImageAsset().night;
  }else {
    if( temperature.icon.contains("01") || temperature.icon.contains("02") || temperature.icon.contains("03")){
      return ImageAsset().sun;
    }else{
      return ImageAsset().rain;
    }
  }
}
  Future<Temperature?> getTemperature (Coordinates coordinatesCity)async {
  double? lat;
  double? long;
  if (coordinatesCity != Coordinates(latitude: 0.0, longitude: 0.0)) {
    lat = coordinatesCity.latitude;
    long = coordinatesCity.longitude;
  } else
  if (locationData.longitude != null && locationData.latitude != null) {
    lat = locationData.latitude;
    long = locationData.longitude;
  }
  if (lat != null && long != null) {
    const String theKey = "&appid=${MyKey.key}";
    String lang = "&lang=${
        Localizations
            .localeOf(context)
            .languageCode
    }";
    const String baseAPI = "https://api.openweathermap.org/data/2.5/weather?";
    String coordsString = "lat=$lat&lon=$long";
    String units = "&units=metric";
    String totalString = baseAPI + coordsString + theKey + units ;
    final url = Uri.tryParse(totalString);
    try {
      var client = http.Client();
      final response = await client.get(url!);
      if (response.statusCode == 200) {
        var _data = response.body;
        Map<String, dynamic> data = jsonDecode(_data);
        print(temperature.icon);
        setState(() {
          temperature=Temperature(data);
        });
      } else if (response.statusCode == 401) {
        Future.error("Unauthorized  request bro code :${response.statusCode}");
      } else if (response.statusCode == 500) {
        Future.error("Error server  code :${response.statusCode}");
      } else {
        Future.error("bad request bro code :${response.statusCode}");
        return null;
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  return temperature;
}
  Column extra(String data,IconData iconData){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(iconData,color: Colors.white,size: 30.0,),
        customText(data,color: Colors.white,fontSize: 23.5)
      ],
    );
  }
}
