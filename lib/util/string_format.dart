String stringFormat(String template, List<String> variables) {
  var exp = RegExp("\{([0-9]+)}");

  Match match;
  while ((match = exp.firstMatch(template)) != null) {
    var variableIndex = int.parse(match.group(1));
    template = template.replaceRange(match.start, match.end, variables[variableIndex]);
  }

  return template;
}
