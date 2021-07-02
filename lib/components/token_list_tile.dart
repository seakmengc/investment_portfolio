import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:investment_portfolio/components/image_renderer.dart';
import 'package:investment_portfolio/models/token.dart';

class TokenListTile extends StatelessWidget {
  final Token token;

  const TokenListTile({required this.token});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ImageRenderer(token.logoUrl),
      title: Text(token.id),
    );
  }
}
