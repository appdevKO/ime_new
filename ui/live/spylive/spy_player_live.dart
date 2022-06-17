import 'package:flutter/material.dart';

class SpyPlayerLive extends StatefulWidget {
  const SpyPlayerLive({Key? key}) : super(key: key);

  @override
  State<SpyPlayerLive> createState() => _SpyPlayerLiveState();
}

class _SpyPlayerLiveState extends State<SpyPlayerLive> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Text('player live'),
        Container(
          height: MediaQuery.of(context).size.height - 10 - 240 ,
          child: ListView.builder(
            itemBuilder: (context, index) {
              return Container(
                color: Colors.red,
                child: Text('456'),
              );
            },
            itemCount: 5,
          ),
        )
      ],
    ));
  }
}
