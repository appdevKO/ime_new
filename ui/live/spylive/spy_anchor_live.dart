import 'package:flutter/material.dart';
class SpyAnchorLive extends StatefulWidget {
  const SpyAnchorLive({Key? key}) : super(key: key);

  @override
  State<SpyAnchorLive> createState() => _SpyAnchorLiveState();
}

class _SpyAnchorLiveState extends State<SpyAnchorLive> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text('anchor live'),);
  }
}
