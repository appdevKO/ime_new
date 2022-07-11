import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';

import 'custom.dart';

const bool _kAutoConsume = true;

const String _kConsumableId = 'consumable';
const String _kUpgradeId = 'upgrade';
const String _kSilverSubscriptionId = 'subscription_silver';
const String _kGoldSubscriptionId = 'subscription_gold';
const List<String> _kProductIds = <String>[
  _kConsumableId,
  _kUpgradeId,
  _kSilverSubscriptionId,
  _kGoldSubscriptionId,
];

class UpGradeVIP extends StatefulWidget {
  const UpGradeVIP({Key? key}) : super(key: key);

  @override
  _UpGradeVIPState createState() => _UpGradeVIPState();
}

class _UpGradeVIPState extends State<UpGradeVIP> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = <String>[];
  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  List<String> _consumables = <String>[];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;

  @override
  void initState() {
    // 訂閱所有incoming的購買選項 可以捕捉購買選項的更新
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      // handle error here.
    });

    initStoreInfo();
    super.initState();
  }

  @override
  void dispose() {
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
    // return SafeArea(
    //   child: Scaffold(
    //     body: SingleChildScrollView(
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           //appbar
    //           Container(
    //             height: 56,
    //             width: MediaQuery.of(context).size.width,
    //             color: Colors.transparent,
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 IconButton(
    //                     icon: Icon(
    //                       Icons.arrow_back,
    //                       color: Colors.black,
    //                     ),
    //                     onPressed: () {
    //                       Navigator.pop(context);
    //                     }),
    //                 Center(
    //                     child: Text(
    //                   '升級VIP',
    //                   style: TextStyle(color: Colors.black, fontSize: 16),
    //                 )),
    //                 IconButton(
    //                   icon: Icon(
    //                     Icons.settings,
    //                     color: Colors.transparent,
    //                   ),
    //                   onPressed: () {},
    //                 ),
    //               ],
    //             ),
    //           ),
    //           //圖1
    //           Center(
    //             child: CircleAvatar(
    //               backgroundColor: Colors.red,
    //               radius: 60,
    //             ),
    //           ),
    //
    //           //項目
    //           Padding(
    //             padding: const EdgeInsets.symmetric(horizontal: 15.0),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: const [
    //                 //title
    //                 Padding(
    //                   padding: EdgeInsets.symmetric(vertical: 20.0),
    //                   child: Text(
    //                     '一般VIP',
    //                     style: TextStyle(color: Colors.red, fontSize: 16),
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding: EdgeInsets.symmetric(vertical: 8.0),
    //                   child: Text('1.額外獲得500 i幣'),
    //                 ),
    //                 Padding(
    //                   padding: EdgeInsets.symmetric(vertical: 8.0),
    //                   child: Text('2.解鎖聊天室所有功能'),
    //                 ),
    //                 Padding(
    //                   padding: EdgeInsets.symmetric(vertical: 8.0),
    //                   child: Text('3.解鎖揪團咖所有功能'),
    //                 ),
    //                 Padding(
    //                   padding: EdgeInsets.symmetric(vertical: 8.0),
    //                   child: Text('4.解鎖動態發布留言'),
    //                 ),
    //                 Padding(
    //                   padding: EdgeInsets.symmetric(vertical: 8.0),
    //                   child: Text('5.解鎖真心話大冒險所有功能'),
    //                 ),
    //                 Padding(
    //                   padding: EdgeInsets.symmetric(vertical: 8.0),
    //                   child: Text('6.'),
    //                 ),
    //                 Padding(
    //                   padding: EdgeInsets.symmetric(vertical: 8.0),
    //                   child: Text('7.'),
    //                 ),
    //                 Padding(
    //                   padding: EdgeInsets.symmetric(vertical: 8.0),
    //                   child: Text('8.'),
    //                 ),
    //               ],
    //             ),
    //           ),
    //
    //           //解鎖按鈕1
    //           Padding(
    //             padding: const EdgeInsets.symmetric(vertical: 15.0),
    //             child: Center(
    //               child: Container(
    //                 height: 50,
    //                 width: 260,
    //                 decoration: BoxDecoration(
    //                     color: Colors.red,
    //                     borderRadius: BorderRadius.circular(10)),
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     Icon(
    //                       Icons.king_bed,
    //                       color: Colors.yellow,
    //                     ),
    //                     Padding(
    //                       padding: EdgeInsets.only(left: 20),
    //                       child: Text(
    //                         '每月 \$500',
    //                         style: TextStyle(color: Colors.white, fontSize: 15),
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //           //圖2
    //           Padding(
    //             padding: const EdgeInsets.only(top: 20.0),
    //             child: Center(
    //               child: CircleAvatar(
    //                 backgroundColor: Colors.red,
    //                 radius: 60,
    //               ),
    //             ),
    //           ),
    //           //項目
    //           Padding(
    //             padding: const EdgeInsets.symmetric(horizontal: 15.0),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: const [
    //                 //title
    //                 Padding(
    //                   padding: EdgeInsets.symmetric(vertical: 20.0),
    //                   child: Text(
    //                     '尊榮VIP',
    //                     style: TextStyle(color: Colors.red, fontSize: 16),
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding: EdgeInsets.symmetric(vertical: 8.0),
    //                   child: Text('1.額外獲得500 i幣'),
    //                 ),
    //                 Padding(
    //                   padding: EdgeInsets.symmetric(vertical: 8.0),
    //                   child: Text('2.解鎖聊天室所有功能'),
    //                 ),
    //                 Padding(
    //                   padding: EdgeInsets.symmetric(vertical: 8.0),
    //                   child: Text('3.解鎖揪團咖所有功能'),
    //                 ),
    //                 Padding(
    //                   padding: EdgeInsets.symmetric(vertical: 8.0),
    //                   child: Text('4.解鎖動態發布留言'),
    //                 ),
    //                 Padding(
    //                   padding: EdgeInsets.symmetric(vertical: 8.0),
    //                   child: Text('5.解鎖真心話大冒險所有功能'),
    //                 ),
    //                 Padding(
    //                   padding: EdgeInsets.symmetric(vertical: 8.0),
    //                   child: Text('6.'),
    //                 ),
    //                 Padding(
    //                   padding: EdgeInsets.symmetric(vertical: 8.0),
    //                   child: Text('7.'),
    //                 ),
    //                 Padding(
    //                   padding: EdgeInsets.symmetric(vertical: 8.0),
    //                   child: Text('8.'),
    //                 ),
    //               ],
    //             ),
    //           ),
    //
    //           //解鎖按鈕2
    //           Padding(
    //             padding: const EdgeInsets.symmetric(vertical: 15.0),
    //             child: Center(
    //               child: Container(
    //                 height: 50,
    //                 width: 260,
    //                 decoration: BoxDecoration(
    //                     color: Colors.red,
    //                     borderRadius: BorderRadius.circular(10)),
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     Icon(
    //                       Icons.king_bed,
    //                       color: Colors.yellow,
    //                     ),
    //                     Padding(
    //                       padding: EdgeInsets.only(left: 20),
    //                       child: Text(
    //                         '每月 \$1300',
    //                         style: TextStyle(color: Colors.white, fontSize: 15),
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
    return Scaffold(
      appBar: AppBar(
        title: const Text('IAP Example'),
      ),
      body: Stack(
        children: stack,
      ),
    );
  }

  //連接商店資訊
  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      //對應刷新
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
    //ios 若訂閱價格上漲 會跳提示窗
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    //load 待售商品 產品細節 產品資訊
    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }
    //是不是google產品
    if (productDetailResponse.productDetails is GooglePlayPurchaseDetails) {
      PurchaseWrapper billingClientPurchase =
          (productDetailResponse.productDetails as GooglePlayPurchaseDetails)
              .billingClientPurchase;
      print(billingClientPurchase.originalJson);
    }
    //是不是ios產品
    if (productDetailResponse.productDetails is AppStorePurchaseDetails) {
      SKPaymentTransactionWrapper skProduct =
          (productDetailResponse.productDetails as AppStorePurchaseDetails)
              .skPaymentTransaction;
      print(skProduct.transactionState);
    }

    final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = consumables;
      _purchasePending = false;
      _loading = false;
    });
  }

  Future<void> consume(String id) async {
    await ConsumableStore.consume(id);
    final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _consumables = consumables;
    });
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    if (purchaseDetails.productID == _kConsumableId) {
      await ConsumableStore.save(purchaseDetails.purchaseID!);
      final List<String> consumables = await ConsumableStore.load();
      setState(() {
        _purchasePending = false;
        _consumables = consumables;
      });
    } else {
      setState(() {
        _purchases.add(purchaseDetails);
        _purchasePending = false;
      });
    }
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

  // 訂閱所有incoming的購買選項 可以捕捉購買選項的更新
  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (Platform.isAndroid) {
          if (!_kAutoConsume && purchaseDetails.productID == _kConsumableId) {
            final InAppPurchaseAndroidPlatformAddition androidAddition =
                _inAppPurchase.getPlatformAddition<
                    InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<void> confirmPriceChange(BuildContext context) async {
    if (Platform.isAndroid) {
      final InAppPurchaseAndroidPlatformAddition androidAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      final BillingResultWrapper priceChangeConfirmationResult =
          await androidAddition.launchPriceChangeConfirmationFlow(
        sku: 'purchaseId',
      );
      if (priceChangeConfirmationResult.responseCode == BillingResponse.ok) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Price change accepted'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            priceChangeConfirmationResult.debugMessage ??
                'Price change failed with code ${priceChangeConfirmationResult.responseCode}',
          ),
        ));
      }
    }
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iapStoreKitPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
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
            _inAppPurchase.completePurchase(purchase);
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
          trailing: previousPurchase != null
              ? IconButton(
              onPressed: () => confirmPriceChange(context),
              icon: const Icon(Icons.upgrade))
              : TextButton(
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

              if (productDetails.id == _kConsumableId) {
                _inAppPurchase.buyConsumable(
                    purchaseParam: purchaseParam,
                    autoConsume: _kAutoConsume || Platform.isIOS);
              } else {
                _inAppPurchase.buyNonConsumable(
                    purchaseParam: purchaseParam);
              }
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
          onPressed: () => consume(id),
        ),
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
            onPressed: () => _inAppPurchase.restorePurchases(),
            child: const Text('Restore purchases'),
          ),
        ],
      ),
    );
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
