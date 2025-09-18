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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = LocalStorageService();
  await storage.init();
  final hasSeen = await storage.hasSeenOnboarding();
  runApp(MyApp(storage: storage, hasSeenOnboarding: hasSeen));
}

class MyApp extends StatelessWidget {
  final LocalStorageService storage;
  final bool hasSeenOnboarding;
  const MyApp({super.key, required this.storage, required this.hasSeenOnboarding});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => UserRepository()),
        RepositoryProvider(create: (_) => ChallengeRepository()),
        RepositoryProvider(create: (_) => ModuleRepository()),
        RepositoryProvider(create: (_) => LeaderboardRepository()),
        RepositoryProvider.value(value: storage),
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
            create: (_) => ThemeCubit(storage)..load(),
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            final resolvedTheme = switch (themeState.mode) {
              ThemeMode.dark => AppTheme.dark(),
              ThemeMode.light => AppTheme.light(),
              _ => WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark
                  ? AppTheme.dark()
                  : AppTheme.light(),
            };
            return AnimatedTheme(
              duration: const Duration(milliseconds: 300),
              data: resolvedTheme,
              child: MaterialApp(
                title: 'EcoQuest',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light(),
                darkTheme: AppTheme.dark(),
                themeMode: themeState.mode,
                initialRoute: hasSeenOnboarding ? '/home' : '/onboarding',
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
                builder: (context, child) {
                  if (themeState.error != null) {
                    return Stack(
                      children: [
                        if (child != null) child,
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Material(
                            color: Colors.redAccent.withOpacity(0.9),
                            child: SafeArea(
                              top: false,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Row(
                                  children: [
                                    const Icon(Icons.warning_amber_rounded, color: Colors.white),
                                    const SizedBox(width: 8),
                                    const Expanded(
                                      child: Text(
                                        'Theme preferences failed to load. Using fallback.',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return child ?? const SizedBox.shrink();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

// Removed legacy MyHomePage demo widget.
