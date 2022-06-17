import 'dart:async';

import 'package:mongo_dart/mongo_dart.dart' as mongo;

class MongoDB {
  var db;

  MongoDB() {
    dbini();
  }

  // MongoDB._(this.db);
  //
  // static Future<MongoDB> createNew() {
  //   var db = mongo.Db('mongodb://hoolyhi:Wdfsfd123'
  //       '@cluster0-shard-00-00-h1a0u.gcp.mongodb.net:27017,cluster0-shard-00-01-h1a0u.gcp.mongodb.net:27017,cluster0-shard-00-02-h1a0u.gcp.mongodb.net:27017/ime?authSource=admin&replicaSet=Cluster0-shard-0&readPreference=primary&appname=MongoDB%20Compass&retryWrites=true&ssl=true');
  //
  //   return db.open().then((_) => new MongoDB._(db));
  // }

  Future dbini() async {
    db = mongo.Db('mongodb://hoolyhi:Wdfsfd123'
        '@cluster0-shard-00-00-h1a0u.gcp.mongodb.net:27017,cluster0-shard-00-01-h1a0u.gcp.mongodb.net:27017,cluster0-shard-00-02-h1a0u.gcp.mongodb.net:27017/ime?authSource=admin&replicaSet=Cluster0-shard-0&readPreference=primary&appname=MongoDB%20Compass&retryWrites=true&ssl=true');
    await db.open();
    Timer.periodic(Duration(seconds: 5), (timer) async {
      print("db restart");
      if (!db.isConnected || db.state == mongo.State.OPENING) {
        if (db.state == mongo.State.OPENING) {
          db.state = mongo.State
              .CLOSED; // I am manually updating the state to CLOSE to prevent the invalid state exception.
        }
        await db.open();
      }
    });
    // Future.delayed(Duration(seconds: 5), () async {
    //   if (!db.isConnected || db.state == mongo.State.OPENING) {
    //     if (db.state == mongo.State.OPENING) {
    //       db.state = mongo.State
    //           .CLOSED; // I am manually updating the state to CLOSE to prevent the invalid state exception.
    //     }
    //     await db.open();
    //   }
    // });
  }

  var datalist;

  Future readdb(func, collection_name, {field}) async {
    datalist = [];
    print("readdb 前 list :: $datalist");
    var coll = db.collection(collection_name);
    Map<String, dynamic> map;
    await coll
        .modernFind(
            selector: field, findOptions: mongo.FindOptions(maxTimeMS: 5000))
        .forEach((v) {
      print("db 回傳單一資料 $v");
      map = Map<String, dynamic>.from(v);
      datalist.add(func(map));
    });

    // try {
    //   await coll
    //       .modernFind(
    //           selector: field, findOptions: mongo.FindOptions(maxTimeMS: 5000))
    //       .forEach((v) {
    //     print("db 回傳單一資料 $v");
    //     map = Map<String, dynamic>.from(v);
    //     datalist.add(func(map));
    //   });
    // } catch (e) {
    //   print("mongo find exception $e");
    // }
    return datalist;
  }

  Future readdb_near(func, collection_name, {field}) async {
    datalist = [];
    print("readdbnear 前 list :: $datalist");
    var coll = db.collection(collection_name);
    Map<String, dynamic> map;

    await coll
        // .find(mongo.where.near('position', location_condition))
        .modernFind(
            selector: field, findOptions: mongo.FindOptions(maxTimeMS: 5000))
        .forEach((data) {
      print("db  readdbnear 回傳單一資料 $data");
      map = Map<String, dynamic>.from(data);
      datalist.add(func(map));
    });

    return datalist;
  }

  // Future readdb2(
  //   collection_name,
  // ) async {
  //   datalist = [];
  //   var coll = db.collection(collection_name);
  //   Map<String, dynamic> map;
  //
  //   await coll.find().forEach((v) {
  //     print("v and v $v");
  //     map = Map<String, dynamic>.from(v);
  //     datalist.add(ChatRoomModel.fromJson(map));
  //   });
  //   return datalist;
  // }

  Future inserttomongo(collection_name, data) async {
    var coll = db.collection(collection_name);

    try {
      await coll.insertOne(data);
    } catch (e) {
      print("create db exception$e");
    }
  }

