import 'package:sth/api/urls.dart';

class Post{
  String postId;
  String title;
  String date;
  String imageUrl;
  String description;
  String category;
  
  Post({this.title,this.description, this.imageUrl, this.category, this.date, this.postId});

  factory Post.fromJson(Map<String, dynamic> json){
     return Post(
       title: json['post_title'],
       description: json['brief_description'],
       imageUrl: Urls.POST_IMAGE_LINKS + json['post_image'],
      //  category: json['article_category'],
       date: json['created_on'],
       postId: json['post_id'],
    );
  }
}