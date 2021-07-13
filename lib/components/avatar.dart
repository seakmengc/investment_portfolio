import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String? url;

  const Avatar({this.url});

  @override
  Widget build(BuildContext context) {
    return this.url != null
        ? CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(this.url!),
            radius: 50.0,
          )
        : Container(
            width: 100,
            child: Icon(Icons.person),
          );
  }
}
