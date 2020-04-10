import 'package:betogether/models/activity.dart';

class ListActivities{
  List<Activity> list = new List();

  ListActivities({this.list});

  factory ListActivities.fromJson(Map<String, dynamic> parsedJson){
    var list = parsedJson['activities'] as List;
    list = list.map((i) => Activity.fromJson(i)).toList();
    print(list);
    return ListActivities(
        list: list
    );
  }

  Activity getActivity(int pos){
    return list[pos];
  }

  void removeActivity(int pos){
    list.removeAt(pos);
  }
  void addActivity(Activity activity){
    list.add(activity);
  }

  int getLength (){
    return list.length;
  }
}