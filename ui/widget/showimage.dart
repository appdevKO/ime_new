import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ShowImage extends StatelessWidget {
  ShowImage({Key? key, required this.img}) : super(key: key);
  String img;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: PhotoView(
                  imageProvider: NetworkImage(img),
                  enableRotation: false,
                  initialScale: PhotoViewComputedScale.contained),

              // decoration: BoxDecoration(
              //     image: DecorationImage(
              //         image: NetworkImage('$img'), fit: BoxFit.cover)),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  iconSize: 30,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.black,
                ),
                IconButton(
                  iconSize: 26,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}