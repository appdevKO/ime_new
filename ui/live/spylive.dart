import 'package:flutter/material.dart';
import 'package:ime_new/ui/widget/stack_text.dart';

class SpyLivePage extends StatefulWidget {
  const SpyLivePage({Key? key}) : super(key: key);

  @override
  State<SpyLivePage> createState() => _SpyLivePageState();
}

class _SpyLivePageState extends State<SpyLivePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0, mainAxisSpacing: 10.0,
          childAspectRatio: 1, //子元素在横轴长度和主轴长度的比例
        ),
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        image: AssetImage('assets/default/sex_woman.png')),
                    border: Border.all(
                        color: Colors.pink.withOpacity(.5), width: 1)),
              ),
              Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    height: 20,
                    width: 70,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.5),
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 10,
                            color: Colors.red,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text(
                              '36,112',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              //資料
              Positioned(
                  bottom: 10,
                  left: 10,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.pink,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StackText(
                              text: 'Lady GAGA',
                              size: 12,
                            ),
                            StackText(
                              text: '今天晚上直播',
                              size: 12,
                            ),
                          ],
                        ),
                      )
                    ],
                  ))
            ],
          );
        },
        itemCount: 11,
      ),
    );
  }
}
