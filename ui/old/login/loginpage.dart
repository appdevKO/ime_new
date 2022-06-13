// import 'package:flutter/material.dart';
// import 'package:ime_module/business_logic/provider/chat_provider.dart';
// import 'package:ime_module/ui/index/indexpage.dart';
//
// import 'package:provider/provider.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);
//
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Stack(
//           children: [
//             Container(
//                 height: MediaQuery.of(context).size.height,
//                 width: MediaQuery.of(context).size.width,
//                 child: Image.network(
//                   'https://images.pexels.com/photos/1078850/pexels-photo-1078850.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260',
//                   fit: BoxFit.cover,
//                 )),
//             Align(
//               alignment: Alignment.bottomRight,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   await Provider.of<ChatProvider>(context, listen: false)
//                       .initial_JM();
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => IndexPage()));
//                 },
//                 child: Text(
//                   '開始',
//                   style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   primary: Colors.transparent,
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
