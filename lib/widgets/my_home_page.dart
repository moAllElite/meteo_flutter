import 'dart:io';
import 'package:flutter/services.dart';
import 'package:geocode/geocode.dart';
import 'package:location/location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meteo/utils/my_geo_location.dart';
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
  var position;
  late Coordinates cityCordsChosen=Coordinates(latitude: null, longitude: null);
  @override
  void initState() {
    super.initState();
    obtenir();
    Location location = Location();
    try {
      position = location.getLocation();
    } on PlatformException catch (e) {
      print("Erreur: $e");
    }
    listenToStream(location, position);
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
                backgroundColor: lightGrey,
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
                              title: customText("Ma ville actuelle"),
                              onTap: () {
                                setState(() {
                                  villeChoisie = "";
                                  cityCordsChosen=Coordinates(longitude: null,latitude:null);
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
                                  coordinatesFromCity();
                                  Navigator.pop(context);
                                });
                              },
                            );
                          }
                        })),
              ),
              body:
                  body() // This trailing comma makes auto-formatting nicer for build methods.
              ),
    );
  }

  Widget body() {
    return Center(
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/back.png"), fit: BoxFit.cover)),
        child: Center(
          child: customText(
            (villeChoisie == "") ? "ville actuelle" : villeChoisie,
          ),
        ),
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

}
