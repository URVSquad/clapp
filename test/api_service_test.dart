import 'package:betogether/services/api_service.dart';
import 'package:test/test.dart';

void main() {

  test('Get event', () {
    final apiService = APIService();
    var response = apiService.getActivitiesByCategory("Category 1");
  });
}
