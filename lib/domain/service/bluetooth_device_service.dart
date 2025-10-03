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

  void connectToDevice(
      BluetoothDevice device, void Function(List<int>) onDataReceived) async {
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
  bool isBluetoothOn() {
    // Implement the logic to check if Bluetooth is on
    return true; // Placeholder return value
  }
}

/*
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothService {
  static final FlutterBluePlus _flutterBlue = FlutterBluePlus();

  // 檢查藍牙是否開啟
  static Future<bool> isBluetoothOn() async {
    return await FlutterBluePlus.adapterState.first == BluetoothAdapterState.on;
  }

  // 切換藍牙開關（僅適用於 Android，iOS 需要用戶手動開啟藍牙）
  static Future<void> toggleBluetooth(bool enable) async {
    if (enable) {
      await FlutterBluePlus.turnOn();
    } else {
      // Handle turning off Bluetooth manually as turnOff is deprecated
      // Note: There is no direct replacement for turnOff in Android SDK 33
      // You may need to guide the user to turn off Bluetooth manually
      print('Please turn off Bluetooth manually.');
    }
  }
}
*/
