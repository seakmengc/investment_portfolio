import 'package:flutter/material.dart';
import 'package:investment_portfolio/models/asset.dart';
import 'package:investment_portfolio/models/transac.dart';

class AssetStore extends ChangeNotifier {
  final List<Asset> _assets = [];

  List<Asset> get assets => _assets;

  void addAsset(Asset asset) {
    this._assets.add(asset);

    this.sortAssets();

    notifyListeners();
  }

  void addAssets(Iterable<Asset> assets) {
    this._assets.addAll(assets);

    this.sortAssets();

    notifyListeners();
  }

  void sortAssets() {
    this._assets.sort(
          (a, b) => b.totalPrice.compareTo(a.totalPrice),
        );
  }

  void notify() {
    notifyListeners();
  }

  void addAssetCallback(Asset addAsset) {
    Asset curr;
    bool newly = false;

    final transac = Transac(
      asset: addAsset,
      price: addAsset.price,
      amount: addAsset.amount,
      type: "buy",
    );

    transac.persist();

    try {
      curr = this
          ._assets
          .firstWhere((element) => element.token.id == addAsset.token.id);

      curr.addTransaction(transac);
    } catch (ex) {
      curr = addAsset;
      curr.persist();

      newly = true;
    }

    if (newly) {
      this._assets.add(curr);
    }

    notifyListeners();
  }

  void sellAssetCallback(Transac transac) {
    final Asset? curr = this
        ._assets
        .firstWhere((element) => element.id == transac.asset.id, orElse: null);

    if (curr == null) {
      return;
    }

    transac.persist();
    curr.addTransaction(transac);

    notifyListeners();
  }
}
