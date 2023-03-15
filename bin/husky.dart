import 'dart:io';

import 'package:husky/husky.dart';

void main(List<String> arguments) async {
  try {
    await Husky().run(arguments);
  } catch (e) {
    String message = 'husky - $e';

    /// If the current stdout terminal supports ANSI escape sequences.
    if (stdout.supportsAnsiEscapes && stdioType(stdout) == StdioType.terminal) {
      message = 'husky - \u001b[31m$e\u001b[0m';
    }
    stderr.writeln(message);
    exit(1);
  }
}
