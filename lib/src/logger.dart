import 'package:cli_util/cli_logging.dart';

class HuskyLogger extends StandardLogger {
  String get prefix => 'husky - ';

  @override
  void write(String message) {
    super.write(prefix + message);
  }

  @override
  void stderr(String message) {
    super.stderr(prefix + message);
  }

  @override
  void stdout(String message) {
    super.stdout(prefix + message);
  }

  @override
  Progress progress(String message) {
    return super.progress(prefix + message);
  }
}

Logger get logger => HuskyLogger();
