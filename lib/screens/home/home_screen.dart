import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_recognizer_nd/providers/app_color_provider.dart';
import 'package:tiny_recognizer_nd/providers/bluetooth_provider.dart';
import 'package:tiny_recognizer_nd/screens/class/class_screen.dart';
import 'package:tiny_recognizer_nd/utils/app_color.dart';
// import 'package:shop_app/providers/providers.dart';
// import 'package:shop_app/components/init_app_bar.dart';
// import 'package:shop_app/utils/app_color.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  static String routeName = "home/";

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {

  String namePlataform(String name){
    if (name.isEmpty) {
     return "Sin Nombre"; 
    } else {
      if (name.length > 15) {
        return name.substring(0,15) + "...";
      } else {
        return name;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final blueProvider = ref.watch(bluetoothProvider);
    final deviceblueProvider = ref.watch(bluetoothDeviceProvider);
    AppColor appColor = ref.watch(appColorProvider);
    return ListView(
      children: [
        Container(
      padding: EdgeInsets.all(10),
      child: ExpansionTile(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        initiallyExpanded: true,
        childrenPadding: EdgeInsets.zero,
        expandedAlignment: Alignment.topCenter,
        title: Text("Dispositivos", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
      children: [
        Container(
          height: 300,
      padding: EdgeInsets.all(10),
      child: blueProvider.when(
      data: (data) => ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) => Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black.withOpacity(0.05)
          ),
          child: Row(
            children: [
              IntrinsicHeight(
                child: Column(
                  children: [
                    Expanded(child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(Icons.circle, color: data[index].device.isConnected?Colors.green:Colors.red,),
                        SizedBox(width: 10),
                        Text(namePlataform(data[index].device.platformName),
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                        ]
                      )),
                      Text(data[index].device.remoteId.str.replaceAll(" ", "")),
                    ],
                  )
                ),
                Spacer(),
                SizedBox(width: 10),
                InkWell(
                  child: Container(
                  padding: EdgeInsets.all(10),
                  child: deviceblueProvider.when(
                    data: (v) => Text(data[index].device.isConnected?"Deconectar":"Conectar", style: TextStyle(color: Colors.white)), 
                    error: (error, stackTrace) => Text("Error"), loading: () => Center(child: CircularProgressIndicator(color: Colors.white))), decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12))),
                  onTap: (){
                     ref.watch(bluetoothDeviceProvider.notifier).handleConnection(data[index].device);
                  },)
              ]),
            ), 
            separatorBuilder: (context, index) => SizedBox(height: 5), 
            itemCount: data.length), 
            error: (error, stackTrace) => SizedBox.shrink(), 
            loading: () => Text("Cargando"))),
            Text("Presiona Buscar si no encuentras tu dispositivo", style: TextStyle(color: Colors.grey),),
            TextButton(onPressed: () => ref.read(bluetoothProvider.notifier).scanDevices(), child: Text("Buscar", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
            )
            )
      ],
    ),
    ),
    SizedBox(height: 200),
    Center(
        child: deviceblueProvider.value != null?InkWell(
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black
          ),
          child: Text("Probar", style: TextStyle(color: Colors.white,
          fontWeight: FontWeight.bold, fontSize: 20),)),
        onTap: (){
          Navigator.of(context).pushNamed(ClassScreen.routeName);
        },
      ):SizedBox.shrink(),
      )
      ],
    );
  }
}
