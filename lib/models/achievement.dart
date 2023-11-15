class Achievement {
  String startDate;
  String itemId;
  String endDate;
  String achievements;
  String description;

  Achievement({
    required this.itemId,
    required this.startDate,
    required this.endDate,
    required this.achievements,
    required this.description,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      startDate: json['start_date'],
      itemId: json['item_id'].toString(),
      endDate: json['end_date'],
      achievements: json['achievements'],
      description: json['description'],
    );
  }
}
