class Sport {
  bool isSelected;
  String name;
  String? sportId;

  Sport({
    required this.name,
     this.sportId,
     this.isSelected = false,
  });

  //Checking if the tow Sports are Identical basing on SportId
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Sport &&
          runtimeType == other.runtimeType &&
          sportId == other.sportId;

  @override
  int get hashCode => name.hashCode ^ sportId.hashCode;

  factory Sport.fromJson(Map<String, dynamic> json) {
    return new Sport(
      name: json['sport_name'],
      sportId: json['sport_id'].toString(),
      // isSelected: json['isSelected'] == 0 ? true : false,
      isSelected: json['isSelected'] == null ? false : true,
    );
  }

  factory Sport.fromMap(Map<String, dynamic> json) {
    return new Sport(
      name: json['sport_name'],
      sportId: json['sport_id'].toString(),
      isSelected: json['isSelected'] == 0 ? true : false,
      //isSelected: json['isSelected'] ,
    );
  }

  Map<String, dynamic> toMap() => {
        "sport_id": sportId,
        "sport_name": name,
        "isSelected": isSelected == true ? 0 : 1,
      };
}
