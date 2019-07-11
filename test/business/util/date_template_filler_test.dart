import 'package:newsletter_reader/business/util/date_template_filler.dart';
import 'package:test_api/test_api.dart';

main() {
  test('Test fillStringWithDate() assert correct formatted output', () {
    var template = "Today is {dd.MM.yyyy} {HH:mm} [other variable]";

    var result = new DateTemplateFiller().fillStringWithDate(template, DateTime(2019, 07, 11, 21, 11, 00));

    expect(result, "Today is 11.07.2019 21:11 [other variable]");
  });

  test('Test fillStringWithDate() throws exception when invalid format', () {
    var template = "Today is {invalid format}";

    expect(() => new DateTemplateFiller().fillStringWithDate(template, DateTime(2019, 07, 11, 21, 11, 00)),
        throwsA(TypeMatcher<DateFormatException>()));
  });
}
