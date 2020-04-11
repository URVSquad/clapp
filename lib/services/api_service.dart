import 'dart:convert';
import 'package:betogether/models/activity.dart';
import 'package:betogether/models/event.dart';
import 'package:betogether/models/listActivities.dart';
import 'package:betogether/services/cognito_service.dart';
import 'package:betogether/services/pools_vars.dart' as global;
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


  Future<String> postActivity(Activity activity) async {
    var url = rootUrl + "/activities";
    var payload = activity.toJson();

    var response = await http.post(url,
        headers: {'auth': buildAuthenticationHeader()},
        body: payload
    );

    return response.body;
  }

  Future<String> getEvents() async {
    var url = rootUrl + "/events";
    var response = await http.get(url);
    return response.body;
  }

  Future<String> postEvent(Event event) async {
    var url = rootUrl + "/activities";
    var payload = event.toJson();

    var response = await http.post(url,
        headers: {'auth': buildAuthenticationHeader()},
        body: payload
    );

    return response.body;
  }

  String buildAuthenticationHeader() {
    _userService.getIdToken().then((value) {
      return "Authorization: $value";
    });

    return null;
  }
}
