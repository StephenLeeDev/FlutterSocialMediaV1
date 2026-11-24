/// Address of the NestJS server, always ending with "/".
///
/// Set at build/run time instead of being written into the code (it used to
/// be a fixed IP of an old home network, 192.168.1.251):
///
///   flutter run --dart-define=SERVER_URL=http://192.168.0.10:3001/
///
/// Without the option the iOS simulator default is used: the simulator runs
/// on the same Mac as the local server, so "localhost" reaches it.
/// (An Android emulator needs http://10.0.2.2:3001/, a real phone the Mac's
/// IP address on the local network.)
const baseUrl = String.fromEnvironment(
  'SERVER_URL',
  defaultValue: 'http://localhost:3001/',
);
