import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/service/bluetooth_device_service.dart';
import 'package:equatable/equatable.dart';

part 'bluetooth_event.dart';
part 'bluetooth_state.dart';

class BluetoothBloc extends Bloc<BluetoothEvent, BluetoothState> {
  final MyBluetoothService _bluetoothService = MyBluetoothService();

  BluetoothBloc() : super(BluetoothInitial()) {
    on<StartScan>((event, emit) async {
      emit(BluetoothScanning());
      _bluetoothService.startScan((device) {
        add(DeviceConnected(device.name));
        _bluetoothService.connectToDevice(device, (data) {
          add(DataReceived(data.toString()));
        });
      });
    });

    on<DeviceConnected>((event, emit) {
      emit(BluetoothConnected(event.deviceName));
    });

    on<DataReceived>((event, emit) {
      emit(BluetoothDataReceived(event.data));
    });

    on<TurnOnBluetooth>((event, emit) {
      _bluetoothService.turnOnBluetooth();
      emit(BluetoothOn());
    });

    on<TurnOffBluetooth>((event, emit) {
      _bluetoothService.turnOffBluetooth();
      emit(BluetoothOff());
    });

    on<CheckBluetoothStatus>((event, emit) {
      if (_bluetoothService.isBluetoothOn()) {
        emit(BluetoothOn());
      } else {
        emit(BluetoothOff());
      }
    });
  }
}