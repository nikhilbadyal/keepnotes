library random_date;

import 'dart:math';

// class to generate a random date
class RandomDate {
  /// generate random date for given options
  DateTime random() {
    final random = Random();

    /// generate year
    final randYear = _generateRandomYear();

    /// generate random month
    final randMonthInt = random.nextInt(12) + 1;

    /// generate random day
    final randDay = random.nextInt(_maxDays(randYear, randMonthInt));

    /// this is a valid day, month and year.
    return DateTime(randYear, randMonthInt, randDay);
  }

  /// generate random year for given range and flag to include/exclude leap years
  int _generateRandomYear() {
    final year = 1980 + Random().nextInt(2022 - 1980);
    return year;
  }

  /// max number of days for given year and month
  int _maxDays(final int year, final int month) {
    final maxDaysMonthList = <int>[4, 6, 9, 11];
    if (month == 2) {
      return _isLeapYear(year) ? 29 : 28;
    } else {
      return maxDaysMonthList.contains(month) ? 30 : 31;
    }
  }

  /// is year a leap
  bool _isLeapYear(final int year) =>
      (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));
}
