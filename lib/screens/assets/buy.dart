import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:investment_portfolio/components/asset_list_tile.dart';
import 'package:investment_portfolio/components/number_form_field.dart';
import 'package:investment_portfolio/components/rounded_button.dart';
import 'package:investment_portfolio/constants.dart';
import 'package:investment_portfolio/models/asset.dart';
import 'package:investment_portfolio/models/auth.dart';
import 'package:investment_portfolio/models/token.dart';

import 'package:provider/provider.dart';

class BuyScreeen extends StatefulWidget {
  @override
  _BuyScreeenState createState() => _BuyScreeenState();
}

class _BuyScreeenState extends State<BuyScreeen> {
  List<Token> _tokens = [
    // Token(
    //   id: 'BTC',
    //   logoUrl: BTC_URL,
    // ),
    // Token(
    //   id: 'ADA',
    //   logoUrl: ADA_URL,
    // ),
    // Token(
    //   id: 'ETH',
    //   logoUrl: ETH_URL,
    // ),
  ];

  final perPriceController = TextEditingController();
  final amountController = TextEditingController();
  final tokenIdController = TextEditingController();

  void addAsset(BuildContext context) async {
    print(perPriceController.text);
    print(amountController.text);

    Asset addedAsset = Asset(
      userId: context.read<Auth>().getAuth!.id,
      token: new Token(id: tokenIdController.text.toUpperCase()),
      price: double.parse(perPriceController.text),
      amount: double.parse(amountController.text),
    );

    await addedAsset.persist();

    Navigator.pop(context, addedAsset);
  }

  searchTokens(pattern) {
    return this._tokens.where(
          (Token element) =>
              element.id.toLowerCase().startsWith(pattern.toLowerCase()),
        );
  }

  getTokens() async {
    final tokens = await Token.getFromFirestore();

    if (tokens.isEmpty) {
      return;
    }

    print(tokens.first);
    setState(() {
      this._tokens.addAll(tokens);
    });
  }

  @override
  void initState() {
    super.initState();

    getTokens();

    // this._selectedToken = this._tokens[0];
  }

  @override
  void dispose() {
    super.dispose();

    tokenIdController.dispose();
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
          child: Column(
            children: [
              TypeAheadField(
                hideSuggestionsOnKeyboardHide: false,
                textFieldConfiguration: TextFieldConfiguration(
                  autofocus: true,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  controller: tokenIdController,
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

                  return TokenListTile(token: suggestion as Token);
                },
                onSuggestionSelected: (suggestion) {
                  print("SELECTED");
                  print(suggestion);
                  final token = suggestion as Token;

                  tokenIdController.value = TextEditingValue(text: token.id);
                },
              ),
              SPACE_BETWEEN_ELEMENT,
              NumberFormField(
                label: 'Per Price',
                controller: perPriceController,
              ),
              SPACE_BETWEEN_ELEMENT,
              NumberFormField(
                label: 'Amount',
                controller: amountController,
              ),
              SPACE_BETWEEN_ELEMENT,
              SPACE_BETWEEN_ELEMENT,
              RoundedButton(
                text: 'Add',
                textColor: Colors.white,
                height: 50,
                minWidth: double.infinity,
                onPressed: () => addAsset(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildAppBar(context, innerBoxIsScrolled) {
    return [
      SliverAppBar(
        flexibleSpace: FlexibleSpaceBar(
          title: Text(
            'Add Your Asset',
          ),
        ),
        floating: false,
        pinned: true,
        expandedHeight: 150,
      ),
    ];
  }
}

class TokenListTile extends StatelessWidget {
  final Token token;

  const TokenListTile({required this.token});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: token.hasSvgLogo
          ? SvgPicture.network(
              token.logoUrl,
              width: 30,
              fit: BoxFit.cover,
            )
          : CachedNetworkImage(
              imageUrl: token.logoUrl,
              width: 30,
              fit: BoxFit.cover,
            ),
      title: Text(token.id),
    );
  }
}
