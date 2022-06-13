import 'package:flutter/material.dart';

class UpGradeVIP extends StatefulWidget {
  const UpGradeVIP({Key? key}) : super(key: key);

  @override
  _UpGradeVIPState createState() => _UpGradeVIPState();
}

class _UpGradeVIPState extends State<UpGradeVIP> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //appbar
              Container(
                height: 56,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    Center(
                        child: Text(
                      '升級VIP',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )),
                    IconButton(
                      icon: Icon(
                        Icons.settings,
                        color: Colors.transparent,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              //圖1
              Center(
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 60,
                ),
              ),

              //項目
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    //title
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        '一般VIP',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('1.額外獲得500 i幣'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('2.解鎖聊天室所有功能'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('3.解鎖揪團咖所有功能'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('4.解鎖動態發布留言'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('5.解鎖真心話大冒險所有功能'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('6.'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('7.'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('8.'),
                    ),
                  ],
                ),
              ),

              //解鎖按鈕1
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Center(
                  child: Container(
                    height: 50,
                    width: 260,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.king_bed,
                          color: Colors.yellow,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            '每月 \$500',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              //圖2
              Padding(
                padding: const EdgeInsets.only(top:20.0),
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 60,
                  ),
                ),
              ),
              //項目
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    //title
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        '尊榮VIP',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('1.額外獲得500 i幣'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('2.解鎖聊天室所有功能'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('3.解鎖揪團咖所有功能'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('4.解鎖動態發布留言'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('5.解鎖真心話大冒險所有功能'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('6.'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('7.'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('8.'),
                    ),
                  ],
                ),
              ),

              //解鎖按鈕2
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Center(
                  child: Container(
                    height: 50,
                    width: 260,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.king_bed,
                          color: Colors.yellow,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            '每月 \$1300',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
