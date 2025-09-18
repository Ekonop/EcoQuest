import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eco_quest/viewmodels/profile_cubit.dart';
import 'package:eco_quest/models/user.dart';
import 'package:eco_quest/widgets/eco_glass_card.dart';
import 'package:eco_quest/theme/app_colors.dart';
import 'package:eco_quest/viewmodels/theme_cubit.dart';

class ProfileView extends StatelessWidget {
  static const routeName = '/profile';
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Container(
      decoration: BoxDecoration(gradient: AppColors.themedBackground(brightness)),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is ProfileLoaded) {
            final User user = state.user;
            return Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(title: const Text('Profile'), backgroundColor: Colors.black12, elevation: 0),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EcoGlassCard(
                      child: Row(
                        children: [
                          CircleAvatar(radius: 32, child: Text(user.name[0])),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.name, style: Theme.of(context).textTheme.titleLarge),
                              Text(user.role, style: Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: EcoGlassCard(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${user.points}', style: Theme.of(context).textTheme.headlineSmall),
                                const Text('Points'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: EcoGlassCard(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${user.challengesCompleted}', style: Theme.of(context).textTheme.headlineSmall),
                                const Text('Challenges'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text('Impact Stats', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    EcoGlassCard(
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _impactChip(Icons.water_drop, 'Water Saved'),
                          _impactChip(Icons.eco, 'CO₂ Reduced'),
                          _impactChip(Icons.lightbulb, 'Energy Saved'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Badges', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    EcoGlassCard(
                      child: Wrap(
                        spacing: 8,
                        children: user.badges.map((b) => Chip(label: Text(b))).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Settings', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    EcoGlassCard(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.color_lens_outlined),
                            title: const Text('Theme'),
                            subtitle: BlocBuilder<ThemeCubit, ThemeState>(
                              builder: (_, s) => Text(s.mode.name),
                            ),
                            onTap: () => _showThemeBottomSheet(context),
                          ),
                          const Divider(height: 0),
                          ListTile(
                            leading: const Icon(Icons.notifications),
                            title: const Text('Notifications'),
                            trailing: Switch(value: true, onChanged: (_) {}),
                          ),
                          const Divider(height: 0),
                          ListTile(
                            leading: const Icon(Icons.lock),
                            title: const Text('Privacy'),
                            onTap: () {},
                          ),
                          const Divider(height: 0),
                          ListTile(
                            leading: const Icon(Icons.help_outline),
                            title: const Text('Help'),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is ProfileError) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(child: Text('Error: ${state.message}')),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _impactChip(IconData icon, String label) {
    return Chip(avatar: Icon(icon, size: 18), label: Text(label));
  }

  void _showThemeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        final themeCubit = context.read<ThemeCubit>();
        final current = themeCubit.state.mode;
        Widget option(ThemeMode mode, IconData icon, String label) {
          final selected = current == mode;
            return ListTile(
              leading: Icon(icon, color: selected ? AppColors.leaf : null),
              title: Text(label),
              trailing: selected ? const Icon(Icons.check, color: AppColors.leaf) : null,
              onTap: () {
                themeCubit.setMode(mode);
                Navigator.pop(context);
              },
            );
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: EcoGlassCard(
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ListTile(
                  title: Text('Select Theme', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Divider(height: 0),
                option(ThemeMode.system, Icons.auto_mode, 'System Default'),
                option(ThemeMode.light, Icons.light_mode, 'Light'),
                option(ThemeMode.dark, Icons.dark_mode, 'Dark'),
                const SizedBox(height: 4),
              ],
            ),
          ),
        );
      },
    );
  }
}
