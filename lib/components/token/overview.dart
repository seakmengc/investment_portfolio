import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:investment_portfolio/components/info_card.dart';
import 'package:investment_portfolio/components/loading.dart';
import 'package:investment_portfolio/components/token/custom_line_chart.dart';
import 'package:investment_portfolio/components/token/info.dart';
import 'package:investment_portfolio/constants.dart';
import 'package:investment_portfolio/helper.dart';

class TokenOverview extends StatefulWidget {
  final String tokenId;

  const TokenOverview(this.tokenId);

  @override
  _TokenOverviewState createState() => _TokenOverviewState();
}

class _TokenOverviewState extends State<TokenOverview>
    with AutomaticKeepAliveClientMixin {
  getTokenInfo() {
    print(Helper.getTokenInfo(
      widget.tokenId,
    ));

    return Helper.retryHttp(Helper.getTokenInfo(
      widget.tokenId,
    ));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SPACE_BETWEEN_ELEMENT,
            Container(
              padding: EdgeInsets.all(7),
              height: 400,
              child: CustomLineChart(
                tokenId: widget.tokenId,
              ),
            ),
            SPACE_BETWEEN_ELEMENT,
            Text(
              'Overview:',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            FutureBuilder(
              future: getTokenInfo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  print(snapshot.hasData);
                  print(snapshot.data);
                  return TokenInfo(
                    (snapshot.data! as List)[0] as Map<String, dynamic>,
                  );
                }

                return Loading();
              },
            ),
          ],
        ),
      ),
    );
  }
}
