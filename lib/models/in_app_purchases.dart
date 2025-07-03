import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibrationtest/models/a_b.dart';

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
    _loadBoughtItems();
    return PurchasesState(
      initialized: false,
      allProducts: [],
      boughtItems: {},
    );
  }

  void _loadBoughtItems() async {
    final prefs = SharedPreferencesAsync();
    for (var id in _productIds) {
      final bought = await prefs.getBool('bought:$id');
      state = state
          .copyWith(boughtItems: {...state.boughtItems, id: bought ?? false});
    }
    state = state.copyWith(initialized: true);
  }

  void updateProducts(ProductDetailsResponse productDetailsResponse) {
    final productDetailsList = productDetailsResponse.productDetails;
    state = state.copyWith(
      allProducts: productDetailsList,
      initialized: true,
    );
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        continue;
      }
      if (purchaseDetails.status == PurchaseStatus.purchased) {
        final id = purchaseDetails.productID;
        state = state.copyWith(
          boughtItems: {
            ...state.boughtItems,
            id: true,
          },
        );
        SharedPreferencesAsync().setBool('bought:$id', true);
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
  final Map<String, bool> boughtItems;

  final bool initialized;

  PurchasesState({
    required this.allProducts,
    required this.boughtItems,
    this.initialized = false,
  });

  PurchasesState copyWith({
    List<ProductDetails>? allProducts,
    Map<String, bool>? boughtItems,
    bool? initialized,
  }) {
    return PurchasesState(
      allProducts: allProducts ?? this.allProducts,
      boughtItems: boughtItems ?? this.boughtItems,
      initialized: initialized ?? this.initialized,
    );
  }
}

extension PurchasesHelper on PurchasesState {
  bool? get isAdsRemoved {
    if (!initialized) return null;

    return boughtItems[InAppPurchases._adsProductId] ?? false;
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
