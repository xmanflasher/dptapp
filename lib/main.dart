import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'presentation/bloc/bloc.dart';
import 'presentation/pages/pages.dart';



void main() async {
  await Hive.initFlutter();
  await Hive.openBox('timerBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BluetoothBloc()),
        BlocProvider(create: (context) => TimerBloc()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
        routes: {
          '/record': (context) => const RecordPage(),
          '/receive': (context) => const ReceivePage(),
          '/settings': (context) => const SettingsPage(),
        },
      ),
    );
  }
}