
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customText(String data,{color=Colors.black,fontSize=18.0,fontStyle=FontStyle.normal,fontWeight=FontWeight.normal}){
  if(Platform.isIOS){
    return DefaultTextStyle(
        style: GoogleFonts.merriweather(
            fontSize: fontSize,
            fontWeight:fontWeight,
            fontStyle: fontStyle,
            color: color
        ),
        textAlign: TextAlign.center,
        child: Text(data)
    );
  }else{
    return Text(data,
        textAlign: TextAlign.center,
        style: GoogleFonts.merriweather(
            fontSize: fontSize,
            fontWeight:fontWeight,
            fontStyle: fontStyle,
            color: color
        )
    );
  }
}