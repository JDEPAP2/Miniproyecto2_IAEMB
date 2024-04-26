import 'package:flutter/material.dart';
class AppColor{

  Color primary = Colors.black;
  Color secondary = Colors.black;
  Color light = Color.fromARGB(255, 255, 255, 255);
  Color dark = Colors.black;
  Color black = Colors.black;
  Color white = Colors.white;
  LinearGradient gradient = const LinearGradient(colors: [Colors.black, Colors.black]);
  LinearGradient navGradient = const LinearGradient(colors: [Colors.black, Colors.black]);
  BoxShadow shadow = const BoxShadow();

  AppColor(Color color){

    primary = color;
    secondary = Color.fromRGBO((color.red*.85).round(), (color.green*.85).round(), (color.blue*.85).round(), 1.0);
    light = Color.fromRGBO((color.red + (255 - color.red) * .1).round(), (color.green + (255 - color.green) * .1).round(), (color.blue + (255 - color.blue) * .1).round(), 1.0);
    dark = Color.fromRGBO((color.red*.7).round(), (color.green*.7).round(), (color.blue*.7).round(), 1.0);
    black = Color.fromRGBO((color.red*.4).round(), (color.green*.4).round(), (color.blue*.4).round(), 1.0);
    white = Color.fromRGBO((color.red + (255 - color.red) * .7).round(), (color.green + (255 - color.green) * .7).round(), (color.blue + (255 - color.blue) * .7).round(), 1.0);
    gradient = LinearGradient(
    colors: [light,primary,black], 
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter
    );
    navGradient = LinearGradient(
    colors: [primary,secondary], 
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter
    );

    shadow = BoxShadow(
      color: black.withOpacity(0.2),
      blurRadius: 5,
      spreadRadius: 2,
      offset: const Offset(3,5)
    );
  }


  Color getContrastColor({Color? color}) {
    double luminance = color?.computeLuminance() ?? primary.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  Color getOwnContrastColor({Color? color}) {
    double luminance = color?.computeLuminance() ?? primary.computeLuminance();
    return luminance > 0.5 ? black : white;
  }

}
