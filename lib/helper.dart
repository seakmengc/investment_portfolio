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
}
