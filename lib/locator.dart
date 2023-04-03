import 'package:flashcards/features/auth/services/authentication_service.dart';
import 'package:flashcards/features/game/services/game_service.dart';
import 'package:flashcards/features/sets/services/set_upsert_service.dart';
import 'package:flashcards/features/sets/services/sets_manager_service.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;
void setupLocator() {
  getIt.registerSingleton<AuthenticationService>(AuthenticationService());
  getIt.registerSingleton<SetsManagerService>(SetsManagerService());
  getIt.registerFactory(() => SetUpsertService());
  getIt.registerFactory(() => GameService());
}
