import 'categories.dart';

class Event {
  String id;
  String title;
  String url;
  String image;
  String description;
  String hashtag;
  Category category;
  String date;
  String start;
  int duration;

  Event({this.id, this.title, this.url, this.image, this.description,
    this.hashtag, this.category, this.date, this.start,this.duration});

  factory Event.fromJson(Map<String, dynamic> parsedJson){
    return Event(
        id: parsedJson['id'],
        title: parsedJson['title'],
        url: parsedJson['url'],
        image: parsedJson['image'],
        description: parsedJson['description'],
        hashtag: parsedJson['hashtag'],
        date: parsedJson['date'],
        start: parsedJson['start'],
        duration: parsedJson['date']
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
        'event_start': start,
        'event_end': start
      };
}