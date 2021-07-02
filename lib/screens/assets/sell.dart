import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:investment_portfolio/components/number_form_field.dart';
import 'package:investment_portfolio/components/rounded_button.dart';
import 'package:investment_portfolio/components/token_list_tile.dart';
import 'package:investment_portfolio/constants.dart';
import 'package:investment_portfolio/models/asset.dart';
import 'package:investment_portfolio/models/token.dart';
import 'package:investment_portfolio/models/transac.dart';

class SellScreen extends StatefulWidget {
  final List<Asset> assets;

  const SellScreen({required this.assets});

  @override
  _SellScreenState createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  final perPriceController = TextEditingController();
  final amountController = TextEditingController();
  final assetIdController = TextEditingController();

  final _form = GlobalKey<FormState>();

  Asset? _selected;

  void sellAsset(BuildContext context) async {
    if (!_form.currentState!.validate()) {
      return;
    }

    print(perPriceController.text);
    print(amountController.text);

    final asset = widget.assets
        .firstWhere((element) => element.id == assetIdController.text);

    if (double.parse(amountController.text) > asset.amount) {
      print("Over amount error");
      return;
    }

    final transac = Transac(
      asset: asset,
      price: double.parse(perPriceController.text),
      amount: double.parse(amountController.text),
      type: "sell",
    );

    Navigator.pop(context, transac);
  }

  searchTokens(pattern) {
    return widget.assets.where(
      (Asset element) =>
          element.id.toLowerCase().startsWith(pattern.toLowerCase()),
    );
  }

  @override
  void dispose() {
    super.dispose();

    assetIdController.dispose();
    perPriceController.dispose();
    amountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: buildAppBar,
        body: SingleChildScrollView(
          padding:
              const EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 10),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _form,
            child: Column(
              children: [
                buildTokenSelection(),
                SPACE_BETWEEN_ELEMENT,
                NumberFormField(
                  label: 'Per Price',
                  validator: (String? input) {
                    if (input == null) {
                      return 'Please provide a per price value.';
                    }

                    if (double.tryParse(input) == null) {
                      return 'Please provide a valid per price value.';
                    }

                    return null;
                  },
                  controller: perPriceController,
                ),
                SPACE_BETWEEN_ELEMENT,
                NumberFormField(
                  label: 'Amount',
                  validator: (String? input) {
                    if (input == null) {
                      return 'Please provide an amount.';
                    }

                    double? amount = double.tryParse(input);
                    if (amount == null) {
                      return 'Please provide a valid amount.';
                    }

                    if (_selected == null) {
                      return 'Please select a token first.';
                    }

                    if (amount > _selected!.amount) {
                      return 'Amount can\'t exceed ${_selected!.amount}.';
                    }

                    return null;
                  },
                  controller: amountController,
                ),
                SPACE_BETWEEN_ELEMENT,
                SPACE_BETWEEN_ELEMENT,
                RoundedButton(
                  text: 'Sell',
                  textColor: Colors.white,
                  height: 50,
                  minWidth: double.infinity,
                  onPressed: () => sellAsset(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TypeAheadField<Object> buildTokenSelection() {
    return TypeAheadField(
      hideSuggestionsOnKeyboardHide: false,
      textFieldConfiguration: TextFieldConfiguration(
        autofocus: true,
        decoration: InputDecoration(border: OutlineInputBorder()),
        controller: assetIdController,
      ),
      suggestionsCallback: (pattern) {
        return searchTokens(pattern);
      },
      itemBuilder: (context, suggestion) {
        if (suggestion == null) {
          return ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Error'),
          );
        }

        final asset = suggestion as Asset;

        return TokenListTile(token: asset.token);
      },
      onSuggestionSelected: (suggestion) {
        final asset = suggestion as Asset;

        assetIdController.value = TextEditingValue(text: asset.id);

        _selected = asset;
      },
    );
  }

  List<Widget> buildAppBar(context, innerBoxIsScrolled) {
    return [
      SliverAppBar(
        flexibleSpace: FlexibleSpaceBar(
          title: Text(
            'Sell Your Asset',
          ),
        ),
        floating: false,
        pinned: true,
        expandedHeight: 150,
      ),
    ];
  }
}
