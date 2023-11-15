class SportJson {
  String name;
  List<String> positions;

  SportJson({required this.name, required this.positions});

  factory SportJson.fromJson(Map<String, dynamic> json) {
    return SportJson(
      name: json['name'],
      positions: json['positions'].cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = this.name;
    data['positions'] = this.positions;
    return data;
  }
}
