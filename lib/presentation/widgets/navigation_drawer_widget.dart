import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/bluetooth/bluetooth_bloc.dart';

class NavigationDrawerWidget extends StatefulWidget {
  @override
  _NavigationDrawerWidgetState createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  @override
  void initState() {
    super.initState();
    context.read<BluetoothBloc>().add(CheckBluetoothStatus());
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ExpansionTile(
            title: const Text('Settings'),
            children: [
              BlocBuilder<BluetoothBloc, BluetoothState>(
                builder: (context, state) {
                  bool isBluetoothOn = false;
                  if (state is BluetoothOn) {
                    isBluetoothOn = true;
                  } else if (state is BluetoothOff) {
                    isBluetoothOn = false;
                  }

                  return ListTile(
                    title: Text('Bluetooth : ${isBluetoothOn ? "On" : "Off"}'),
                    trailing: Switch(
                      value: isBluetoothOn,
                      onChanged: (value) {
                        if (value) {
                          context.read<BluetoothBloc>().add(TurnOnBluetooth());
                        } else {
                          context.read<BluetoothBloc>().add(TurnOffBluetooth());
                        }
                      },
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Devices : 0'),
                onTap: () {
                  context.go('/settings/devices');
                },
              ),
              ListTile(
                title: const Text('Setting Page'),
                onTap: () {
                  context.go('/settings');
                },
              ),
            ],
          ),
          ListTile(
            title: const Text('Activities'),
            onTap: () {
              context.go('/activities');
            },
          ),
          ListTile(
            title: const Text('Detail'),
            onTap: () {
              context.go('/detail/${DateTime.now()}');
            },
          ),
          ListTile(
            title: const Text('Syncrecording'),
            onTap: () {
              context.go('/syncrecording');
            },
          ),
        ],
      ),
    );
  }
}