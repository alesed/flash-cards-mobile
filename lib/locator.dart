import 'package:flashcards/features/auth/services/authentication_service.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;
void setupLocator() {
  getIt.registerSingleton<AuthenticationService>(AuthenticationService());
}
