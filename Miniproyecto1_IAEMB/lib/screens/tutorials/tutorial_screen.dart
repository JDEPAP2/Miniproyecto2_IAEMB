import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_recognizer_nd/providers/app_color_provider.dart';
import 'package:tiny_recognizer_nd/providers/bluetooth_provider.dart';
import 'package:tiny_recognizer_nd/screens/class/class_screen.dart';
import 'package:tiny_recognizer_nd/utils/app_color.dart';
import 'package:url_launcher/url_launcher_string.dart';
// import 'package:shop_app/providers/providers.dart';
// import 'package:shop_app/components/init_app_bar.dart';
// import 'package:shop_app/utils/app_color.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class TutorialScreen extends ConsumerStatefulWidget {
  const TutorialScreen({super.key});

  static String routeName = "tutorial/";

  @override
  TutorialScreenState createState() => TutorialScreenState();
}

class TutorialScreenState extends ConsumerState<TutorialScreen> {

  final names = ["jazz", "pop", "rock", "salsa", "tecno"];
  late List<AudioPlayer> player = [];
  List<PlayerState?> _playerState = [];
  List<Duration?> _duration = [];
  List<Duration?> _position = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 5; i++) {
      final p = AudioPlayer();
      p.setReleaseMode(ReleaseMode.stop);
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await p.setSource(AssetSource('sounds/${names[i]}.mp3'));
        // await player.pause();
        _playerState.add(p.state);
        _duration.add(await p.getDuration());
        _position.add(await p.getCurrentPosition());
        setState(() {});
      });
      player.add(p);
    }
  }

    @override
  void dispose() {
    // Release all sources and dispose the player.
    player.forEach((e) => e.dispose());
    _duration.clear();
    _position.clear();
    _playerState.clear();
    player.clear();
    super.dispose();
  }

  Future<void> play(i) async{
    player.forEach((element) => element.pause());
    await player[i].resume();
    setState(() => _playerState[i] = PlayerState.playing);
  }

  Future<void> pause(i) async{
    await player[i].pause();
    setState(() => _playerState[i] = PlayerState.paused);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(15),
      child: IntrinsicHeight(
      child: _position.length == 5 ?Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Géneros Musicales", style: TextStyle(color: Colors.black,
          fontWeight: FontWeight.bold, fontSize: 30)),
        Text("Aquí podrás encontrar algunos de los generos reconocidos por la app"),
        SizedBox(height: 20),


        Text("Jazz ", style: TextStyle(color: const Color.fromARGB(255, 156, 143, 27),
              fontWeight: FontWeight.bold, fontSize: 25)),
        SizedBox(height: 10,),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 204, 184, 4),
            borderRadius: BorderRadius.circular(20)
          ),
          child: Row(children: [
          IconButton(onPressed: () async{
            if(_playerState[0] == PlayerState.playing){
              pause(0);
            }else{
              play(0);
            }
          }, icon: Icon(_playerState[0] == PlayerState.playing? Icons.pause:Icons.play_arrow, color: Colors.white,)),
          Expanded(child: Slider(
            activeColor: Colors.white,
            onChanged: (value) {
              final duration = _duration[0];
              if (duration == null) {
                return;
              }
              final position = value * duration.inMilliseconds;
              player[0].seek(Duration(milliseconds: position.round()));
              setState(() {
              _position[0] = Duration(milliseconds: position.round());
              });
            },
            value: (_position[0] != null &&
                    _duration[0] != null &&
                    _position[0]!.inMilliseconds > 0 &&
                    _position[0]!.inMilliseconds < _duration[0]!.inMilliseconds)
                ? _position[0]!.inMilliseconds / _duration[0]!.inMilliseconds
                : 0.0,
          ))
        ]),
        ),
        SizedBox(height: 20,),
        Text("Pop ", style: TextStyle(color: Colors.blue,
              fontWeight: FontWeight.bold, fontSize: 25)),
        SizedBox(height: 10,),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 18, 97, 161),
            borderRadius: BorderRadius.circular(20)
          ),
          child: Row(children: [
          IconButton(onPressed: () async{
            if(_playerState[1] == PlayerState.playing){
              pause(1);
            }else{
              play(1);
            }
          }, icon: Icon(_playerState[1] == PlayerState.playing? Icons.pause:Icons.play_arrow, color: Colors.white,)),
          Expanded(child: Slider(
            activeColor: Colors.white,
            onChanged: (value) {
              final duration = _duration[1];
              if (duration == null) {
                return;
              }
              final position = value * duration.inMilliseconds;
              player[1].seek(Duration(milliseconds: position.round()));
              setState(() {
              _position[1] = Duration(milliseconds: position.round());
              });
            },
            value: (_position[1] != null &&
                    _duration[1] != null &&
                    _position[1]!.inMilliseconds > 0 &&
                    _position[1]!.inMilliseconds < _duration[1]!.inMilliseconds)
                ? _position[1]!.inMilliseconds / _duration[1]!.inMilliseconds
                : 0.0,
          ))
        ]),
        ),
        SizedBox(height: 20,),
        Text("Rock", style: TextStyle(color: Colors.red,
              fontWeight: FontWeight.bold, fontSize: 25)),
        SizedBox(height: 10,),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 170, 38, 29),
            borderRadius: BorderRadius.circular(20)
          ),
          child: Row(children: [
          IconButton(onPressed: () async{
            if(_playerState[2] == PlayerState.playing){
              pause(2);
            }else{
              play(2);
            }
          }, icon: Icon(_playerState[2] == PlayerState.playing? Icons.pause:Icons.play_arrow, color: Colors.white,)),
          Expanded(child: Slider(
            activeColor: Colors.white,
            onChanged: (value) {
              final duration = _duration[2];
              if (duration == null) {
                return;
              }
              final position = value * duration.inMilliseconds;
              player[2].seek(Duration(milliseconds: position.round()));
              setState(() {
              _position[2] = Duration(milliseconds: position.round());
              });
            },
            value: (_position[2] != null &&
                    _duration[2] != null &&
                    _position[2]!.inMilliseconds > 0 &&
                    _position[2]!.inMilliseconds < _duration[2]!.inMilliseconds)
                ? _position[2]!.inMilliseconds / _duration[2]!.inMilliseconds
                : 0.0,
          ))
        ]),
        ),
        SizedBox(height: 20,),
        Text("Salsa ", style: TextStyle(color: Colors.green,
              fontWeight: FontWeight.bold, fontSize: 25)),
        SizedBox(height: 10,),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 39, 110, 41),
            borderRadius: BorderRadius.circular(20)
          ),
          child: Row(children: [
          IconButton(onPressed: () async{
            if(_playerState[3] == PlayerState.playing){
              pause(3);
            }else{
              play(3);
            }
          }, icon: Icon(_playerState[3] == PlayerState.playing? Icons.pause:Icons.play_arrow, color: Colors.white,)),
          Expanded(child: Slider(
            activeColor: Colors.white,
            onChanged: (value) {
              final duration = _duration[3];
              if (duration == null) {
                return;
              }
              final position = value * duration.inMilliseconds;
              player[3].seek(Duration(milliseconds: position.round()));
              setState(() {
              _position[3] = Duration(milliseconds: position.round());
              });
            },
            value: (_position[3] != null &&
                    _duration[3] != null &&
                    _position[3]!.inMilliseconds > 0 &&
                    _position[3]!.inMilliseconds < _duration[3]!.inMilliseconds)
                ? _position[3]!.inMilliseconds / _duration[3]!.inMilliseconds
                : 0.0,
          ))
        ]),
        ),
        SizedBox(height: 20,),
        Text("Tecno ", style: TextStyle(color: Colors.purple,
              fontWeight: FontWeight.bold, fontSize: 25)),
        SizedBox(height: 10,),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 89, 18, 102),
            borderRadius: BorderRadius.circular(20)
          ),
          child: Row(children: [
          IconButton(onPressed: () async{
            if(_playerState[4] == PlayerState.playing){
              pause(4);
            }else{
              play(4);
            }
          }, icon: Icon(_playerState[4] == PlayerState.playing? Icons.pause:Icons.play_arrow, color: Colors.white,)),
          Expanded(child: Slider(
            activeColor: Colors.white,
            onChanged: (value) {
              final duration = _duration[4];
              if (duration == null) {
                return;
              }
              final position = value * duration.inMilliseconds;
              player[4].seek(Duration(milliseconds: position.round()));
              setState(() {
              _position[4] = Duration(milliseconds: position.round());
              });
            },
            value: (_position[4] != null &&
                    _duration[4] != null &&
                    _position[4]!.inMilliseconds > 0 &&
                    _position[4]!.inMilliseconds < _duration[4]!.inMilliseconds)
                ? _position[4]!.inMilliseconds / _duration[4]!.inMilliseconds
                : 0.0,
          ))
        ]),
        ),
      ],
    ):SizedBox()));
  }
}
