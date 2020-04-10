import 'package:http/http.dart' as http;
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';

const rootUrl = "http://localhost:3000/dev";

class APIService {
  AwsSigV4Client awsSigV4Client;

  APIService(this.awsSigV4Client);

  Future<String> getActivities() async {
    var url = rootUrl + "/activities";
    var response = await http.get(url);
    return response.body;
  }
}
