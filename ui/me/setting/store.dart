import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/me/setting/consume.dart';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:provider/provider.dart';

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
  bool _kAutoConsume = true;
  List<String> _notFoundIds = <String>[];
  String _kConsumableId = 'consumable';
  String _kUpgradeId = 'upgrade';
  String _kSilverSubscriptionId = 'subscription_silver';
  String _kGoldSubscriptionId = 'subscription_gold';
  List<String> _consumables = <String>[];
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;

  @override
  void initState() {
    _subscription =
        _iap.purchaseStream.listen((List<PurchaseDetails> purchaseDetailsList) {
      print('訂閱 _subscription list :${purchaseDetailsList}');
      // if (data[0] is GooglePlayPurchaseDetails) {
      //   print('GooglePlayPurchaseDetails:後續 ${data[0].status}');
      // }
      // setState(() {
      //   _purchases.addAll(data);
      //   _verifyPurchases();
      // });
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      // handle error here.
    });
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> stack = <Widget>[];
    if (_queryProductError == null) {
      stack.add(
        ListView(
          children: <Widget>[
            _buildConnectionCheckTile(),
            _buildProductList(),
            _buildConsumableBox(),
            _buildRestoreButton(),
          ],
        ),
      );
    } else {
      stack.add(Center(
        child: Text(_queryProductError!),
      ));
    }
    if (_purchasePending) {
      stack.add(
        Stack(
          children: const <Widget>[
            Opacity(
              opacity: 0.3,
              child: ModalBarrier(dismissible: false, color: Colors.grey),
            ),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('IAP Example'),
      ),
      body: Stack(
        children: stack,
      ),
    );
  }

  Card _buildConnectionCheckTile() {
    if (_loading) {
      return const Card(child: ListTile(title: Text('Trying to connect...')));
    }
    final Widget storeHeader = ListTile(
      leading: Icon(_isAvailable ? Icons.check : Icons.block,
          color: _isAvailable ? Colors.green : ThemeData.light().errorColor),
      title:
          Text('The store is ${_isAvailable ? 'available' : 'unavailable'}.'),
    );
    final List<Widget> children = <Widget>[storeHeader];

    if (!_isAvailable) {
      children.addAll(<Widget>[
        const Divider(),
        ListTile(
          title: Text('Not connected',
              style: TextStyle(color: ThemeData.light().errorColor)),
          subtitle: const Text(
              'Unable to connect to the payments processor. Has this app been configured correctly? See the example README for instructions.'),
        ),
      ]);
    }
    return Card(child: Column(children: children));
  }

  Future<void> _initialize() async {
    final bool isAvailable = await _iap.isAvailable();

    if (isAvailable) {
      print("可連接iap商店");
      // id 列出
      Set<String> ids = <String>{
        '300coin',
        '200coin',
        '100coin',
        'icoin200',
        'icoin100'
      };
      //ios 若訂閱價格上漲 會跳提示窗
      if (Platform.isIOS) {
        final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
            _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
        await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
      }
      //load 待售商品 產品細節 產品資訊
      ProductDetailsResponse response = await _iap.queryProductDetails(ids);
      print('獲得產品詳細 detail:${response.productDetails}');
      print('獲得產品詳細 not found:${response.notFoundIDs}');
      print('獲得產品詳細 error:${response.error}');

      if (response.error != null) {
        setState(() {
          _queryProductError = response.error!.message;
          _isAvailable = isAvailable;
          _products = response.productDetails;
          _purchases = <PurchaseDetails>[];
          _notFoundIds = response.notFoundIDs;
          _consumables = <String>[];
          _purchasePending = false;
          _loading = false;
        });
        return;
      }
      if (response.notFoundIDs.isNotEmpty) {
        //有id找不到
        setState(() {
          _queryProductError = response.error?.message;
          _isAvailable = isAvailable;
          _products = response.productDetails;
          _purchases = <PurchaseDetails>[];
          _notFoundIds = response.notFoundIDs;
          _consumables = <String>[];
          _purchasePending = false;
          _loading = false;
        });
      }
      if (response.productDetails.isNotEmpty) {
        setState(() {
          _queryProductError = null;
          _isAvailable = isAvailable;
          _products = response.productDetails;
          _purchases = <PurchaseDetails>[];
          _notFoundIds = response.notFoundIDs;
          _consumables = <String>[];
          _purchasePending = false;
          _loading = false;
        });
      } else {
        print('產品資訊列表是空的');
      }
      //是不是google產品
      if (response.productDetails is GooglePlayPurchaseDetails) {
        PurchaseWrapper billingClientPurchase =
            (response.productDetails as GooglePlayPurchaseDetails)
                .billingClientPurchase;
        print(billingClientPurchase.originalJson);
      }
      //是不是ios產品
      if (response.productDetails is AppStorePurchaseDetails) {
        SKPaymentTransactionWrapper skProduct =
            (response.productDetails as AppStorePurchaseDetails)
                .skPaymentTransaction;
        print(skProduct.transactionState);
      }

      final List<String> consumables = await ConsumableStore.load();
      setState(() {
        _isAvailable = isAvailable;
        _products = response.productDetails;
        _notFoundIds = response.notFoundIDs;
        _consumables = consumables;
        _purchasePending = false;
        _loading = false;
      });
      // await _getPastPurchases();
      // _verifyPurchases();

      ///須改
      ///啟動後到主頁中間就得監聽
      //監聽/訂閱 purchase 的更新
      // 更新可能發生
      // 在用戶在應用程式中購買後
      // 從特定平台購買時
      // 在應用程式中恢復設備上的購買

    } else {
      setState(() {
        _isAvailable = isAvailable;
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];
        _notFoundIds = <String>[];
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }
  }

  void _buyProduct(ProductDetails prod) {
    print('${prod.id}');
    if (Platform.isAndroid) {
      final PurchaseParam purchaseParam = GooglePlayPurchaseParam(
        productDetails: prod,
        applicationUserName: null,
      );
      //up to user to call consumable or nonconsumable
      _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: false);
    } else if (Platform.isIOS) {
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
      _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: false);
    }
  }

  Widget _buildRestoreButton() {
    if (_loading) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              // TODO(darrenaustin): Migrate to new API once it lands in stable: https://github.com/flutter/flutter/issues/105724
              // ignore: deprecated_member_use
              primary: Colors.white,
            ),
            onPressed: () => _iap.restorePurchases(),
            child: const Text('Restore purchases'),
          ),
        ],
      ),
    );
  }