  ///update upsert 如果裡面沒有這筆資料就新增
  ///順序很重要
  Future upsertData(collection_name, con_field, con_value, data_field,
      data_value, data) async {
    print('測試一下');
    // data.forEach((key, value) => print('$key'));
    try {
      var coll = db.collection(collection_name);
      await data.forEach((key, value) => coll.updateOne(
          mongo.where.eq(con_field, con_value).and(mongo.where.eq(
                data_field,
                data_value,
              )),
          mongo.modify.set(key, value),
          upsert: true));
    } catch (e) {
      print('mongo create account exception :: $e');
    }
  }

  Future upsertData2(collection_name, con_field, con_value, data) async {
    print('測試一下2');
    // data.forEach((key, value) => print('$key'));
    try {
      var coll = db.collection(collection_name);
      await data.forEach((key, value) => coll.updateOne(
          mongo.where.eq(con_field, con_value), mongo.modify.set(key, value),
          upsert: true));
    } catch (e) {
      print('mongo create account exception :: $e');
    }
  }

  Future deletealltable(collection) async {
    print('deleteall');
    var coll = db.collection(collection);
    try {
      await coll.deleteMany({});

      ///要加{}
    } catch (e) {
      print('mongo deleteall exception :: $e');
    }
  }

  Future delete_one(collection, field) async {
    print('delete_one');
    var coll = db.collection(collection);
    try {
      await coll.deleteOne(field);
    } catch (e) {
      print('mongo deleteall exception :: $e');
    }
  }

  Future plus_num(collection, con_field, con_value, value, offset) async {
    print('plus_num');
    var coll = db.collection(collection);
    try {
      await coll.updateOne(
          mongo.where.eq(con_field, con_value), mongo.modify.inc(value, offset),
          upsert: true);
    } catch (e) {
      print('mongo deleteall exception :: $e');
    }
  }

  Future count(
    collection,
    con_field,
    con_value,
  ) async {
    print('mongo db count');
    var coll = db.collection(collection);
    try {
      var count = await coll.count(
        mongo.where.eq(con_field, con_value),
      );
      print('mongo db count');
      return count;
    } catch (e) {
      print('mongo deleteall exception :: $e');
    }
  }

  ///update  addToSet 如果array 裡面沒有這筆資料就新增
  Future updateData_addSet(
      collection, con_field, con_value, target_field, data) async {
    var coll = db.collection(collection);
    // print("data11111 $data");

    try {
      await coll.updateOne(mongo.where.eq(con_field, con_value),
          mongo.modify.addToSet(target_field, data));
    } catch (e) {
      print('mongo updateData exception :: $e');
    }
  }

//都更新
  Future updateData_single(collection, con_field, con_value, data) async {
    var coll = db.collection(collection);

    try {
      await data.forEach((key, value) => coll.updateOne(
            mongo.where.eq(con_field, con_value),
            mongo.modify.set(key, value),
          ));
    } catch (e) {
      print('mongo updateData exception :: $e');
    }
  }

  //存在即不更新
  //註冊用
  Future updateData_single2(
    collection,
    con_field,
    con_value,
    data,
  ) async {
    var coll = db.collection(collection);
    print('存在即不更新');

    try {
      // await data.forEach((key, value) => coll.updateOne(
      //     mongo.where.eq(con_field, con_value), mongo.modify.setOnInsert(key, value),
      //     upsert: true));
      ///重點
      await coll.updateMany(
          mongo.where.eq(con_field, con_value), {'\$setOnInsert': data},
          upsert: true);
    } catch (e) {
      print('mongo updateData exception存在即不更新 :: $e');
    }
  }

  Future deleteData(collection, con_field, con_value, datafield, data) async {
    var coll = db.collection(collection);
    try {
      await coll.updateOne(mongo.where.eq(con_field, con_value),
          mongo.modify.pull(datafield, data));
    } catch (e) {
      print('mongo updateData exception :: $e');
    }
  }

  Future create_locationindex(collection) async {
    print('create index 88888');
    await db.createIndex(collection, keys: {'position': '2dsphere'});
  }

  Future dbclose() async {
    await db.close();
  }
}
