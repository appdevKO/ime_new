import 'package:flutter/material.dart';
import 'package:ime_new/ui/live/spylive/contract/signingpage.dart';
import 'package:ime_new/utils/color_config.dart';
import 'package:signature/signature.dart';

class BecomeSpy extends StatefulWidget {
  const BecomeSpy({Key? key}) : super(key: key);

  @override
  State<BecomeSpy> createState() => _BecomeSpyState();
}

class _BecomeSpyState extends State<BecomeSpy> {
  bool checkvalue = false;
  late SignatureController signatureController;

  @override
  void initState() {
    signatureController = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('成為特務'),
          backgroundColor: Color(0xff1A1A1A),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            color: Color(0xff1A1A1A),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 3,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Color(0xff336666),
                      Color(0xff9900cc),
                    ])),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, right: 15, left: 15),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            '任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範'
                            '任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範'
                            '任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範'
                            '任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範'
                            '任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範'
                            '任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範'
                            '任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範'
                            '任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範'
                            '任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範',
                            style: TextStyle(color: Color(0xff808080)),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Transform.scale(
                                  scale: 1.5,
                                  child: Checkbox(
                                    value: checkvalue,
                                    onChanged: (value) {
                                      setState(() {
                                        checkvalue = value!;
                                      });
                                    },
                                    activeColor: spy_gradient_light_purple,
                                    side: BorderSide(color: Color(0xff808080)),
                                  ),
                                ),
                                Text(
                                  '我已閱讀並同意以上規範',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                  ),
                                )
                              ],
                            )),
                        Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '證件正面',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            height: 280,
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text(
                                '點擊上傳證件正面圖檔',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  width: 1, color: Color(0xff808080)),
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '證件背面',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            height: 280,
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text(
                                '點擊上傳證件背面圖檔',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  width: 1, color: Color(0xff808080)),
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '存摺封面',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            height: 280,
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text(
                                '點擊上傳存摺封面圖檔',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  width: 1, color: Color(0xff808080)),
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '以下為審核等候時間說明',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )),
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              '審核等候時間說明審核等候時間說明審核等候時間說明審核等候時間說明審核等候時間說明'
                              '審核等候時間說明審核等候時間說明審核等候時間說明審核等候時間說明審核等候時間說明'
                              '審核等候時間說明審核等候時間說明審核等候時間說明審核等候時間說明審核等候時間說明'
                              '審核等候時間說明審核等候時間說明審核等候時間說明審核等候時間說明審核等候時間說明'
                              '審核等候時間說明審核等候時間說明審核等候時間說明審核等候時間說明審核等候時間說明'
                              '審核等候時間說明審核等候時間說明審核等候時間說明審核等候時間說明審核等候時間說明',
                              style: TextStyle(color: Color(0xff808080)),
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '若同意上述條款及說明，請在下方簽名欄中簽名',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20),
                            )),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                                color: Color(0xFFEEEEEE),
                                border: Border.all(
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(15)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Signature(
                                controller: signatureController,
                                backgroundColor: Colors.white,
                                height: 150,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 18.0, right: 30, left: 30),
                          child: GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    spy_gradient_light_purple,
                                    spy_gradient_light_blue,
                                  ]),
                                  borderRadius: BorderRadius.circular(30)),
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 38,
                                  ),
                                  Text(
                                    '點我上傳申請',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Container(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
