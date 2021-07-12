import 'package:flutter/material.dart';
import 'package:investment_portfolio/components/loading.dart';

class LoadingOverlay extends StatefulWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({required this.isLoading, required this.child});

  @override
  _LoadingOverlayState createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<LoadingOverlay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          widget.child,
          widget.isLoading ? buildLoading(context) : Container(),
        ],
      ),
    );
  }

  Container buildLoading(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.5),
      ),
      child: Loading(),
    );
  }
}
