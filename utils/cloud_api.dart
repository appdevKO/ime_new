import 'dart:typed_data';

import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:gcloud/storage.dart';
import 'package:mime/mime.dart';

class CloudApi {
  final auth.ServiceAccountCredentials _credentials;
  auth.AutoRefreshingAuthClient? _client;

  CloudApi(String json)
      : _credentials = auth.ServiceAccountCredentials.fromJson(json);

  Future<ObjectInfo> save(String name, Uint8List imgBytes) async {
    print('圖片名字$name');
    // if (_client == null) {
    //   print('client has not been initialized');
    //   _client =
    //       await auth.clientViaServiceAccount(_credentials, Storage.SCOPES);
    // }
    _client = await auth.clientViaServiceAccount(_credentials, Storage.SCOPES);

    // Instantiate objects to cloud storage
    var storage = Storage(_client!, 'CCW-dev');
    //創建一個新桶子
    // var bucket = await storage.createBucket('1122jgert');
    //訪問已存在的桶子
    var bucket = await storage.bucket('ime-live');

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final type = lookupMimeType(name);
    return await bucket.writeBytes(name, imgBytes,
        metadata: ObjectMetadata(
          contentType: type,
          custom: {
            'timestamp': '$timestamp',
          },
        ));
  }

  //gcp 不同桶子
  Future<ObjectInfo> save2(String name, Uint8List imgBytes) async {
    print('save 2 測試');
    _client = await auth.clientViaServiceAccount(_credentials, Storage.SCOPES);
    var storage = Storage(_client!, 'CCW-dev');
    //創建一個新桶子
    // var bucket = await storage.createBucket('1122jgert');
    //訪問已存在的桶子
    var bucket = await storage.bucket('ime-chat');
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final type = lookupMimeType(name);
    return await bucket.writeBytes(name, imgBytes,
        metadata: ObjectMetadata(
          contentType: type,
          custom: {
            'timestamp': '$timestamp',
          },
        ));
  }
}
