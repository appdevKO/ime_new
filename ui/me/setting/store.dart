import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

class FakeStore extends StatefulWidget {
  const FakeStore({Key? key}) : super(key: key);

  @override
  State<FakeStore> createState() => _FakeStoreState();
}

class _FakeStoreState extends State<FakeStore> {
  String testID = 'IME';
  final InAppPurchase _iap = InAppPurchase.instance;

// checks if the API is available on this device
  bool _isAvailable = false;

// keeps a list of products queried from Playstore or app store
  List<ProductDetails> _products = [];

// List of users past purchases
  List<PurchaseDetails> _purchases = [];

// subscription that listens to a stream of updates to purchase details
  late StreamSubscription _subscription;

// used to represents consumable credits the user can buy
  int _credits = 0;
  int _coins = 0;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商店'),
      ),
      body: Center(
        child: Column(
          children: [
            // Looping over products from app store or Playstore
            // for each product, determine if the user has a past purchase for it
            for (var product in _products)

//            已經購買過
              if (_hasUserPurchased(product.id) != null) ...[
                Text(
                  '$_coins',
                  style: const TextStyle(fontSize: 30),
                ),
                // ElevatedButton(
                //     onPressed: () => spendCoins(_hasUserPurchased(product.id)),
                //     child: const Text('Consume')),
              ]

              // If not purchased exist
              else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 200,
                            child: Text('商品名稱:${product.title}'),
                          ),
                          Text(
                            '商品介紹:${product.description}',
                          ),
                          Text(
                            '商品價錢:${product.price}',
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () => _buyProduct(product),
                        child: const Text(
                          '購買',
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                )
              ]
          ],
        ),
      ),
    );
  }

  Future<void> _initialize() async {
    _isAvailable = await _iap.isAvailable();
    if (_isAvailable) {
      print("可連接iap商店");
      await _getUserProducts();
      // await _getPastPurchases();
      // _verifyPurchases();

      ///須改
      ///啟動後到主頁中間就得監聽
      //監聽/訂閱 purchase 的更新
      // 更新可能發生
      // 在用戶在應用程式中購買後
      // 從特定平台購買時
      // 在應用程式中恢復設備上的購買

      _subscription = _iap.purchaseStream.listen((data) {
        print('訂閱 data:$data');
        // setState(() {
        //   _purchases.addAll(data);
        //   // _verifyPurchases();
        // });
      });
    }
  }

  // 用id獲得產品詳細
  Future<void> _getUserProducts() async {
    // id 列出
    Set<String> ids = <String>{'300coin', '200coin', '100coin','icoin200','icoin100'
    };
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    print('獲得產品詳細${response.productDetails}');
    print('獲得產品詳細${response.notFoundIDs}');
    print('獲得產品詳細${response.error}');

    if (response.notFoundIDs.isNotEmpty) {
      //有id找不到
    }
    if (response.productDetails.isNotEmpty) {
      setState(() {
        _products = response.productDetails;
      });
    } else {
      print('產品資訊列表是空的');
    }
  }

  void _buyProduct(ProductDetails prod) {
    print('${prod.id}');
    if (Platform.isAndroid) {
      final PurchaseParam purchaseParam = GooglePlayPurchaseParam(
        productDetails: prod,
        applicationUserName: null,
      );
      _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: false);
    } else if (Platform.isIOS) {
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
      _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: false);
    }
  }

//  檢查是否已經買過
  void _verifyPurchases() {
    // PurchaseDetails purchase = _hasPurchased(testID);
    // if (purchase != null && purchase.status == PurchaseStatus.purchased) {
    //   _credits = 10;
    // }
  }

  Future<void> _getPastPurchases() async {
    // QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();
    // //如果已存在在過去買過的列表 刷新 目前產品的列表
    // for (PurchaseDetails purchase in response.pastPurchases) {
    //   if (Platform.isIOS) {
    //     _iap.completePurchase(purchase);
    //   }
    // }
    // setState(() {
    //   _purchases = response.pastPurchases;
    // });
  }

  // checks if a user has purchased a certain product
  PurchaseDetails? _hasUserPurchased(String productID) {
    if (_purchases.isNotEmpty) {
      return _purchases
          .firstWhere((purchase) => purchase.productID == productID);
    } else {
      return null;
    }
  }

  void spendCoins(PurchaseDetails purchase) async {
    // setState(() {
    //   _coins--;
    // });
    // if (_coins == 0) {
    //   var res = await _iap.consumePurchase(purchase);
    // }
  }
}
