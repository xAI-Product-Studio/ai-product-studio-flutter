import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@module
abstract class AppModule {
  @lazySingleton
  Logger get logger => Logger(
        printer: PrettyPrinter(
          methodCount: 2,
          errorMethodCount: 8,
          lineLength: 120,
          colors: true,
          printEmojis: true,
        ),
        level: const bool.fromEnvironment('dart.vm.product')
            ? Level.warning
            : Level.trace,
      );
}
