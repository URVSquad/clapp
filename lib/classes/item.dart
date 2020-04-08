class Item{
  String id;
  String title;
  String url;
  String image;
  String description;
  String hashtag;
  Category category;
  String date;

  Item({this.id, this.title, this.url, this.image, this.description,
    this.hashtag, this.category, this.date});

  factory Item.fromJson(Map<String, dynamic> parsedJson){
    return Item(
        id: parsedJson['id'],
        title: parsedJson['title'],
        url: parsedJson['url'],
        image: parsedJson['image'],
        description: parsedJson['description'],
        hashtag: parsedJson['hashtag'],
        date: parsedJson['date']
    );
  }
}

enum Category {
  sports,
  videogames,
  other
}

