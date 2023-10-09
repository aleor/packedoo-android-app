class Price {
  String currency;
  double value;

  get formattedValue =>
      value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2);

  Price.fromMap(Map<dynamic, dynamic> map) {
    if (map == null) return;

    currency = map['currency'];
    value = map['value'] != null ? double.parse(map['value'].toString()) : 0;
  }

  Price({this.value = 0, this.currency = 'RUB'});
}
