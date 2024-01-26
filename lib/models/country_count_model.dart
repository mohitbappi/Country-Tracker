class CountryCountModel {
  final String name;
  int count;

  CountryCountModel({
    required this.name,
    required this.count,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'count': count,
      };

  factory CountryCountModel.fromJson(Map<String, dynamic> json) {
    return CountryCountModel(
      name: json['name'],
      count: json['count'],
    );
  }
}
