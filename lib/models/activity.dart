import 'categories.dart';

class Activity{
  int id;
  String title;
  String url;
  String image;
  String description;
  String hashtag;
  String category;
  String date;
  int votes;
  String user;

  Activity({this.id, this.title, this.image, this.description,
    this.category, this.url, this.hashtag, this.date, this.votes, this.user});

  factory Activity.fromJson(Map<String, dynamic> parsedJson){
    return Activity(
        id: parsedJson['id'],
        title: parsedJson['title'],
        url: parsedJson['url'],
        image: parsedJson['image'],
        description: parsedJson['description'],
        date: parsedJson['creation'],
        category: parsedJson['category'],
        votes: parsedJson['votes'],
        hashtag: parsedJson['hashtag'],
        user: parsedJson['user']
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'title': title,
        'url': url,
        'image': image,
        'description': description,
        'date': date,
        'category': category,
        'hashtag': hashtag,
        'user': user
      };
}