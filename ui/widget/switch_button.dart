import 'package:flutter/material.dart';

class SwitchButton extends StatelessWidget {
  bool freeswitch = true;
  String text1;
  String text2;
  Function func; //設定價錢的function
  double price1; //價錢1
  double price2; //價錢2
  var aaa;

  SwitchButton(
      {Key? key,
      required this.freeswitch,
      required this.text1,
      required this.text2,
      required this.func,
      required this.aaa,
      required this.price1,
      required this.price2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        freeswitch == true
            ? Row(
                children: [
                  FullCircle(
                    bigradius: 20,
                    smallradius: 10,
                    width: 2,
                    thecolor: Colors.purple,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 20),
                    child: Text(
                      '$text1',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              )
            : GestureDetector(
                child: Row(
                  children: [
                    EmptyCircle(
                      radius: 20,
                      thecolor: Colors.orange,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 20),
                      child: Text(
                        '$text1',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  func(price1, price2);
                },
              ),
        freeswitch == true
            ? GestureDetector(
                child: Row(
                  children: [
                    EmptyCircle(
                      radius: 20,
                      thecolor: Colors.yellow,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        '$text2',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
                onTap: () {
                  func(price1, price2);
                },
              )
            : Row(
                children: [
                  FullCircle(
                    bigradius: 20,
                    smallradius: 10,
                    width: 2,
                    thecolor: Colors.tealAccent,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      '$text2',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              )
      ],
    );
  }
}

class FullCircle extends StatelessWidget {
  double bigradius;
  double smallradius;
  Color thecolor;
  double width;

  FullCircle(
      {Key? key,
      required this.bigradius,
      required this.smallradius,
      required this.thecolor,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: bigradius,
      width: bigradius,
      child: Center(
        child: Stack(alignment: Alignment.center,
          children: [
            Container(
              height: bigradius-2,
              width: bigradius-2,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(width: width, color: thecolor)),
            ),
            Container(
              height: smallradius-2,
              width: smallradius-2,
              decoration: BoxDecoration(shape: BoxShape.circle, color: thecolor),
            )
          ],
        ),
      ),
    );
  }
}

class EmptyCircle extends StatelessWidget {
  Color thecolor;
  double radius;

  EmptyCircle({Key? key, required this.thecolor, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius,
      width: radius,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(width: 2, color: thecolor)),
    );
  }
}
