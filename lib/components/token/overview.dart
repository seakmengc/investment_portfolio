import 'package:flutter/material.dart';

class TokenOverview extends StatefulWidget {
  final String tokenId;

  const TokenOverview(this.tokenId);

  @override
  _TokenOverviewState createState() => _TokenOverviewState();
}

class _TokenOverviewState extends State<TokenOverview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(widget.tokenId),
    );
  }
}
