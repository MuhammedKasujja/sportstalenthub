class SportJson {
  String name;
  List<String> positions;

  SportJson({this.name, this.positions});

  SportJson.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    positions = json['positions'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['positions'] = this.positions;
    return data;
  }
}