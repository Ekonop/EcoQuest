import 'package:flutter/material.dart';
import 'package:eco_quest/views/home_shell.dart';
import 'package:eco_quest/repositories/local_storage_service.dart';
import 'package:eco_quest/widgets/eco_glass_card.dart';
import 'package:eco_quest/theme/app_colors.dart';

class OnboardingView extends StatelessWidget {
  static const routeName = '/onboarding';
  const OnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.onboardingGradient),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: EcoGlassCard(
          width: 340,
            height: 380,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('EcoQuest', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(
                'Your Journey to a Greener World',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _pill(context, 'Learn'),
                  const SizedBox(width: 8),
                  _pill(context, 'Act'),
                  const SizedBox(width: 8),
                  _pill(context, 'Impact'),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.rocket_launch),
                label: const Text('Begin Your Quest'),
                onPressed: () async {
                  final storage = LocalStorageService();
                  await storage.setHasSeenOnboarding();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, HomeShell.routeName);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pill(BuildContext context, String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: Text(text, style: Theme.of(context).textTheme.labelLarge),
      );
}
