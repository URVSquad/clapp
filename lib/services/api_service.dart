import 'dart:convert';
import 'package:betogether/models/activity.dart';
import 'package:betogether/models/event.dart';
import 'package:betogether/models/listActivities.dart';
import 'package:betogether/models/listEvents.dart';
import 'package:betogether/services/cognito_service.dart';
import 'package:betogether/services/pools_vars.dart' as global;
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

// TODO proteger maybe
// TODO handle not internet
const rootUrl = "https://edrxliv83i.execute-api.eu-west-2.amazonaws.com/dev";

class APIService {
  UserService _userService = new UserService(global.userPool);

  Future<ListActivities> getActivities() async {
    var url = rootUrl + "/activities";
    var response = await http.get(url);
    ListActivities list = ListActivities.fromJson(jsonDecode(response.body));
    return list;
  }

  Future<ListActivities> getActivitiesByCategory(String categoryName) async {
    var url = rootUrl + "/activities/category?category="+categoryName;
    var response = await http.get(url);
    ListActivities list = ListActivities.fromJson(jsonDecode(response.body));
    return list;
  }


  Future<int> postActivity(Activity activity) async {
    await _userService.init();
    var url = rootUrl + "/activities";
    var payload = activity.toJson();

    var auth = await buildAuthenticationHeader();
    var user = await _userService.getCurrentUser();
    payload['id'] = '1';
    payload['date'] = '1';
    payload['user'] = user.sub;
    print(payload);

    var response = await http.post(url,
        headers: {'Authorization': auth},
        body: json.encode(payload)
    );

    print(response.statusCode);
    print(response.body);

    return jsonDecode(response.body)['status'];
  }

  Future<ListEvents> getEvents() async {
    var url = rootUrl + "/events";
    var response = await http.get(url);
    ListEvents list = ListEvents.fromJson(jsonDecode(response.body));
    return list;
  }

  Future<ListEvents> getEventsByCategory(String categoryName) async {
    var url = rootUrl + "/events/category?category="+categoryName;
    var response = await http.get(url);
    ListEvents list = ListEvents.fromJson(jsonDecode(response.body));
    return list;
  }

  Future<int> postEvent(Event event) async {
    await _userService.init();
    var url = rootUrl + "/events";
    var payload = event.toJson();

    var auth = await buildAuthenticationHeader();
    var user = await _userService.getCurrentUser();
    payload['id'] = '1';
    payload['date'] = '1';
    payload['user'] = user.sub;
    print(payload);

    var response = await http.post(url,
        headers: {'Authorization': auth},
        body: json.encode(payload)
    );

    print(response.statusCode);
    print(response.body);

    return jsonDecode(response.body)['status'];
  }

  Future<String> buildAuthenticationHeader() async {
     await _userService.init();
     var auth = await _userService.getIdToken();

     return auth;
  }
}
