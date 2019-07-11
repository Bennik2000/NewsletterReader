import 'package:newsletter_reader/data/network/http_utils.dart';
import 'package:test_api/test_api.dart';

main() {
  test('Test formatDateForHeader() assert correct format', () {
    var result = HttpUtils.formatDateForHeader(DateTime.utc(2015, 10, 21, 7, 28, 00, 00, 00));
    expect(result, "Wed, 21 Oct 2015 07:28:00 GMT");
  });

  test('Test parseDateOfHeader() assert correct date', () {
    var result = HttpUtils.parseDateOfHeader("Wed, 21 Oct 2015 07:28:00 GMT");
    expect(result, DateTime.utc(2015, 10, 21, 7, 28, 00, 00, 00));
  });
}
