abstract class ILogger{
  void v(String tag, String msg, [String tr = ""]);

  void d(String tag, String msg, [String tr = ""]);

  void i(String tag, String msg, [String tr = ""]);

  void w(String tag, {String msg = "", String tr = ""});

  void e(String tag, String msg, [String tr = ""]);
}

class Logger extends ILogger{
  final Function(String tag, String msg, [String tr])? onVerbose;

  final Function(String tag, String msg, [String tr])? onDebug;

  final Function(String tag, String msg, [String tr])? onInfo;

  final Function(String tag, {String msg, String tr})? onWarning;

  final Function(String tag, String msg, [String tr])? onError;


  Logger({this.onVerbose, this.onDebug, this.onInfo, this.onWarning, this.onError});

  @override
  void d(String tag, String msg, [String tr = ""]) {
    onDebug?.call(tag, msg, tr);
  }

  @override
  void e(String tag, String msg, [String tr = ""]) {
    onError?.call(tag, msg, tr);
  }

  @override
  void i(String tag, String msg, [String tr = ""]) {
    onInfo?.call(tag, msg, tr);
  }

  @override
  void v(String tag, String msg, [String tr = ""]) {
    onVerbose?.call(tag, msg, tr);
  }

  @override
  void w(String tag, {String msg = "", String tr = ""}) {
    onWarning?.call(tag, msg: msg, tr: tr);
  }

}