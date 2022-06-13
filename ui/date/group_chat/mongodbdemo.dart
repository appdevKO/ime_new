
import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State;
import 'package:provider/provider.dart';

class MongoDemoPage extends StatefulWidget {
  const MongoDemoPage({Key? key}) : super(key: key);

  @override
  _MongoDemoPageState createState() => _MongoDemoPageState();
}

class _MongoDemoPageState extends State<MongoDemoPage> {
  late var db;

  @override
  void initState() {
    dbini();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('mongo plugin demo'),
      ),
      body: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                find();
              },
              child: Text('find'))
        ],
      )),
    );
  }

  Future dbini() async {
    db = Db('mongodb://hoolyhi:Wdfsfd123'
        '@cluster0-shard-00-00-h1a0u.gcp.mongodb.net:27017,cluster0-shard-00-01-h1a0u.gcp.mongodb.net:27017,cluster0-shard-00-02-h1a0u.gcp.mongodb.net:27017/ime?authSource=admin&replicaSet=Cluster0-shard-0&readPreference=primary&appname=MongoDB%20Compass&retryWrites=true&ssl=true');
    await db.open();
  }

  Future find() async {
   Provider.of<ChatProvider>(context,listen:false).getgroupteam();
  }
}
