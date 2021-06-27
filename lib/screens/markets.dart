import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:investment_portfolio/components/token/overview.dart';
import 'package:investment_portfolio/constants.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:investment_portfolio/helper.dart';

class MarketScreen extends StatefulWidget {
  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  List<Map<String, dynamic>> tokens = [];

  final PagingController<int, TokenViewListTile> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });

    super.initState();
  }

  fetchPage(int pageKey) {
    try {
      return Dio().get(INDEX_URL + pageKey.toString()).then(
        (value) {
          final res = value.data as List<dynamic>;
          final tokenViews = res.map((e) => TokenViewListTile(e)).toList();

          if (res.length < 100) {
            _pagingController.appendLastPage(tokenViews);
          } else {
            final nextPageKey = pageKey + 1;
            _pagingController.appendPage(tokenViews, nextPageKey);
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Markets'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: FutureBuilder(
          future: fetchPage(1),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return PagedListView<int, TokenViewListTile>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<TokenViewListTile>(
                  itemBuilder: (context, item, index) => item,
                ),
              );
            }

            return Center(
              child: Text('Loading...'),
            );
          },
        ),
      ),
    );
  }
}

class TokenViewListTile extends StatelessWidget {
  final Map<String, dynamic> token;

  const TokenViewListTile(this.token);

  getLogoWidget() {
    if (token['logo_url'] == '') {
      return Container();
    }

    return token['logo_url'].toString().endsWith('.svg')
        ? SvgPicture.network(
            token['logo_url'],
            width: 30,
            fit: BoxFit.cover,
          )
        : CachedNetworkImage(
            imageUrl: token['logo_url'],
            width: 30,
            fit: BoxFit.cover,
          );
  }

  buildTrending(double percentages) {
    bool isUp = !percentages.isNegative;
    Color color = isUp ? Colors.green : Colors.red;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isUp ? Icons.trending_up : Icons.trending_down,
          color: color,
        ),
        WIDTH_BETWEEN_ELEMENT,
        Text(
          percentages.toStringAsFixed(2) + '%',
          style: TextStyle(
            color: color,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 75,
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                body: TokenOverview(token['id']),
              ),
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
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              new NumberFormat('\$ #,##0.00')
                  .format(double.parse(token['price'])),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            buildTrending(
              double.parse(token['1d']['price_change_pct']) * 100.0,
            ),
          ],
        ),
      ),
    );
  }
}
