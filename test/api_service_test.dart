import 'package:betogether/services/api_service.dart';
import 'package:test/test.dart';

void main() {

  test('Get event', () {
    final apiService = APIService(null);
    var response = apiService.getActivities();
    expect(response, completion(equals(true)));
  });
}
