import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_recognizer_nd/providers/app_color_provider.dart';
import 'package:tiny_recognizer_nd/utils/app_color.dart';

final classProvider = StateNotifierProvider<ClassProviderController, AsyncValue<int>>((ref) => ClassProviderController(ref:ref));

class ClassProviderController extends StateNotifier<AsyncValue<int>>{
  StateNotifierProviderRef<ClassProviderController, AsyncValue<int>> ref;
  ClassProviderController({required this.ref}): super(const AsyncData(6));
  

  void setValue(int v){
    final appColor = ref.read(appColorProvider.notifier);
    state = AsyncData(v);
    switch(v){
      case 1: //Ayudar
        appColor.setColor(Color.fromARGB(255, 161, 110, 0));
        break;
      case 2: //Medico
        appColor.setColor(const Color.fromARGB(255, 15, 95, 160));
        break;
      case 3: //Peligroso
        appColor.setColor(Color.fromARGB(255, 129, 13, 5));
        break;
      case 4: //Policia
        appColor.setColor(const Color.fromARGB(255, 20, 105, 23));
        break;
      case 5: //Salir
        appColor.setColor(const Color.fromARGB(255, 87, 13, 100));
        break;
      case 6: //Sin Reconocer
        appColor.setColor(Color.fromARGB(255, 255, 255, 255));
        break;
    }
    
  }

  void setLoading(){
    state = AsyncLoading();
  }

}