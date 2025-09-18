import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eco_quest/viewmodels/dashboard_cubit.dart';
import 'package:eco_quest/widgets/eco_glass_card.dart';
import 'package:eco_quest/theme/app_colors.dart';

class DashboardView extends StatelessWidget {
  static const routeName = '/dashboard';
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is DashboardLoaded) {
          final user = state.user;
          final level = (user.points ~/ 1000) + 1;
          final progress = (user.points % 1000) / 1000;
          final brightness = Theme.of(context).brightness;
          return Container(
            decoration: BoxDecoration(gradient: AppColors.themedBackground(brightness)),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: const Text('Dashboard'),
                backgroundColor: Colors.black12,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () => Navigator.pushNamed(context, '/profile'),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EcoGlassCard(
                      height: 160,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Level $level', style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 4),
                          Text('${user.points} Points'),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 8,
                              backgroundColor: Colors.white12,
                              color: Colors.greenAccent,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text('${(progress * 100).toInt()}% to next level', style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text('Ongoing Challenges', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    ...state.ongoingChallenges.map((c) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: EcoGlassCard(
                        height: 88,
                        child: ListTile(
                          title: Text(c.title),
                          subtitle: Text('Due ${c.dueDate.month}/${c.dueDate.day}'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.pushNamed(context, '/challenge_details', arguments: c),
                        ),
                      ),
                    )),
                    const SizedBox(height: 24),
                    Text('Quick Access', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: EcoGlassCard(
                            height: 70,
                            child: InkWell(
                              onTap: () => Navigator.pushNamed(context, '/modules'),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [Icon(Icons.book), SizedBox(width: 8), Text('Modules')],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: EcoGlassCard(
                            height: 70,
                            child: InkWell(
                              onTap: () => Navigator.pushNamed(context, '/leaderboard'),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [Icon(Icons.leaderboard), SizedBox(width: 8), Text('Leaderboard')],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (state is DashboardError) {
          return Scaffold(
            body: Center(child: Text('Error: ${state.message}')),
          );
        }
        return const SizedBox.shrink();
      },
    );
}
}