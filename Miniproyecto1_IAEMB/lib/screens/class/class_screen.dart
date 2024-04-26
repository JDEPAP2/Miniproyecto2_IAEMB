import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_recognizer_nd/providers/app_color_provider.dart';
import 'package:tiny_recognizer_nd/providers/bluetooth_provider.dart';
import 'package:tiny_recognizer_nd/providers/class_provider.dart';
import 'package:tiny_recognizer_nd/utils/app_color.dart';
// import 'package:shop_app/providers/providers.dart';
// import 'package:shop_app/components/init_app_bar.dart';
// import 'package:shop_app/utils/app_color.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class ClassScreen extends ConsumerStatefulWidget {
  const ClassScreen({super.key});

  static String routeName = "class/";

  @override
  ClassScreenState createState() => ClassScreenState();
}

class ClassScreenState extends ConsumerState<ClassScreen> {

  AudioPlayer? player;
  PlayerState playerState = PlayerState.paused;

  setPlayer(name) async{
    player?.dispose();
    player = AudioPlayer();
    player?.setReleaseMode(ReleaseMode.stop);
    await player?.setSource(AssetSource('sounds/${name}.mp3'));
    playerState = PlayerState.playing;
    player?.resume();
    setState(() {
    });
  }
  
  @override
  void initState() {
    super.initState();
  }

  String getName(int v){
    switch(v){
      case 1:
        setPlayer("jazz");
        return "Jazz";
      case 2:
        setPlayer("pop");
        return "Pop";
      case 3:
        setPlayer("rock");
        return "Rock";
      case 4:
        setPlayer("salsa");
        return "Salsa";
      case 5:
        setPlayer("tecno");
        return "Tecno";
      default:
        if(player != null){
          player?.pause();
          player?.dispose();
          player = null;
          setState(() {
          });
        }
        return "Sin Reconocer";
    }
  }

  IconData getIcon(int v){
    switch(v){
      case 1:
        return Icons.piano;
      case 2:
        return Icons.star;
      case 3:
        return Icons.speaker;
      case 4:
        return Icons.audiotrack;
      case 5:
        return Icons.disc_full;
      default:
        return Icons.help_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final classProv = ref.watch(classProvider);
    AppColor appColor = ref.watch(appColorProvider);
    return Scaffold(
      // backgroundColor: appColor.primary,
      body: Container(
        decoration: BoxDecoration(
          gradient: appColor.gradient
        ),
        child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(classProv.when(data: (data) => getName(data), error: (error, stackTrace) => "Error", loading: ()=>"Cargando"),
            style: TextStyle(color: appColor.getContrastColor(), fontSize: 40, fontWeight: FontWeight.bold))
          ),
          SizedBox(height: 10),
          Center(
            child: classProv.when(data: (data) => Icon(getIcon(data),
            color: appColor.getContrastColor(),
            size: 120),error: (error, stackTrace) => SizedBox.shrink(),
            loading: () => CircularProgressIndicator(color: appColor.getContrastColor())),
          ),
          SizedBox(height: 200),
          player != null?Center(
            child: IconButton(onPressed: () async{
              if(playerState == PlayerState.playing){
                player?.pause();
              }else{
                player?.resume();
              }
          }, icon: Icon(playerState == PlayerState.playing? Icons.pause:Icons.play_arrow, color: Colors.white,)),
          ):SizedBox.shrink(),
          Center(
            child: InkWell(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: appColor.getContrastColor()
                ),
                child: Text("Volver", style: TextStyle(color: appColor.secondary, fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              onTap: (){
                ref.read(bluetoothDeviceProvider.notifier).stopRead();
                Navigator.of(context).maybePop();
              },
            ),
          )
        ],
      ),
      ),
      ),
    );
  }
}
