import 'package:flutter/material.dart';

class StartStream extends StatefulWidget {
  const StartStream({Key? key}) : super(key: key);

  @override
  State<StartStream> createState() => _StartStreamState();
}

class _StartStreamState extends State<StartStream> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Text('甜心開播'),
        ),
      ),
    );
  }
}
