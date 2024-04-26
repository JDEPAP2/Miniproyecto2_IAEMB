import 'dart:async';
import 'dart:developer';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_recognizer_nd/providers/class_provider.dart';
import 'package:tiny_recognizer_nd/utils/bluetooth.dart';

final bluetoothProvider = StateNotifierProvider<BluetoothController, AsyncValue<List<ScanResult>>>((ref) => BluetoothController(ref: ref));

class BluetoothController extends StateNotifier<AsyncValue<List<ScanResult>>>{
  StateNotifierProviderRef<BluetoothController, AsyncValue<List<ScanResult>>> ref;
  BluetoothController({required this.ref}): super(const AsyncData([])){
    FlutterBluePlus.onScanResults.listen((event) => getAllDevices(event));
    scanDevices();
  }
  // FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

  Future<void> scanDevices() async {
    state = AsyncLoading();
    // await FlutterBluePlus.stopScan();
    await FlutterBluePlus.startScan(
      androidScanMode: AndroidScanMode.lowLatency,
      timeout: const Duration(seconds: 5));
  }
  

  Future<void> getAllDevices(List<ScanResult> results) async {
    state = AsyncData(results);
  }
}


final bluetoothDeviceProvider = StateNotifierProvider<BluetoothDeviceController, AsyncValue<BluetoothDevice?>>((ref) => BluetoothDeviceController(ref: ref));

class BluetoothDeviceController extends StateNotifier<AsyncValue<BluetoothDevice?>>{
  StateNotifierProviderRef<BluetoothDeviceController, AsyncValue<BluetoothDevice?>> ref;
  BluetoothDeviceController({required this.ref}): super(const AsyncData(null));
  Timer? _discoveryTimer;
  // FlutterBlue flutterBlue = FlutterBlue.instance;

  Future<void> updateProviders() async {
    // await ref.read(recordsPersonControllerProvider.notifier).getAllRecords();
    // await ref.read(recordsGroupControllerProvider.notifier).getAllRecords();
  }

  Future<void> handleConnection(BluetoothDevice device) async{
    state = const AsyncLoading();
    if(device.isConnected){
      await device.disconnect();
      state = AsyncData(null);
    }else{
      await device.connect();
    if((await FlutterBluePlus.connectedDevices).contains(device)){
      state = AsyncData(device);
    }else{
      state = AsyncData(null);}
    }
  }

  void stopRead(){
    _discoveryTimer?.cancel();
  }


  Future<void> readCharacteristcs() async{
    _discoveryTimer = Timer.periodic(Duration(seconds: 5), (Timer t) async {
    if(state.hasValue){
      var device = state.value;
      ref.read(classProvider.notifier).setLoading();
      if(device != null){
        try {
          List<BluetoothService> services = await device.discoverServices();
        services.forEach((service) async {
            var chars = service.characteristics;
            for (var char in chars) {
               if (char.uuid.toString().toUpperCase().contains("2A57")){
                var value = await char.read();
                log(value.toString());
                ref.read(classProvider.notifier).setValue(value.first);
               }
            }
        });
        } catch (e) {
          await device.disconnect();
          state = AsyncData(null);
        }
      }
  }});
  }
}