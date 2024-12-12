import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/widgets.dart';
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  /*
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: const Text('Home'),
      ),
      
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go('/record');
          },
          child: const Text('testing'),
        ),
      ),
    );
  }
}