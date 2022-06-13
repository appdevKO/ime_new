import 'dart:ui';

import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  var value = false;

  final Function(bool) onChanged;
  final double size;
  final Color color;

  CustomCheckBox(
      {required Key key,
      required this.size,
      required this.value,
      required this.onChanged,
      required this.color})
      : super(key: key);

  @override
  _CustomCheckBoxState createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    double iconsSize = widget.size ?? 16.0;
    double containerSize = iconsSize - 5.0;
    Color color = widget.color ?? Colors.white;
    return Center(
      child: GestureDetector(
          onTap: () {
            widget.value = !widget.value;
            widget.onChanged(widget.value);
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 1),
            child: widget.value
                ? Icon(
                    Icons.check_box_rounded,
                    size: iconsSize,
                    color: color,
                  )
                //flutter 沒有填滿的方形只能這樣
                : Stack(
                    children: [
                      Icon(
                        Icons.check_box_outline_blank,
                        size: iconsSize,
                        color: Colors.white,
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3.0)),
                              color: color,
                            ),
                            height: containerSize,
                            width: containerSize,
                          ),
                        ),
                      ),
                    ],
                  ),
          )),
    );
  }
}
