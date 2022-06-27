import 'package:flutter/material.dart';

class StackText extends StatelessWidget {
  StackText({Key? key, required this.text, required this.size, this.style})
      : super(key: key);
  final String text;
  final double size;
  TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RichText(
          overflow: TextOverflow.ellipsis,
          strutStyle: StrutStyle(fontSize: 12.0),
          text: TextSpan(
              style: style != null
                  ? style
                  : TextStyle(
                      fontSize: size,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 1.0
                        ..color = Colors.black,
                    ),
              text: '$text'),
        ),
        RichText(
          overflow: TextOverflow.ellipsis,
          strutStyle: StrutStyle(fontSize: 12.0),
          text: TextSpan(
              style: TextStyle(fontSize: size, color: Colors.white),
              text: '$text'),
        ),
      ],
    );
  }
}
