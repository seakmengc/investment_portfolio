import 'package:flutter/material.dart';
import 'package:investment_portfolio/components/number_form_field.dart';
import 'package:investment_portfolio/components/rounded_button.dart';
import 'package:investment_portfolio/constants.dart';
import 'package:investment_portfolio/models/asset.dart';
import 'package:investment_portfolio/models/token.dart';

class BuyScreeen extends StatefulWidget {
  @override
  _BuyScreeenState createState() => _BuyScreeenState();
}

class _BuyScreeenState extends State<BuyScreeen> {
  List<Token> _tokens = [
    Token(
      id: 'BTC',
      symbol: 'BTC',
      logoUrl: BTC_URL,
    ),
    Token(
      id: 'ADA',
      symbol: 'ADA',
      logoUrl: ADA_URL,
    ),
    Token(
      id: 'ETH',
      symbol: 'ETH',
      logoUrl: ETH_URL,
    ),
  ];

  late Token _selectedToken;

  final perPriceController = TextEditingController();
  final amountController = TextEditingController();
  final tokenIdController = TextEditingController();

  List<DropdownMenuItem> buildTokens() {
    // getAllTokens();
    // print('Get tokens');
    return this
        ._tokens
        .map(
          (token) => DropdownMenuItem(
            value: token.id,
            child: ListTile(
              leading: Image.network(
                token.logoUrl!,
                width: 30,
                fit: BoxFit.cover,
              ),
              title: Text(token.symbol),
            ),
          ),
        )
        .toList();
  }

  void addAsset(context) {
    print(perPriceController.text);
    print(amountController.text);
    print(this._selectedToken.toString());

    Asset addAsset = Asset(
      token: this._selectedToken,
      price: double.parse(perPriceController.text),
      amount: double.parse(amountController.text),
    );

    Navigator.pop(context, addAsset);
  }

  @override
  void initState() {
    super.initState();
    this._selectedToken = this._tokens[0];
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
              Container(
                height: 60,
                child: buildDropDownBtn(),
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

  DropdownButton buildDropDownBtn() {
    return DropdownButton(
      elevation: 3,
      items: buildTokens(),
      onChanged: (newValue) {
        setState(() {
          this._selectedToken = this
              ._tokens
              .firstWhere((Token element) => element.id == newValue);
        });
      },
      isExpanded: true,
      value: this._selectedToken.id,
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
