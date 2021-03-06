import 'categories.dart';
class Event {
  int id;
  String title;
  String url;
  String image;
  String description;
  String hashtag;
  String category;
  String date;
  DateTime start;
  DateTime end;
  int votes;
  String user;

  Event({this.id, this.title, this.image, this.description,
    this.category, this.start,this.end, this.votes, this.url, this.hashtag, this.user});

  factory Event.fromJson(Map<String, dynamic> parsedJson){
    return Event(
        id: parsedJson['id'],
        title: parsedJson['title'],
        url: parsedJson['url'],
        image: parsedJson['image'],
        description: parsedJson['description'],
        hashtag: parsedJson['hashtag'],
        start: DateTime.parse(parsedJson['event_start']),
        end: DateTime.parse(parsedJson['event_end']),
        votes: parsedJson['votes'],
        category: parsedJson['category'],
        user: parsedJson['user'],
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
        'event_start': start.toString(),
        'event_end': start.toString(),
        'category': category,
        'user': user,
        'hashtag': hashtag,
      };
}