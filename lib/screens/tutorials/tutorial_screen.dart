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
  final colors = [Colors.amber, Colors.blue, Colors.red, Colors.green, Colors.purple];
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

  List<Widget> getWidgets(BuildContext context){
    final width = MediaQuery.sizeOf(context).width;
    final res = <Widget>[];
    for (var i = 0; i < 5; i++) {
      res.add(Container(
        decoration: BoxDecoration(
          color: i == 0?Colors.transparent:colors[i-1]
        ),
        child: Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top:Radius.circular(100)),
              color: colors[i],
            ),
            child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(names[i][0].toUpperCase()+names[i].substring(1,names[i].length), style: TextStyle(color: Colors.white,
                          fontWeight: FontWeight.bold, fontSize: 25)),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: Row(children: [
                      IconButton(onPressed: () async{
                        if(_playerState[i] == PlayerState.playing){
                          pause(i);
                        }else{
                          play(i);
                        }
                      }, icon: Icon(_playerState[i] == PlayerState.playing? Icons.pause_rounded:Icons.play_arrow_rounded, color: Colors.white,size: 30,)),
                      Expanded(child: Slider(
                        activeColor:  Color.alphaBlend(colors[i].withOpacity(0.5), Colors.white),
                        onChanged: (value) {
                          final duration = _duration[i];
                          if (duration == null) {
                            return;
                          }
                          final position = value * duration.inMilliseconds;
                          player[i].seek(Duration(milliseconds: position.round()));
                          setState(() {
                          _position[i] = Duration(milliseconds: position.round());
                          });
                        },
                        value: (_position[i] != null &&
                                _duration[i] != null &&
                                _position[i]!.inMilliseconds > 0 &&
                                _position[i]!.inMilliseconds < _duration[i]!.inMilliseconds)
                            ? _position[i]!.inMilliseconds / _duration[i]!.inMilliseconds
                            : 0.0,
                      ))
                    ])),      
                  ]),
            width: width,
        ))));
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: _position.length == 5 ?ListView(
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              SizedBox(height: 50),
              Container(
                child: Column(
                  children: [
                    Text("Géneros Musicales", style: TextStyle(color: Colors.black,
                      fontWeight: FontWeight.bold, fontSize: 30)),
                      Text("Aquí podrás encontrar algunos de los generos reconocidos por la app"),],
                      )
                  ),
            ],
          ),
        ),
        SizedBox(height: 50),  
        ListView(
          shrinkWrap: true,
          children: getWidgets(context),
        )
      ],
    ):SizedBox());
  }
}
