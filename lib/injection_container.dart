// import 'package:tara_driver_application/presentation/blocs/coffee_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

void init() {
  // Blocs
  // sl.registerFactory(() => CoffeeBloc(sl()));

  // Use cases
  // sl.registerLazySingleton(() => GetAllCoffee(sl()));

  // Repositories
  // sl.registerLazySingleton<CoffeeRepository>(() => CoffeeRepositoryImpl(sl()));

  // Data sources
  // sl.registerLazySingleton(() => CoffeeRemoteDataSource(sl()));

  // External
  sl.registerLazySingleton(() => http.Client());
}
