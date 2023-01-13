import 'dart:io';

import 'package:husky/husky.dart';
import 'package:husky/src/logger.dart';

void main(List<String> arguments) async {
  try {
    await Husky().run(arguments);
  } catch (e) {
    logger.stderr(logger.ansi.error(e.toString()));
    exit(1);
  }
}