//  檢查是否已經買過
//   void _verifyPurchases() {
//     PurchaseDetails purchase = _hasUserPurchased(testID);
//     if (purchase.status == PurchaseStatus.purchased) {
//       _credits = 10;
//     }
//   }
//
//   // checks if a user has purchased a certain product
//   PurchaseDetails _hasUserPurchased(String productID) {
//     // if(_purchases.isEmpty){
//     //   return null;
//     // }
//     return _purchases.firstWhere((purchase) => purchase.productID == productID);
//   }

  //獲得過去買過的產品 = 恢復購買內容 ex換手機
  // 大多數情況下，您只需要刷新應用收據並交付收據上列出的產品
  // 刷新的收據包含用戶在此應用程序中的購買記錄，從用戶的 App Store 帳戶登錄的任何設備
  // Future<void> _getPastPurchases() async {
  //   ///
  //   // QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();
  //   // //如果已存在在過去買過的列表 刷新 目前產品的列表
  //   // for (PurchaseDetails purchase in response.pastPurchases) {
  //   //   if (Platform.isIOS) {
  //   //     _iap.completePurchase(purchase);
  //   //   }
  //   // }
  //   // setState(() {
  //   //   _purchases = response.pastPurchases;
  //   // });
  // }

  // void spendCoins(PurchaseDetails purchase) async {
  //   // setState(() {
  //   //   _coins--;
  //   // });
  //   // if (_coins == 0) {
  //   //   var res = await _iap.consumePurchase(purchase);
  //   // }
  // }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        //付費中
        print('付費中');
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          print('付款失敗');
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          // 已購買或restored
          print('已購買');
          // 先驗證
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (Platform.isAndroid) {
          // if (!_kAutoConsume && purchaseDetails.productID == _kConsumableId) {
          final InAppPurchaseAndroidPlatformAddition androidAddition =
              _iap.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
          await androidAddition.consumePurchase(purchaseDetails);
          // }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _iap.completePurchase(purchaseDetails);
        }
      }
    }
  }

  // Future<void> consume(String id) async {
  //   await ConsumableStore.consume(id);
  //   final List<String> consumables = await ConsumableStore.load();
  //   setState(() {
  //     _consumables = consumables;
  //   });
  // }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    print('deliverProduct ${purchaseDetails.productID}');
    // IMPORTANT!! Always verify purchase details before delivering the product.
    // if (purchaseDetails.productID == _kConsumableId) {
    //   await ConsumableStore.save(purchaseDetails.purchaseID!);
    //   final List<String> consumables = await ConsumableStore.load();
    //   setState(() {
    //     _purchasePending = false;
    //     _consumables = consumables;
    //   });
    // } else {
    setState(() {
      _consumables.add(purchaseDetails.productID);
      print('購買了${purchaseDetails.productID.split('coin')[0]} ');
      Provider.of<ChatProvider>(context, listen: false)
          .add_money(int.parse(purchaseDetails.productID.split('coin')[0]));
      _purchases.add(purchaseDetails);
      _purchasePending = false;
    });
    // }
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  Card _buildProductList() {
    if (_loading) {
      return const Card(
          child: ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Fetching products...')));
    }
    if (!_isAvailable) {
      return const Card();
    }
    const ListTile productHeader = ListTile(title: Text('Products for Sale'));
    final List<ListTile> productList = <ListTile>[];
    if (_notFoundIds.isNotEmpty) {
      productList.add(ListTile(
          title: Text('[${_notFoundIds.join(", ")}] not found',
              style: TextStyle(color: ThemeData.light().errorColor)),
          subtitle: const Text(
              'This app needs special configuration to run. Please see example/README.md for instructions.')));
    }

    // This loading previous purchases code is just a demo. Please do not use this as it is.
    // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
    // We recommend that you use your own server to verify the purchase data.
    final Map<String, PurchaseDetails> purchases =
        Map<String, PurchaseDetails>.fromEntries(
            _purchases.map((PurchaseDetails purchase) {
      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
      }
      return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
    }));
    productList.addAll(_products.map(
      (ProductDetails productDetails) {
        final PurchaseDetails? previousPurchase = purchases[productDetails.id];
        return ListTile(
          title: Text(
            productDetails.title,
          ),
          subtitle: Text(
            productDetails.description,
          ),
          trailing:

              // previousPurchase != null
              //     ? IconButton(
              //         onPressed: () =>
              //             confirmPriceChange(context, productDetails.id),
              //         icon: const Icon(Icons.upgrade))
              //     :

              TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.green[800],
              // TODO(darrenaustin): Migrate to new API once it lands in stable: https://github.com/flutter/flutter/issues/105724
              // ignore: deprecated_member_use
              primary: Colors.white,
            ),
            onPressed: () {
              late PurchaseParam purchaseParam;

              if (Platform.isAndroid) {
                // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
                // verify the latest status of you your subscription by using server side receipt validation
                // and update the UI accordingly. The subscription purchase status shown
                // inside the app may not be accurate.
                final GooglePlayPurchaseDetails? oldSubscription =
                    _getOldSubscription(productDetails, purchases);

                purchaseParam = GooglePlayPurchaseParam(
                    productDetails: productDetails,
                    applicationUserName: null,
                    changeSubscriptionParam: (oldSubscription != null)
                        ? ChangeSubscriptionParam(
                            oldPurchaseDetails: oldSubscription,
                            prorationMode:
                                ProrationMode.immediateWithTimeProration,
                          )
                        : null);
              } else {
                purchaseParam = PurchaseParam(
                  productDetails: productDetails,
                  applicationUserName: null,
                );
              }

              // if (productDetails.id == _kConsumableId) {
              var result = _iap.buyConsumable(
                  purchaseParam: purchaseParam,
                  autoConsume: _kAutoConsume || Platform.isIOS);
              // } else {
              //   _iap.buyNonConsumable(purchaseParam: purchaseParam);
              // }
            },
            child: Text(productDetails.price),
          ),
        );
      },
    ));

    return Card(
        child: Column(
            children: <Widget>[productHeader, const Divider()] + productList));
  }

  Future<void> confirmPriceChange(BuildContext context, purchaseId) async {
    print('purchaseId $purchaseId');
    if (Platform.isAndroid) {
      try {
        final InAppPurchaseAndroidPlatformAddition androidAddition =
            _iap.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
        final BillingResultWrapper priceChangeConfirmationResult =
            await androidAddition.launchPriceChangeConfirmationFlow(
          sku: purchaseId,
        );
        if (priceChangeConfirmationResult.responseCode == BillingResponse.ok) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              'Price change accepted',
              style: TextStyle(color: Colors.red),
            ),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              priceChangeConfirmationResult.debugMessage ??
                  'Price change failed with code ${priceChangeConfirmationResult.responseCode}',
              style: TextStyle(color: Colors.red),
            ),
          ));
        }
      } catch (e) {
        print('確認價格錯誤$e');
      }
    }
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iapStoreKitPlatformAddition =
          _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
    }
  }

  GooglePlayPurchaseDetails? _getOldSubscription(
      ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
    // This is just to demonstrate a subscription upgrade or downgrade.
    // This method assumes that you have only 2 subscriptions under a group, 'subscription_silver' & 'subscription_gold'.
    // The 'subscription_silver' subscription can be upgraded to 'subscription_gold' and
    // the 'subscription_gold' subscription can be downgraded to 'subscription_silver'.
    // Please remember to replace the logic of finding the old subscription Id as per your app.
    // The old subscription is only required on Android since Apple handles this internally
    // by using the subscription group feature in iTunesConnect.
    GooglePlayPurchaseDetails? oldSubscription;
    if (productDetails.id == _kSilverSubscriptionId &&
        purchases[_kGoldSubscriptionId] != null) {
      oldSubscription =
          purchases[_kGoldSubscriptionId]! as GooglePlayPurchaseDetails;
    } else if (productDetails.id == _kGoldSubscriptionId &&
        purchases[_kSilverSubscriptionId] != null) {
      oldSubscription =
          purchases[_kSilverSubscriptionId]! as GooglePlayPurchaseDetails;
    }
    return oldSubscription;
  }

  Card _buildConsumableBox() {
    if (_loading) {
      return const Card(
          child: ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Fetching consumables...')));
    }
    if (!_isAvailable || _notFoundIds.contains(_kConsumableId)) {
      return const Card();
    }
    const ListTile consumableHeader =
        ListTile(title: Text('Purchased consumables'));
    final List<Widget> tokens = _consumables.map((String id) {
      return GridTile(
        child: IconButton(
          icon: const Icon(
            Icons.stars,
            size: 42.0,
            color: Colors.orange,
          ),
          splashColor: Colors.yellowAccent,
          // onPressed: () => consume(id),
          onPressed: () {},
        ),
        footer: Text('$id'),
      );
    }).toList();
    return Card(
        child: Column(children: <Widget>[
      consumableHeader,
      const Divider(),
      GridView.count(
        crossAxisCount: 5,
        shrinkWrap: true,
        padding: const EdgeInsets.all(16.0),
        children: tokens,
      )
    ]));
  }
}

/// Example implementation of the
/// [`SKPaymentQueueDelegate`](https://developer.apple.com/documentation/storekit/skpaymentqueuedelegate?language=objc).
///
/// The payment queue delegate can be implementated to provide information
/// needed to complete transactions.
class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
