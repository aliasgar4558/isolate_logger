import 'package:isolate_logger/src/services/log_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

export "package:path_provider_platform_interface/path_provider_platform_interface.dart";

class FakePathProvider extends PathProviderPlatform {
  @override
  Future<String?> getTemporaryPath() async {
    return 'temp-dir';
  }

  @override
  Future<String> getApplicationSupportPath() async {
    return 'app-support-dir';
  }
}

class MockLogService extends Mock implements ILogService {}
