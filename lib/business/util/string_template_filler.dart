class StringTemplateFiller {
  String fillStringWithVariables(String input, Map<String, String> variables) {
    RegExp exp = new RegExp("\\[(.+?)\\]");

    Match match;
    while ((match = exp.firstMatch(input)) != null) {
      String variableName = match.group(1);
      String variableValue = "";

      if (variables.containsKey(variableName)) {
        variableValue = variables[variableName];
      } else {
        throw new VariableMissingException(variableName);
      }

      input = input.replaceRange(match.start, match.end, variableValue);
    }

    return input;
  }
}

class VariableMissingException with Exception {
  final String variableName;

  VariableMissingException(this.variableName);
}
