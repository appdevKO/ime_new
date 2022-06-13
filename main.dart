import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ime_new/ui/action/actionpage.dart';
import 'package:ime_new/ui/me/profileoption.dart';
import 'package:ime_new/ui/meet/meet_page.dart';
import 'package:provider/provider.dart';
import 'business_logic/provider/chat_provider.dart';
import 'business_logic/provider/mqtt_client.dart';
import 'ui/date/indexpage.dart';
import 'ui/live/livepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    print('fire base 初始');
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatProvider>(
            create: (context) => ChatProvider()),
        ChangeNotifierProvider<MqttListen>(create: (context) => MqttListen()),
      ],
      child: GetMaterialApp(
        title: 'Flutter Demo',
        // routes: {
        //   'make_friend': (context) {
        //     return IndexPage();
        //   },
        //   'true_or_dare': (context) {
        //     return TurthOrDare();
        //     // return ChatTestPage();
        //   },
        //   'offline_action': (context) {
        //     return MeetPage();
        //     // return ChatTestPage();
        //   },
        //   // 'spy_stream': (context) {
        //   //   return SpyLivePage();
        //   //   // return IndexPage();
        //   // },
        // },
        home:
            // FutureBuilder(
            //   future: _firebaseApp,
            //   builder: (context, snapshot) {
            //     if (snapshot.hasError) {
            //       print('有錯${snapshot.error.toString()}');
            //       return Text('有東西錯');
            //     } else if (snapshot.hasData) {
            //       return LoginPage();
            //     } else {
            //       return Center(
            //         child: CircularProgressIndicator(),
            //       );
            //     }
            //   },
            // ),
            LoginPage(),

        // LoginPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

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
        appBar: AppBar(
          title: Text('登入頁'),
        ),
        body: Column(
          children: [
            Row(
              children: [
                Text('test登入1 大鵝'),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        Provider.of<ChatProvider>(context, listen: false)
                            .account_id = '10028';
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                            (route) => route == null);
                      },
                      child: Text('test登入1 大鵝')),
                )
              ],
            ),
            Row(
              children: [
                Text('test登入2 木木'),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        Provider.of<ChatProvider>(context, listen: false)
                            .account_id = '10103';
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                            (route) => route == null);
                      },
                      child: Text('test登入2 木木')),
                )
              ],
            ),
            Container(
              height: 120,
            ),
            // Row(
            //   children: [
            //     Text('google 登出'),
            //     Padding(
            //       padding: const EdgeInsets.only(left: 8.0),
            //       child: ElevatedButton(
            //           onPressed: () {
            //             FirebaseAuth.instance.signOut();
            //             GoogleSignIn().signOut();
            //           },
            //           child: Text('google 登出')),
            //     )
            //   ],
            // ),
            SignInButton(
              Buttons.Google,
              text: "Google 登入",
              onPressed: () async {
                var result = await signInWithGoogle();
                if (result is UserCredential) {
                  print('是');
                  print('google user :${result.user?.uid}');
                  //跳轉
                  await Provider.of<ChatProvider>(context, listen: false)
                      .register(result.user)
                      .whenComplete(
                          () => Future.delayed(Duration(seconds: 2), () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                    (route) => route == null);
                              }));
                } else
                  print('不是');
              },
            ),
            Container(
              height: 120,
            ),
            // Row(
            //   children: [
            //     Text('google 登入4'),
            //     Padding(
            //       padding: const EdgeInsets.only(left: 8.0),
            //       child: ElevatedButton(
            //           onPressed: () async {
            //             var result = await signInWithGoogle();
            //             if (result is UserCredential) {
            //               print('是');
            //               print('google user :${result.user?.uid}');
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
            //             print('google 登入結果 ${result}');
            //           },
            //           child: Text('google 登入')),
            //     )
            //   ],
            // ),
            SignInButton(
              Buttons.Facebook,
              text: "Facebook 登入",
              mini: false,
              onPressed: () async {
                var result = await signInWithFacebook();
                if (result is UserCredential) {
                  print('是');
                  print('facebook user :${result.user?.uid}');
                  //跳轉
                  await Provider.of<ChatProvider>(context, listen: false)
                      .register(result.user)
                      .whenComplete(
                          () => Future.delayed(Duration(seconds: 2), () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                    (route) => route == null);
                              }));
                } else
                  print('不是');
              },
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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 1;

  final pages = [
    const LivePage(),
    const IndexPage(),
    const ActionPage(),
    const MeetPage(),
    const ProfileOption(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: Container(
        height: 65,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(.2),
          // borderRadius: BorderRadius.only(
          //     topLeft: Radius.circular(20), topRight: Radius.circular(20))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 0;
                });
              },
              icon: pageIndex == 0
                  ? const Icon(
                      Icons.live_tv,
                      color: Colors.red,
                      size: 35,
                    )
                  : const Icon(
                      Icons.live_tv_outlined,
                      color: Colors.black,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 1;
                });
              },
              icon: pageIndex == 1
                  ? const Icon(
                      Icons.home_filled,
                      color: Colors.red,
                      size: 35,
                    )
                  : const Icon(
                      Icons.home_outlined,
                      color: Colors.black,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 2;
                });
              },
              icon: pageIndex == 2
                  ? const Icon(
                      Icons.local_fire_department,
                      color: Colors.red,
                      size: 35,
                    )
                  : const Icon(
                      Icons.local_fire_department_outlined,
                      color: Colors.black,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 3;
                });
              },
              icon: pageIndex == 3
                  ? const Icon(
                      Icons.group_add,
                      color: Colors.red,
                      size: 35,
                    )
                  : const Icon(
                      Icons.group_add_outlined,
                      color: Colors.black,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 4;
                });
              },
              icon: pageIndex == 4
                  ? const Icon(
                      Icons.person,
                      color: Colors.red,
                      size: 35,
                    )
                  : const Icon(
                      Icons.person_outline,
                      color: Colors.black,
                      size: 35,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
