import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'in_app_purchases.g.dart';

@riverpod
class InAppPurchases extends _$InAppPurchases {
  static const _adsProductId = 'completely_remove_ads.1';
  static const _productIds = {_adsProductId};

  bool _isConsumable(ProductDetails product) => switch (product.id) {
        _adsProductId => false,
        _ => true,
      };

  @override
  PurchasesState build() {
    _purchasesSubscription ??=
        InAppPurchase.instance.purchaseStream.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _purchasesSubscription?.cancel();
    }, onError: (error) {
      // handle error here.
    });
    InAppPurchase.instance
        .queryProductDetails(_productIds)
        .then(updateProducts);
    return PurchasesState(
      initialized: false,
      allProducts: [],
      purchases: [],
    );
  }

  void updateProducts(ProductDetailsResponse productDetailsResponse) {
    final productDetailsList = productDetailsResponse.productDetails;
    state = state.copyWith(
      allProducts: productDetailsList,
      initialized: true,
    );
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    state = state.copyWith(
      purchases: purchaseDetailsList,
      initialized: true,
    );
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        continue;
      }
      if (purchaseDetails.status == PurchaseStatus.purchased) {
        state = state.copyWith(
          purchases: state.purchases
              .where((purchase) => purchase.status != PurchaseStatus.purchased)
              .toList(),
        );
      }
    }
  }

  StreamSubscription<List<PurchaseDetails>>? _purchasesSubscription;

  Future<void> buy(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    if (_isConsumable(product)) {
      InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
    } else {
      InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }
}

class PurchasesState {
  final List<ProductDetails> allProducts;
  final List<PurchaseDetails> purchases;

  final bool initialized;

  PurchasesState({
    required this.allProducts,
    required this.purchases,
    this.initialized = false,
  });

  PurchasesState copyWith({
    List<ProductDetails>? allProducts,
    List<PurchaseDetails>? purchases,
    bool? initialized,
  }) {
    return PurchasesState(
      allProducts: allProducts ?? this.allProducts,
      purchases: purchases ?? this.purchases,
      initialized: initialized ?? this.initialized,
    );
  }
}

extension PurchasesHelper on PurchasesState {
  bool? get isAdsRemoved {
    if (!initialized) return null;

    return purchases.any((purchase) =>
        purchase.status == PurchaseStatus.purchased &&
        purchase.productID == InAppPurchases._adsProductId);
  }

  bool get showAds => isAdsRemoved == false;
}

extension PurchasingHelper on InAppPurchases {
  Future<void> buyAdFree() async {
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    final product = state.allProducts
        .firstWhere((product) => product.id == InAppPurchases._adsProductId);
    await buy(product);
  }
}
