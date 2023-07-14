import 'package:flutter/material.dart';
import 'package:meteo/widgets/custom_text.dart';

Future dialogAndroid(context,Function(String value) action) async{
  return showDialog(
    barrierDismissible: false,
    builder: (BuildContext buildContext){
      return SimpleDialog(
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.all(20.0),
        title: customText("Ajoutez une ville",fontSize: 22.0),
        children:  [
           TextField(
              keyboardType: TextInputType.name,
              autofocus: true,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                focusColor: Colors.black,
                hoverColor: Colors.black,
                labelText: "Ville",
                labelStyle: TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.none
                ),
                fillColor: Colors.white,
              ),
              onSubmitted: (String value) {
                action(value);
                Navigator.pop(buildContext);
              },
            ),
        ],
      );
    }, context: context
  );
}
