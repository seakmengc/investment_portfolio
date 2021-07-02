import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageRenderer extends StatelessWidget {
  final String? url;

  const ImageRenderer(this.url);

  @override
  Widget build(BuildContext context) {
    if (this.url == null) {
      return Container(
        height: 30,
        width: 30,
      );
    }

    return Container(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: this.url!.endsWith('.svg')
            ? SvgPicture.network(
                this.url!,
                width: 30,
                fit: BoxFit.cover,
              )
            : CachedNetworkImage(
                imageUrl: this.url!,
                width: 30,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
