class HistoryModel {
  final String date;
  final String address;

  HistoryModel({
    required this.date,
    required this.address,
  });

  Map<String, dynamic> toJson() => {
        'date': date,
        'address': address,
      };

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      date: json['date'],
      address: json['address'],
    );
  }
}
