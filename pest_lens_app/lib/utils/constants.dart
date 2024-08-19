final DateTime defaultStartDate = DateTime.now()
    .subtract(const Duration(days: 3))
    .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);

final DateTime defaultEndDate = DateTime(
    DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59);
