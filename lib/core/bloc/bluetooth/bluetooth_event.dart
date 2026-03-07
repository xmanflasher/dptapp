part of 'bluetooth_bloc.dart';

abstract class BluetoothEvent extends Equatable {
  const BluetoothEvent();

  @override
  List<Object> get props => [];
}

class StartScan extends BluetoothEvent {}

class DeviceConnected extends BluetoothEvent {
  final String deviceName;

  const DeviceConnected(this.deviceName);

  @override
  List<Object> get props => [deviceName];
}

class DataReceived extends BluetoothEvent {
  final String data;

  const DataReceived(this.data);

  @override
  List<Object> get props => [data];
}

class TurnOnBluetooth extends BluetoothEvent {}

class TurnOffBluetooth extends BluetoothEvent {}

class CheckBluetoothStatus extends BluetoothEvent {}