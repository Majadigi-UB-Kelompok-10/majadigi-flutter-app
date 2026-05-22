/// Supposedly you should NOT store sensitive value in here
/// and should use some kind of obfuscation, but below is safe
/// to read for public. Is it hardcoded? yes, but it's also configurable here
class Credentials {
  const Credentials._();

  // Used for Data Sources
  static const String baseUrl = 'http://10.0.2.2:$port/api/v1';
  static const String port = '8888';
}