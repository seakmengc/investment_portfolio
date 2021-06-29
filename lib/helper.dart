class Helper {
  static String formatNumberToHumanString(double num) {
    final nums = [1000000000.0, 1000000.0, 1000.0];
    final words = ['B', 'M', 'K'];

    for (var i = 0; i < nums.length; i++) {
      if (num >= nums[i]) {
        return (num / nums[i]).toStringAsFixed(2) + words[i];
      }
    }

    return num.toStringAsFixed(2);
  }

  static String getSparkLineInfo(String tokenId, DateTime start,
      {DateTime? end}) {
    return 'https://api.nomics.com/v1/currencies/sparkline?key=e8af4b9a7cf0cb0e13062e48af40fb8636ed3233&ids=' +
        tokenId +
        '&start=' +
        start.toUtc().toIso8601String() +
        (end == null ? '' : end.toUtc().toIso8601String());
  }

  static String getTokenInfo(String tokenId) {
    return 'https://api.nomics.com/v1/currencies/ticker?key=e8af4b9a7cf0cb0e13062e48af40fb8636ed3233&interval=1d&ids=' +
        tokenId;
  }
}
