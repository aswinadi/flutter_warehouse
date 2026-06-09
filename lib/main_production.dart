import 'core/config/app_config.dart';
import 'main.dart' as app;

void main() {
  AppConfig.initialize(AppEnvironment.production);
  app.main();
}
