import 'package:get_it/get_it.dart';
import 'package:weather/app/data/data_sources/local/prefrancemanager.dart';
import 'package:weather/app/data/data_sources/remote/WeatherRepository.dart'; 
import 'package:weather/app/presentation/ui/main/mainviewmodel.dart';
import 'package:weather/app/shared/core/network/dio_manager.dart';

import '../../domain/repositories/weather_repository_impl.dart';
import '../ui/spalsh/splashviewmodel.dart';

final GetIt getit = GetIt.instance;
void setup() {
  print('Setting up dependencies');
  getit.registerLazySingleton(() => PreferenceManager());
  getit.registerLazySingleton(() => DioManager());
  setuprepo();
  setupViewModels();
}

void setuprepo() {
  print('Registering repositories');
  getit.registerSingleton<WeatherRepository>(
    WeatherRepositoryImpl(
      getit.get<DioManager>(),
    ),
  );
}


void setupViewModels() {
  getit.registerFactory(() => SplashViewModel(
      getit.get<PreferenceManager>(), getit.get<WeatherRepository>()));
  getit.registerFactory(() => MainViewModel(
        getit.get<PreferenceManager>(),
      ));
}

