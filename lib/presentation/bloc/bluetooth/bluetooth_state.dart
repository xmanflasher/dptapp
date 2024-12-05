part of 'bluetooth_bloc.dart';

abstract class BluetoothState extends Equatable {
  const BluetoothState();

  @override
  List<Object> get props => [];
}

class BluetoothInitial extends BluetoothState {}

class BluetoothScanning extends BluetoothState {}

class BluetoothConnected extends BluetoothState {
  final String deviceName;

  const BluetoothConnected(this.deviceName);

  @override
  List<Object> get props => [deviceName];
}

class BluetoothDataReceived extends BluetoothState {
  final String data;

  const BluetoothDataReceived(this.data);

  @override
  List<Object> get props => [data];
}

class BluetoothOn extends BluetoothState {}

class BluetoothOff extends BluetoothState {}