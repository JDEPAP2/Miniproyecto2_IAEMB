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
        appColor.setColor(Colors.yellow);
        break;
      case 2: //Medico
        appColor.setColor(Colors.blue);
        break;
      case 3: //Peligroso
        appColor.setColor(Colors.red);
        break;
      case 4: //Policia
        appColor.setColor(Colors.green);
        break;
      case 5: //Salir
        appColor.setColor(Colors.purple);
        break;
      case 6: //Sin Reconocer
        appColor.setColor(Colors.white);
        break;
    }
    
  }

  void setLoading(){
    state = AsyncLoading();
  }

}