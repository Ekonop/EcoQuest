import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:glassmorphism/glassmorphism.dart';
import 'package:eco_quest/models/challenge.dart';
import 'package:eco_quest/viewmodels/challenge_details_cubit.dart';
import 'package:eco_quest/widgets/eco_glass_card.dart';
import 'package:eco_quest/theme/app_colors.dart';

class ChallengeDetailsView extends StatelessWidget {
  static const routeName = '/challenge_details';
  const ChallengeDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retrieve the passed Challenge argument
    final challenge = ModalRoute.of(context)!.settings.arguments as Challenge;
    // Load details into cubit
    context.read<ChallengeDetailsCubit>().loadDetails(challenge);
    final brightness = Theme.of(context).brightness;
    return Container(
      decoration: BoxDecoration(gradient: AppColors.themedBackground(brightness)),
      child: BlocBuilder<ChallengeDetailsCubit, ChallengeDetailsState>(
        builder: (context, state) {
          if (state is ChallengeDetailsLoaded) {
            final c = state.challenge;
            final daysLeft = c.dueDate.difference(DateTime.now()).inDays;
            return Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(title: Text(c.title), backgroundColor: Colors.black12, elevation: 0),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EcoGlassCard(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(c.description, style: Theme.of(context).textTheme.bodyLarge),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('Objectives', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(c.description),
                    const SizedBox(height: 20),
                    Text('Potential Impact', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    const Text('Help restore forests and improve air quality.'),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: EcoGlassCard(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Column(
                              children: [
                                Text('Planted', style: Theme.of(context).textTheme.bodyMedium),
                                const SizedBox(height: 4),
                                Text('${c.progress}', style: Theme.of(context).textTheme.titleLarge),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: EcoGlassCard(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Column(
                              children: [
                                Text('Days Left', style: Theme.of(context).textTheme.bodyMedium),
                                const SizedBox(height: 4),
                                Text('$daysLeft', style: Theme.of(context).textTheme.titleLarge),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: SizedBox(
                        width: 220,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text('Participate'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
