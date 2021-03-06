import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:investment_portfolio/components/image_renderer.dart';
import 'package:investment_portfolio/components/loading.dart';
import 'package:investment_portfolio/components/token/overview.dart';
import 'package:investment_portfolio/components/token/trending.dart';
import 'package:investment_portfolio/constants.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:investment_portfolio/helper.dart';

class MarketScreen extends StatefulWidget {
  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen>
    with AutomaticKeepAliveClientMixin {
  final PagingController<int, TokenViewListTile> _pagingController =
      PagingController(firstPageKey: 0);

  final Map<int, List<TokenViewListTile>> _tokenViewList = {};

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });

    super.initState();
  }

  fetchPage(int pageKey) {
    try {
      if (_tokenViewList.containsKey(pageKey)) {
        return Future.value(_tokenViewList[pageKey]!);
      }

      return Helper.retryHttp(INDEX_URL + pageKey.toString()).then(
        (res) {
          _tokenViewList[pageKey] =
              res.map((e) => TokenViewListTile(e)).toList();
          // final tokenViews = res.map((e) => TokenViewListTile(e)).toList();

          if (res.length < 50) {
            _pagingController.appendLastPage(_tokenViewList[pageKey]!);
          } else {
            final nextPageKey = pageKey + 1;
            _pagingController.appendPage(_tokenViewList[pageKey]!, nextPageKey);
          }
        },
      );
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Markets'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: fetchPage(0),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox(
                    child: PagedListView<int, TokenViewListTile>(
                      pagingController: _pagingController,
                      addAutomaticKeepAlives: true,
                      builderDelegate:
                          PagedChildBuilderDelegate<TokenViewListTile>(
                        itemBuilder: (context, item, index) => item,
                      ),
                    ),
                  );
                }

                return Loading();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class TokenViewListTile extends StatelessWidget {
  final Map<String, dynamic> token;

  const TokenViewListTile(this.token);

  getLogoWidget() {
    if (token['logo_url'] == '') {
      return Container(
        height: 50,
        width: 30,
      );
    }

    return Container(
      width: 30,
      child: token['logo_url'].toString().endsWith('.svg')
          ? SvgPicture.network(
              token['logo_url'],
              width: 30,
              fit: BoxFit.cover,
            )
          : CachedNetworkImage(
              imageUrl: token['logo_url'],
              width: 30,
              fit: BoxFit.cover,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: ListTile(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MarketTokenOverview(token: token),
            ),
          );
        },
        leading: getLogoWidget(),
        title: Text(token['id']),
        subtitle: Text(
          'Vol. ' +
              Helper.formatNumberToHumanString(
                double.parse(token['1d']['volume'].toString()),
              ),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              new NumberFormat('\$ #,##0.00')
                  .format(double.parse(token['price'])),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Trending(
              double.parse(token['1d']['price_change_pct']),
            ),
          ],
        ),
      ),
    );
  }
}

class MarketTokenOverview extends StatelessWidget {
  const MarketTokenOverview({
    Key? key,
    required this.token,
  }) : super(key: key);

  final Map<String, dynamic> token;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImageRenderer(token['logo_url']),
            SizedBox(width: 7),
            Text(token['id']),
          ],
        ),
      ),
      body: TokenOverview(token['id']),
    );
  }
}
