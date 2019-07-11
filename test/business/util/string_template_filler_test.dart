import 'package:newsletter_reader/business/util/string_template_filler.dart';
import 'package:test_api/test_api.dart';

void main() {
  test('Test fillStringWithVariables() assert correct templated output', () {
    var template = "Hello [name], the weather is [weather]";

    var variables = {
      "name": "Joe",
      "age": "26",
      "weather": "sunny",
    };

    var result = new StringTemplateFiller().fillStringWithVariables(template, variables);

    expect(result, "Hello Joe, the weather is sunny");
  });

  test('Test fillStringWithVariables() throws exception when variable not specified', () {
    var template = "Hello [name], the weather is [weather]";

    var variables = {
      "name": "Joe",
    };

    expect(() => new StringTemplateFiller().fillStringWithVariables(template, variables),
        throwsA(const TypeMatcher<VariableMissingException>()));
  });
}
