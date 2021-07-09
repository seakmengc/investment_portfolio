import 'package:flutter/material.dart';
import 'package:investment_portfolio/models/asset.dart';
import 'package:investment_portfolio/models/transac.dart';

class AssetStore extends ChangeNotifier {
  final List<Asset> _assets = [];

  get assets => _assets;

  set addAsset(Asset asset) {
    this._assets.add(asset);

    notifyListeners();
  }

  set addAssets(Iterable<Asset> assets) {
    this._assets.addAll(assets);

    notifyListeners();
  }

  addAssetCallback(Asset addAsset) async {
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

  sellAssetCallback(Transac transac) {
    final curr =
        this._assets.firstWhere((element) => element.id == transac.asset.id);

    transac.persist();
    curr.addTransaction(transac);

    notifyListeners();
  }
}
