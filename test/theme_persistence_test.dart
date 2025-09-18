import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eco_quest/repositories/local_storage_service.dart';
import 'package:eco_quest/viewmodels/theme_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eco_quest/theme/app_theme.dart';

// A minimal app harness to test theme persistence behavior.
class _Harness extends StatelessWidget {
  final ThemeCubit themeCubit;
  const _Harness(this.themeCubit);
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: themeCubit,
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: state.mode,
            home: Scaffold(
              body: Center(child: Text('mode:${state.mode.name}')), // Inspectable text
            ),
          );
        },
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Theme persistence', () {
    testWidgets('round trip light -> dark -> reload keeps mode', (tester) async {
      final storage = LocalStorageService();
      await storage.init();
      await storage.clearThemeModeForTest();

      // Initial cubit creation (should default to system)
      final cubit1 = ThemeCubit(storage);
      await tester.pumpWidget(_Harness(cubit1));
      expect(find.textContaining('mode:system'), findsOneWidget);

      // Set to light
      await cubit1.setMode(ThemeMode.light);
      await tester.pump();
      expect(find.textContaining('mode:light'), findsOneWidget);

      // Set to dark
      await cubit1.setMode(ThemeMode.dark);
      await tester.pump();
      expect(find.textContaining('mode:dark'), findsOneWidget);

      // Dispose old cubit and recreate to simulate app restart
      await cubit1.close();
      final cubit2 = ThemeCubit(storage);
      await tester.pumpWidget(_Harness(cubit2));
      // Because we stored dark previously, synchronous constructor should pick it up.
      expect(find.textContaining('mode:dark'), findsOneWidget);
    });
  });
}
