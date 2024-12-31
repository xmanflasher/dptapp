import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class MyBluetoothService {
  final FlutterBluePlus _flutterBlue = FlutterBluePlus();

  void startScan(void Function(BluetoothDevice) onDeviceFound) {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (r.device.platformName.contains('Garmin')) {
          FlutterBluePlus.stopScan();
          onDeviceFound(r.device);
        }
      }
    });
  }

  void connectToDevice(BluetoothDevice device, void Function(List<int>) onDataReceived) async {
    await device.connect();
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        await characteristic.setNotifyValue(true);
        characteristic.lastValueStream.listen((value) {
          onDataReceived(value);
        });
      }
    }
  }

  void turnOnBluetooth() {
    // Implement turning on Bluetooth if needed
  }

  void turnOffBluetooth() {
    // Implement turning off Bluetooth if needed
  }
}