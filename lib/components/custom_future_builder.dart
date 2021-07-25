import 'package:flutter/material.dart';
import 'package:investment_portfolio/components/loading.dart';

class CustomFutureBuilder extends StatefulWidget {
  final Future Function() futureFn;
  final Widget Function(BuildContext, AsyncSnapshot<Object?>) successWidget;

  const CustomFutureBuilder(
      {required this.futureFn, required this.successWidget});

  @override
  _CustomFutureBuilderState createState() => _CustomFutureBuilderState();
}

class _CustomFutureBuilderState extends State<CustomFutureBuilder> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.futureFn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return widget.successWidget(context, snapshot);
        }

        if (snapshot.hasError) {
          return Center(
            child: Text("Error: " + snapshot.error.toString()),
          );
        }

        return Loading();
      },
    );
  }
}
