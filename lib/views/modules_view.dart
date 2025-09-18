import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eco_quest/viewmodels/modules_cubit.dart';
import 'package:eco_quest/widgets/eco_glass_card.dart';
import 'package:eco_quest/theme/app_colors.dart';

class ModulesView extends StatelessWidget {
  static const routeName = '/modules';
  const ModulesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Container(
      decoration: BoxDecoration(gradient: AppColors.themedBackground(brightness)),
      child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Modules'), backgroundColor: Colors.black12, elevation: 0),
      body: BlocBuilder<ModulesCubit, ModulesState>(
        builder: (context, state) {
          if (state is ModulesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ModulesLoaded) {
            final modules = state.modules;
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: modules.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final m = modules[index];
                return EcoGlassCard(
                  child: ListTile(
                    title: Text(m.title, style: Theme.of(context).textTheme.titleLarge),
                    subtitle: Text(m.description),
                    trailing: Text('${m.pointsEarned} pts', style: Theme.of(context).textTheme.bodyMedium),
                    onTap: () {
                      // TODO: Handle module tap
                    },
                  ),
                );
              },
            );
          } else if (state is ModulesError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    ),
    );
  }
}
