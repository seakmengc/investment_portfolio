import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:investment_portfolio/constants.dart';

enum SnackBarType { SUCCESS, ERROR }

class Helper {
  static String generateString(int len) {
    final r = Random();

    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  static showSnackBar({
    required BuildContext context,
    required SnackBarType type,
    String? text,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              type == SnackBarType.SUCCESS
                  ? Icons.check_circle_outline
                  : Icons.highlight_off_outlined,
              color: Colors.white,
              size: 25,
            ),
            WIDTH_F2_BETWEEN_ELEMENT,
            Text(text ?? 'Something went wrong.'),
          ],
        ),
        backgroundColor:
            type == SnackBarType.SUCCESS ? Colors.green : Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  static String formatNumberToHumanString(dynamic number, [int precision = 2]) {
    final nums = [1000000000.0, 1000000.0, 1000.0];
    final words = ['B', 'M', 'K'];

    final num = double.parse(number.toString());
    for (var i = 0; i < nums.length; i++) {
      if (num >= nums[i]) {
        return (num / nums[i]).toStringAsFixed(precision) + words[i];
      }
    }

    return num.toStringAsFixed(precision);
  }

  static String moneyFormat(dynamic money) {
    return new NumberFormat("\$ #,##0.00#######").format(double.parse(money));
  }

  static String getSparkLineInfo(String tokenId, DateTime start,
      {DateTime? end}) {
    return 'https://api.nomics.com/v1/currencies/sparkline?key=e8af4b9a7cf0cb0e13062e48af40fb8636ed3233&ids=' +
        tokenId +
        '&start=' +
        start.toUtc().toIso8601String() +
        (end == null ? '' : '&end=' + end.toUtc().toIso8601String());
  }

  static String getTokenInfo(String tokenId) {
    return 'https://api.nomics.com/v1/currencies/ticker?key=e8af4b9a7cf0cb0e13062e48af40fb8636ed3233&interval=1d&ids=' +
        tokenId;
  }

  static String getTokensInfo(List<String> tokenIds) {
    return 'https://api.nomics.com/v1/currencies/ticker?key=e8af4b9a7cf0cb0e13062e48af40fb8636ed3233&interval=1d&ids=' +
        tokenIds.join(",");
  }

  static Future<List<dynamic>> retryHttp(String path) async {
    int i = 0;
    while (i < 3) {
      try {
        final res = await Dio().get(path);

        return res.data;
      } on DioError catch (err) {
        if (err.response?.statusCode != 429) {
          throw err;
        }

        print(err.response?.statusCode);
        await Future.delayed(Duration(seconds: 2));
      }

      i++;
    }

    return [];
  }
}
