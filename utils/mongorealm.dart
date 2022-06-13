// import 'package:flutter/services.dart';
// import 'package:flutter_mongodb_realm/flutter_mongo_realm.dart';
//
// class MongoRealm {
//   late MongoRealmClient client;
//   late RealmApp app;
//   late CoreRealmUser mongoUser;
//
//   MongoRealm() {
//     client = MongoRealmClient();
//     app = RealmApp();
//   }
//
//   Future mongo_login(email,password) async {
//     print("mongo login");
//     try {
//       mongoUser = (await app
//           .login(Credentials.emailPassword(email, password)))!;
//       return true;
//     } on PlatformException catch (p) {
//       print("錯誤!Error! ${p.message}");
//       return false;
//     } on Exception catch (e) {
//       print("錯誤!Error! $e");
//       return false;
//     }
//   }
//
//   Future mongo_register(email, password) async {
//     // 註冊mongodb的帳號
//     try {
//       await app.registerUser(email, password).whenComplete(() {
//         //  建立ime帳號
//       });
//       print("註冊mongodb的帳號");
//       return true;
//     } on PlatformException catch (p) {
//       print("錯誤!Error! ${p.message}");
//       return false;
//     } on Exception catch (e) {
//       print("錯誤!Error! $e");
//       return false;
//     }
//   }
//
// //訂閱
//   MongoCollection ini_collection(database_name, collection_name) {
//     var collection =
//         client.getDatabase(database_name).getCollection(collection_name);
//
//     // try {
//     //   Stream stream = await collection.watch();
//     //   stream.listen((event) {
//     //     print("stream listen中 發生$event");
//     //
//     //     // var fullDocument = MongoDocument.parse(event);
//     //     // print("fulldocument $fullDocument");
//     //     // print("a document with '${fullDocument.map["_id"]}' is changed");
//     //   });
//     // } on PlatformException catch (e) {
//     //   print("listener Error! ${e.message}");
//     // }
//
//     return collection;
//   }
//
//   Future<void> insertData(collection, data) async {
//     print('insert one api');
//     try {
//       collection.insertOne(data);
//     } catch (e) {
//       print('insert one error exception :: $e');
//     }
//   }
//
//   //find collection 中的資料
//   Future findData(collection) async {
//     print('mongo find colloction $collection');
//     // var docs = await collection.find();
//     // print('docs $docs');
//     try {
//       var docs = await collection.find();
//       print('docs $docs');
//       return docs;
//     } catch (e) {
//       print('mongo find data exception :: $e');
//     }
//   }
//
//   //find collection 中的資料
//   Future updateData(collection, data) async {
//     try {
//       await collection.updateOne(
//           filter: {
//             "nickname": "cc_acount",
//           },
//           update: UpdateOperator.push({
//             "chatroomid": ArrayModifier.each([data])
//           }));
//     } catch (e) {
//       print('mongo updateData exception :: $e');
//     }
//   }
//
//   //delete all !!!!!!!
//
//   Future deleteall(collection) async {
//     print('deleteall');
//
//     try {
//       var docs = await collection.deleteMany();
//     } catch (e) {
//       print('mongo deleteall exception :: $e');
//     }
//   }
// }
