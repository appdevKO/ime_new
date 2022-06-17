import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ime_new/business_logic/provider/TD_game.dart';
import 'package:ime_new/ui/loginpage/loginpage.dart';
import 'package:provider/provider.dart';
import 'business_logic/provider/chat_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    print('fire base 初始');
    await Firebase.initializeApp();
  }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
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
        ChangeNotifierProvider<TD_game>(create: (context) => TD_game()),
      ],
      child: GetMaterialApp(
        title: 'IME',
        home: LeadPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
