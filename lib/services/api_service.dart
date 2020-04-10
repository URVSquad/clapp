import 'package:betogether/models/activity.dart';
import 'package:betogether/models/event.dart';
import 'package:betogether/models/listActivities.dart';
import 'package:http/http.dart' as http;
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';

const rootUrl = "http://localhost:3000/dev";

class APIService {
  AwsSigV4Client awsSigV4Client;

  APIService();

  Future<String> getActivities() async {
    var url = rootUrl + "/activities";
    var response = await http.get(url);
    String jsonString = response.body;
    ListActivities list = PlaceList.fromJson(jsonDecode(jsonString));
    this.list=list;
    return response.body;

  }

  Future<String> postActivity(Activity activity) async {
    var url = rootUrl + "/activities";
    var payload = activity.toJson();
    var response = await http.post(url, body: payload);
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
    var response = await http.post(url, body: payload);
    return response.body;
  }
}


