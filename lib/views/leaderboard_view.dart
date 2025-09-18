import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eco_quest/viewmodels/leaderboard_cubit.dart';
import 'package:eco_quest/widgets/eco_glass_card.dart';
import 'package:eco_quest/theme/app_colors.dart';

class LeaderboardView extends StatelessWidget {
  static const routeName = '/leaderboard';
  const LeaderboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LeaderboardCubit>();
    final brightness = Theme.of(context).brightness;
    return Container(
      decoration: BoxDecoration(gradient: AppColors.themedBackground(brightness)),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Leaderboard'),
            backgroundColor: Colors.black12,
            elevation: 0,
            bottom: TabBar(
              onTap: (index) {
                final scopes = ['overall', 'school', 'college'];
                cubit.loadLeaderboard(scope: scopes[index]);
              },
              tabs: const [
                Tab(text: 'Overall'),
                Tab(text: 'School'),
                Tab(text: 'College'),
              ],
            ),
          ),
          body: BlocBuilder<LeaderboardCubit, LeaderboardState>(
            builder: (context, state) {
              if (state is LeaderboardLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is LeaderboardLoaded) {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.entries.length,
                  itemBuilder: (context, index) {
                    final entry = state.entries[index];
                    return EcoGlassCard(
                      child: ListTile(
                        leading: Text('#${entry.rank}', style: Theme.of(context).textTheme.titleLarge),
                        title: Text(entry.userName),
                        trailing: Text('${entry.points} pts'),
                      ),
                    );
                  },
                );
              } else if (state is LeaderboardError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
