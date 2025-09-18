import 'package:flutter/material.dart';
import 'package:eco_quest/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:eco_quest/views/onboarding_view.dart';
import 'package:eco_quest/views/dashboard_view.dart';
import 'package:eco_quest/views/modules_view.dart';
import 'package:eco_quest/views/leaderboard_view.dart';
import 'package:eco_quest/views/challenge_details_view.dart';
import 'package:eco_quest/views/profile_view.dart';
import 'package:eco_quest/views/home_shell.dart';
import 'package:eco_quest/repositories/user_repository.dart';
import 'package:eco_quest/repositories/challenge_repository.dart';
import 'package:eco_quest/repositories/module_repository.dart';
import 'package:eco_quest/repositories/leaderboard_repository.dart';
import 'package:eco_quest/viewmodels/dashboard_cubit.dart';
import 'package:eco_quest/viewmodels/modules_cubit.dart';
import 'package:eco_quest/viewmodels/leaderboard_cubit.dart';
import 'package:eco_quest/viewmodels/challenge_details_cubit.dart';
import 'package:eco_quest/viewmodels/profile_cubit.dart';
import 'package:eco_quest/repositories/local_storage_service.dart';
import 'package:eco_quest/viewmodels/theme_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final LocalStorageService _storageService;
  late Future<bool> _hasSeenOnboardingFuture;

  @override
  void initState() {
    super.initState();
    _storageService = LocalStorageService();
    _hasSeenOnboardingFuture = _storageService.hasSeenOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasSeenOnboardingFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
        final hasSeen = snapshot.data ?? false;
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider(create: (_) => UserRepository()),
            RepositoryProvider(create: (_) => ChallengeRepository()),
            RepositoryProvider(create: (_) => ModuleRepository()),
            RepositoryProvider(create: (_) => LeaderboardRepository()),
            RepositoryProvider.value(value: _storageService),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => DashboardCubit(
                  userRepository: context.read<UserRepository>(),
                  challengeRepository: context.read<ChallengeRepository>(),
                )..loadDashboard(),
              ),
              BlocProvider(
                create: (context) => ModulesCubit(
                  context.read<ModuleRepository>(),
                )..loadModules(),
              ),
              BlocProvider(
                create: (context) => LeaderboardCubit(
                  context.read<LeaderboardRepository>(),
                )..loadLeaderboard(),
              ),
              BlocProvider(
                create: (context) => ProfileCubit(
                  context.read<UserRepository>(),
                )..loadProfile(),
              ),
              BlocProvider(create: (_) => ChallengeDetailsCubit()),
              BlocProvider(
                create: (_) => ThemeCubit(context.read<LocalStorageService>())..load(),
              ),
            ],
            child: BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, themeState) {
                return AnimatedTheme(
                  duration: const Duration(milliseconds: 300),
                  data: themeState.mode == ThemeMode.dark
                      ? AppTheme.dark()
                      : themeState.mode == ThemeMode.light
                          ? AppTheme.light()
                          : MediaQuery.of(context).platformBrightness == Brightness.dark
                              ? AppTheme.dark()
                              : AppTheme.light(),
                  child: MaterialApp(
                    title: 'EcoQuest',
                    debugShowCheckedModeBanner: false,
                    theme: AppTheme.light(),
                    darkTheme: AppTheme.dark(),
                    themeMode: themeState.mode,
                    initialRoute: hasSeen ? '/home' : '/onboarding',
                    routes: {
                      '/onboarding': (context) => const OnboardingView(),
                      '/home': (context) => const HomeShell(),
                      '/dashboard': (context) => const DashboardView(),
                      '/modules': (context) => const ModulesView(),
                      '/leaderboard': (context) => const LeaderboardView(),
                      '/challenge_details': (context) => const ChallengeDetailsView(),
                      '/profile': (context) => const ProfileView(),
                    },
                    onGenerateRoute: (settings) {
                      if (settings.name != null && settings.name!.startsWith('/home/')) {
                        final segments = settings.name!.split('/');
                        int initialIndex = 0;
                        if (segments.length > 2) {
                          switch (segments[2]) {
                            case 'modules':
                              initialIndex = 1;
                              break;
                            case 'leaderboard':
                              initialIndex = 2;
                              break;
                            case 'profile':
                              initialIndex = 3;
                              break;
                            default:
                              initialIndex = 0;
                          }
                        }
                        return MaterialPageRoute(
                          builder: (_) => HomeShell(initialIndex: initialIndex),
                          settings: settings,
                        );
                      }
                      return null;
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// Removed legacy MyHomePage demo widget.
