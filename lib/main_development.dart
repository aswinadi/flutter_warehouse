import 'core/config/app_config.dart';
import 'main.dart' as app;

void main() {
  AppConfig.initialize(AppEnvironment.development);
  app.main();
}
