import 'package:flutter/material.dart';

class StackText extends StatefulWidget {
  const StackText({Key? key, required this.text, required this.size})
      : super(key: key);
  final String text;
  final double size;

  @override
  _StackTextState createState() => _StackTextState();
}

class _StackTextState extends State<StackText> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          '${widget.text}',
          style: TextStyle(
            fontSize: widget.size,
            foreground: Paint()
              ..style = PaintingStyle.stroke
                ..strokeWidth = 1.0
              ..color = Colors.black,
          ),
        ),
        Text(
          '${widget.text}',
          style: TextStyle(fontSize: widget.size, color: Colors.white),
        )
      ],
    );
  }
}
