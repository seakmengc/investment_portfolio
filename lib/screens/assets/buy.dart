import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:investment_portfolio/components/custom_future_builder.dart';
import 'package:investment_portfolio/components/image_renderer.dart';
import 'package:investment_portfolio/components/loading.dart';
import 'package:investment_portfolio/components/number_form_field.dart';
import 'package:investment_portfolio/components/rounded_button.dart';
import 'package:investment_portfolio/components/token_list_tile.dart';
import 'package:investment_portfolio/constants.dart';
import 'package:investment_portfolio/models/asset.dart';
import 'package:investment_portfolio/models/auth.dart';
import 'package:investment_portfolio/models/token.dart';
import 'package:provider/provider.dart';

class BuyScreeen extends StatefulWidget {
  String? tokenId;

  BuyScreeen({this.tokenId});

  @override
  _BuyScreeenState createState() => _BuyScreeenState();
}

class _BuyScreeenState extends State<BuyScreeen> {
  List<Token> _tokens = [];

  final perPriceController = TextEditingController();
  final amountController = TextEditingController();
  final tokenIdController = TextEditingController();

  final _form = GlobalKey<FormState>();
  final perPriceFocus = FocusNode();

  void addAsset(BuildContext context) async {
    if (!_form.currentState!.validate()) {
      return;
    }

    print(perPriceController.text);
    print(amountController.text);

    final tokenId = tokenIdController.text.toUpperCase();
    Token selectedToken = this._tokens.firstWhere(
          (element) => element.id == tokenId,
          orElse: () => Token(id: tokenId),
        );

    Asset addedAsset = Asset(
      userId: context.read<Auth>().getAuth!.id,
      token: selectedToken,
      price: double.parse(perPriceController.text),
      amount: double.parse(amountController.text),
    );

    Navigator.pop(context, addedAsset);
  }

  searchTokens(pattern) {
    return this._tokens.where(
          (Token element) =>
              element.id.toLowerCase().startsWith(pattern.toLowerCase()),
        );
  }

  getTokens() async {
    return Token.getFromFirestore().then((tokens) {
      if (tokens.isEmpty) {
        return;
      }

      print(tokens.first);
      this._tokens.addAll(tokens);
    });
  }

  @override
  void dispose() {
    tokenIdController.dispose();
    perPriceController.dispose();
    amountController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.tokenId != null) {
      tokenIdController.value = TextEditingValue(text: widget.tokenId!);

      FocusScope.of(context).requestFocus(perPriceFocus);
    }
  }

  buildForm() {
    return Form(
      key: _form,
      child: Column(
        children: [
          buildTokenSelection(),
          SPACE_BETWEEN_ELEMENT,
          NumberFormField(
            label: 'Per Price',
            focusNode: perPriceFocus,
            validator: validatePerPrice,
            controller: perPriceController,
          ),
          SPACE_BETWEEN_ELEMENT,
          NumberFormField(
            label: 'Amount',
            validator: validateAmount,
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
    );
  }

  String? validatePerPrice(String? input) {
    if (input == null) {
      return 'Please provide a per price value.';
    }

    if (double.tryParse(input) == null) {
      return 'Please provide a valid per price value.';
    }

    return null;
  }

  String? validateAmount(String? input) {
    if (input == null) {
      return 'Please provide an amount.';
    }

    double? amount = double.tryParse(input);
    if (amount == null) {
      return 'Please provide a valid amount.';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: buildAppBar,
        body: SingleChildScrollView(
          padding:
              const EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 10),
          child: CustomFutureBuilder(
            futureFn: () => getTokens(),
            successWidget: (_, __) => buildForm(),
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
