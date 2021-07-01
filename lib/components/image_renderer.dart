import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageRenderer extends StatelessWidget {
  final String? url;

  const ImageRenderer(this.url);

  @override
  Widget build(BuildContext context) {
    if (this.url == null) {
      return Container();
    }

    return this.url!.endsWith('.svg')
        ? SvgPicture.network(
            this.url!,
            width: 30,
          )
        : Image.network(
            this.url!,
            width: 30,
          );
  }
}
