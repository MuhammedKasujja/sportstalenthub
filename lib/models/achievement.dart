
class Achievement{
  String startDate;
  String itemId;
  String endDate;
  String achievements;
  String description;

  Achievement({this.itemId,this.startDate, this.endDate, this.achievements, this.description});

  factory Achievement.fromJson(Map<String, dynamic> json){
    return Achievement(
      startDate:json['start_date'],
      itemId: json['item_id'].toString(),
      endDate: json['end_date'],
      achievements: json['achievements'],
      description: json['description'],

    );
  }

}