import 'package:get_it/get_it.dart';

import '../core/services/dio_services.dart';
import '../features/auth/login/data/datasources/data_source.dart';
import '../features/auth/login/data/models/graphql_queries.dart';
import '../features/auth/login/data/repositories/repository_impl.dart';
import '../features/auth/login/domain/repositories/repository.dart';
import '../features/auth/login/domain/usecases/usecase.dart';
import '../features/auth/login/presentation/manager/controller.dart';
import '../features/auth/login/presentation/manager_bloc/controller.dart'
    show LoginBloc;
import '../features/auth/login/presentation/manager_old/controller.dart'
    show LoginCubitOld;
import '../features/cart/presentation/controller/controller.dart';
import '../features/category/presentation/controller/controller.dart';
import '../features/change_language/presentation/controller/controller.dart';
import '../features/home/presentation/controller/controller.dart';
import '../features/layout/presentation/controller/controller.dart';
import '../features/my_account/presentation/controller/controller.dart';
import '../features/order_history/presentation/controller/controller.dart';
import '../features/product_details/presentation/controller/controller.dart';
import '../features/product_list/presentation/controller/controller.dart';
import '../features/profile_address/presentation/controller/address_cubit.dart';
import '../core/services/api_client.dart';
import '../features/auth/login_rules/data/datasources/login_data_source.dart';
import '../features/auth/login_rules/data/repositories/login_repository_impl.dart';
import '../features/auth/login_rules/domain/repositories/login_repository.dart';
import '../features/auth/login_rules/domain/usecases/login_usecase.dart';
import '../features/auth/login_rules/presentation/bloc/login_bloc.dart';
import '../features/splash/presentation/controller/controller.dart';
import '../features/wishlist/presentation/controller/controller.dart';

final GetIt sl = GetIt.instance;

class ServicesLocator {
  void initGitIt() {
    // Core Services
    sl.registerLazySingleton<DioServices>(() => DioServices());
    sl.registerLazySingleton<ApiClient>(() => ApiClient());
    sl.registerLazySingleton<GraphQLQueries>(() => GraphQLQueries());

    // Login Feature
    sl.registerLazySingleton<LoginDataSource>(() => LoginDataSourceImpl());
    sl.registerLazySingleton<LoginRepository>(
      () => LoginRepositoryImpl(sl<LoginDataSource>()),
    );
    sl.registerLazySingleton<LoginUsecase>(
      () => LoginUseCaseImpl(sl<LoginRepository>()),
    );

    // Features Controllers
    sl.registerFactory<SplashCubit>(() => SplashCubit());
    sl.registerFactory<LanguageCubit>(
      () => LanguageCubit()..changeLanguage('ar'),
    );
    sl.registerLazySingleton<LayoutCubit>(() => LayoutCubit());
    sl.registerFactory<LoginCubit>(() => LoginCubit(sl<LoginUsecase>()));
    sl.registerLazySingleton<CategoryCubit>(() => CategoryCubit());

    // sl.registerFactory<ProductCubit>(() => ProductCubit()); // Class not found in codebase

    sl.registerLazySingleton<WishlistCubit>(() => WishlistCubit());
    sl.registerFactory<ProductListCubit>(() => ProductListCubit());
    sl.registerFactory<ProductDetailsCubit>(() => ProductDetailsCubit());
    sl.registerFactory<MyAccountController>(() => MyAccountController());
    sl.registerFactory<OrderHistoryController>(() => OrderHistoryController());
    sl.registerLazySingleton<HomeCubit>(() => HomeCubit());

    sl.registerLazySingleton<CartCubit>(() => CartCubit());

    // Address Management
    sl.registerFactory<AddressCubit>(() => AddressCubit());
    sl.registerFactory<LoginCubitOld>(() => LoginCubitOld());
    sl.registerFactory<LoginBloc>(() => LoginBloc());

    // Login Rules Feature
    sl.registerLazySingleton<LoginRulesDataSource>(
      () => LoginRulesDataSourceImpl(
        apiClient: sl<ApiClient>(),
        queries: sl<GraphQLQueries>(),
      ),
    );
    sl.registerLazySingleton<LoginRulesRepository>(
      () => LoginRulesRepositoryImpl(dataSource: sl<LoginRulesDataSource>()),
    );
    sl.registerLazySingleton<LoginRulesUseCase>(
      () => LoginRulesUseCaseImpl(repository: sl<LoginRulesRepository>()),
    );
    sl.registerFactory<LoginRulesBloc>(
      () => LoginRulesBloc(loginUseCase: sl<LoginRulesUseCase>()),
    );
  }
}
