import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/loginpage/waitingpage.dart';
import 'package:provider/provider.dart';
import '../indexpage2.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/default/landing3.jpg',
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * .1,
              right: MediaQuery.of(context).size.width * .5 - 110,
              child: Container(
                child: Column(
                  children: [
                    Container(
                      width: 220,
                      child: SignInButton(
                        Buttons.Google,
                        text: "Google 登入",
                        onPressed: () async {
                          var result = await signInWithGoogle();
                          if (result is UserCredential) {
                            print('是');
                            print('google user :${result.user?.uid}');
                            //跳轉
                            await Provider.of<ChatProvider>(context,
                                    listen: false)
                                .register(result.user)
                                .whenComplete(() =>

                                    // Navigator.pushAndRemoveUntil(
                                    //     context,
                                    //     MaterialPageRoute(builder: (context) => IndexPage2()),
                                    //     (route) => route == null)
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                WaitingPage()),
                                        (route) => route == null));
                          } else
                            print('不是');
                        },
                      ),
                    ),
                    Container(
                      height: 20,
                    ),

                    Container(
                      width: 220,
                      child: SignInButton(
                        Buttons.Facebook,
                        text: "Facebook 登入",
                        mini: false,
                        onPressed: () async {
                          var result = await signInWithFacebook();
                          if (result is UserCredential) {
                            print('是');
                            print('facebook user :${result.user?.uid}');
                            //跳轉
                            await Provider.of<ChatProvider>(context,
                                    listen: false)
                                .register(result.user)
                                .whenComplete(() =>
                                    Future.delayed(Duration(seconds: 2), () {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  IndexPage2()),
                                          (route) => route == null);
                                    }));
                          } else
                            print('不是');
                        },
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     Text('facebook 登入'),
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 8.0),
                    //       child: ElevatedButton(
                    //           onPressed: () async {
                    //             var result = await signInWithFacebook();
                    //             if (result is UserCredential) {
                    //               print('是');
                    //               print('facebook user :${result.user?.uid}');
                    //               //跳轉
                    //               await Provider.of<ChatProvider>(context,
                    //                       listen: false)
                    //                   .register(result.user)
                    //                   .whenComplete(() => Navigator.pushAndRemoveUntil(
                    //                       context,
                    //                       MaterialPageRoute(
                    //                           builder: (context) => HomePage()),
                    //                       (route) => route == null));
                    //             } else
                    //               print('不是');
                    //           },
                    //           child: Text('facebook 登入')),
                    //     )
                    //   ],
                    // ),
                    // Row(
                    //   children: [
                    //     Text('facebook 登出'),
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 8.0),
                    //       child: ElevatedButton(
                    //           onPressed: () {
                    //             // FirebaseAuth.instance.signOut();
                    //             FacebookAuth.instance.logOut();
                    //           },
                    //           child: Text('faccebook 登出')),
                    //     )
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();
    print(
        'login result token ${loginResult.accessToken} ${loginResult.message}');
    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }
}

//登入 商標 動畫 廣告
class LeadPage extends StatefulWidget {
  const LeadPage({Key? key}) : super(key: key);

  @override
  State<LeadPage> createState() => _LeadPageState();
}

class _LeadPageState extends State<LeadPage> {
  late PageController _pageController;
  late StreamSubscription<User?> user;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        Future(() {
          Provider.of<ChatProvider>(context, listen: false)
              .set_accountid(user.uid);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => WaitingPage()));
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    user.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: [
        Lead1(
          pageController: _pageController,
        ),
        Lead2(
          pageController: _pageController,
        ),
        Lead3(
          pageController: _pageController,
        ),
      ],
    );
  }
}

class Lead1 extends StatelessWidget {
  Lead1({Key? key, required this.pageController}) : super(key: key);
  PageController pageController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/default/landing1.jpg',
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            bottom: 10,
            right: 15,
            child: GestureDetector(
              child: Text(
                '繼續',
                style: TextStyle(fontSize: 26, color: Colors.white),
              ),
              onTap: () {
                pageController.animateToPage(1,
                    duration: Duration(seconds: 1), curve: Curves.ease);
              },
            ),
          ),
        ],
      )),
    );
  }
}

class Lead2 extends StatelessWidget {
  Lead2({Key? key, required this.pageController}) : super(key: key);
  PageController pageController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/default/landing2.jpg',
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            bottom: 10,
            right: 15,
            child: GestureDetector(
              child: Text(
                '繼續',
                style: TextStyle(fontSize: 26, color: Colors.white),
              ),
              onTap: () {
                pageController.animateToPage(2,
                    duration: Duration(seconds: 1), curve: Curves.ease);
              },
            ),
          ),
        ],
      )),
    );
  }
}

class Lead3 extends StatelessWidget {
  Lead3({Key? key, required this.pageController}) : super(key: key);
  PageController pageController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/default/landing3.jpg',
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            bottom: 10,
            right: 15,
            child: GestureDetector(
              child: Text(
                '開始',
                style: TextStyle(fontSize: 26, color: Colors.white),
              ),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => route == null);
              },
            ),
          ),
        ],
      )),
    );
  }
}
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int pageIndex = 1;
//
//   final pages = [
//     LivePage2(),
//     IndexPage(),
//     ActionPage(),
//      MeetPage(),
//   ProfileOption(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: pages[pageIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Colors.red,
//         unselectedItemColor: Colors.black45,
//         currentIndex: pageIndex,
//         // height: 65,
//         // decoration: BoxDecoration(
//         //   color: Colors.grey.withOpacity(.2),
//         //   // borderRadius: BorderRadius.only(
//         //   //     topLeft: Radius.circular(20), topRight: Radius.circular(20))
//         // ),
//         items: [
//           BottomNavigationBarItem(
//               icon: pageIndex == 0
//                   ? const Icon(
//                       Icons.live_tv,
//                       color: Colors.red,
//                       size: 35,
//                     )
//                   : const Icon(
//                       Icons.live_tv_outlined,
//                       color: Colors.black,
//                       size: 35,
//                     ),
//               label: '直播'),
//           BottomNavigationBarItem(
//               icon: pageIndex == 1
//                   ? const Icon(
//                       Icons.home_filled,
//                       color: Colors.red,
//                       size: 35,
//                     )
//                   : const Icon(
//                       Icons.home_outlined,
//                       color: Colors.black,
//                       size: 35,
//                     ),
//               label: '交友'),
//           BottomNavigationBarItem(
//               icon: pageIndex == 2
//                   ? const Icon(
//                       Icons.timelapse,
//                       color: Colors.red,
//                       size: 35,
//                     )
//                   : const Icon(
//                       Icons.timelapse,
//                       color: Colors.black,
//                       size: 35,
//                     ),
//               label: '動態'),
//           BottomNavigationBarItem(
//               icon: pageIndex == 3
//                   ? const Icon(
//                       Icons.group_add,
//                       color: Colors.red,
//                       size: 35,
//                     )
//                   : const Icon(
//                       Icons.group_add_outlined,
//                       color: Colors.black,
//                       size: 35,
//                     ),
//               label: '聯誼'),
//           BottomNavigationBarItem(
//               icon: pageIndex == 4
//                   ? const Icon(
//                       Icons.person,
//                       color: Colors.red,
//                       size: 35,
//                     )
//                   : const Icon(
//                       Icons.person_outline,
//                       color: Colors.black,
//                       size: 35,
//                     ),
//               label: '我的'),
//         ],
//         onTap: (currentindex) {
//           setState(() {
//             pageIndex = currentindex;
//           });
//         },
//       ),
//     );
//   }
// }
