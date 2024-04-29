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
    if(state.hasValue){
      var device = state.value;
      if(device != null){
        try {
          List<BluetoothService> services = await device.discoverServices();
          final service = services.where((service) => service.serviceUuid == Guid('180A')).toList();
          if (service.isNotEmpty) {
            final characteristic = service.first.characteristics.where((charc) => charc.characteristicUuid == Guid('2A57'));
            if (characteristic.isNotEmpty) {
              var value = await characteristic.first.read();
              ref.read(classProvider.notifier).setValue(value.first);
              ref.read(bluetoothStateProvider.notifier).state = false;
            }
          }
        } catch (e) {
          await device.disconnect();
          state = AsyncData(null);
        }
      }
    }
  }

  Future<void> writeCharacteristcs() async{
    if(state.hasValue){
      var device = state.value;
      ref.read(bluetoothStateProvider.notifier).state = true;
      ref.read(classProvider.notifier).setLoading();
      if(device != null){
        try {
          List<BluetoothService> services = await device.discoverServices();
          final service = services.where((service) => service.serviceUuid == Guid('180A')).toList();
          if (service.isNotEmpty) {
            final characteristic = service.first.characteristics.where((charc) => charc.characteristicUuid == Guid('2A58'));
            if (characteristic.isNotEmpty) {
              await characteristic.first.write([1]);
              await Future.delayed(Duration(seconds: 5));
              await readCharacteristcs();
              await characteristic.first.write([0]);
            }
          }
        } catch (e) {
          await device.disconnect();
          state = AsyncData(null);
        }
      }
  }
  }
}

final bluetoothStateProvider = StateProvider<bool>((ref) => false);