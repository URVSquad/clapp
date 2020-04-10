import 'package:betogether/models/activity.dart';
import 'package:betogether/models/event.dart';
import 'package:http/http.dart' as http;
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';

const rootUrl = "http://localhost:3000/dev";

class APIService {
  APIService(this.awsSigV4Client);

  AwsSigV4Client awsSigV4Client;

  Future<String> getActivities() async {
    var url = rootUrl + "/activities";
    var response = await http.get(url);
    return response.body;
  }

  Future<String> postActivity(Activity activity) async {
    var url = rootUrl + "/activities";
    var payload = activity.toJson();

    var request = new SigV4Request(awsSigV4Client,
        method: 'POST',
        path: url,
        body: payload
    );

    var response = await http.post(
        request.url,
        headers: request.headers,
        body: request.body
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

    var request = new SigV4Request(awsSigV4Client,
        method: 'POST',
        path: url,
        body: payload
    );

    var response = await http.post(
        request.url,
        headers: request.headers,
        body: request.body
    );

    return response.body;
  }
}
