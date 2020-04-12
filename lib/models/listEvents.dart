import 'package:betogether/models/event.dart';

class ListEvents{
  List<Event> list = new List();

  ListEvents({this.list});

  factory ListEvents.fromJson(Map<String, dynamic> parsedJson){
    var list = parsedJson['events'] as List;
    list = list.map((i) => Event.fromJson(i)).toList();
    return ListEvents(
        list: list
    );
  }

  Event getEvent(int pos){
    return list[pos];
  }

  void removeEvent(int pos){
    list.removeAt(pos);
  }

  void addEvent(Event event){
    list.add(event);
  }

  int getLength (){
    return list.length;
  }
}