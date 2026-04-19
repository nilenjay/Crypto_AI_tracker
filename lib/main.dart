import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';
import 'core/app_theme.dart';
import 'routes/app_router.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'features/market/data/market_api_service.dart';
import 'features/market/presentation/bloc/market_bloc.dart';
import 'features/market/presentation/bloc/coin_detail_bloc.dart';
import 'features/portfolio/data/repositories/portfolio_repository.dart';
import 'features/portfolio/presentation/bloc/portfolio_bloc.dart';
import 'features/portfolio/presentation/bloc/portfolio_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();

  final authRepository = AuthRepository();
  final marketApiService = MarketApiService();
  final portfolioRepository = PortfolioRepository();
  
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: marketApiService),
        RepositoryProvider.value(value: portfolioRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(authRepository: authRepository),
          ),
          BlocProvider(
            create: (context) => MarketBloc(apiService: marketApiService),
          ),
          BlocProvider(
            create: (context) => CoinDetailBloc(apiService: marketApiService),
          ),
          BlocProvider(
            create: (context) => PortfolioBloc(
              portfolioRepository: portfolioRepository,
              marketApiService: marketApiService,
            )..add(PortfolioSubscriptionRequested()),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter.createRouter(context.read<AuthBloc>());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Crypto AI Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: _router,
    );
  }
}

