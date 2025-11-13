import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gist/core/config/app_config.dart';
import 'package:gist/core/config/environment_manager.dart';
import 'package:gist/core/di/injection_container.dart';
import 'package:gist/core/l10n/app_localizations.dart';
import 'package:gist/core/l10n/locale_cubit.dart';
import 'package:gist/core/router/app_router.dart';
import 'package:gist/core/theme/theme_cubit.dart';
import 'package:gist/features/demo/presentation/bloc/joke_bloc.dart';
import 'package:gist/features/demo/presentation/bloc/joke_event.dart';
import 'package:gist/features/demo/presentation/bloc/joke_state.dart';
import 'package:gist/gen/assets.gen.dart';
import 'package:go_router/go_router.dart';

/// Demo screen to showcase joke fetching and theme switching
class DemoScreen extends StatelessWidget {
  const DemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => getIt<JokeBloc>()..add(const GetRandomJokeEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.demoScreen),
          actions: [
            // Language toggle button
            IconButton(
              icon: const Icon(Icons.language),
              onPressed: () {
                context.read<LocaleCubit>().toggleLocale();
              },
              tooltip: l10n.language,
            ),
            // Theme toggle button
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, themeMode) {
                return IconButton(
                  icon: Icon(
                    themeMode == ThemeMode.dark
                        ? Icons.light_mode
                        : Icons.dark_mode,
                  ),
                  onPressed: () {
                    context.read<ThemeCubit>().toggleTheme();
                  },
                  tooltip: l10n.toggleTheme,
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<JokeBloc, JokeState>(
          builder: (context, state) {
            if (state is JokeLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is JokeError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.error,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<JokeBloc>().add(
                            const GetRandomJokeEvent(),
                          );
                        },
                        icon: const Icon(Icons.refresh),
                        label: Text(l10n.tryAgain),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is JokeLoaded) {
              final joke = state.joke;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Environment Selector Card
                    _EnvironmentSelectorCard(),
                    const SizedBox(height: 24),

                    // Flutter Logo Image
                    Center(
                      child: Hero(
                        tag: 'flutter_logo',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Assets.images.flutterImage.image(
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.category, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  joke.type.toUpperCase(),
                                  style: Theme.of(context).textTheme.labelLarge
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              joke.setup,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              joke.punchline,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<JokeBloc>().add(
                          const GetRandomJokeEvent(),
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n.getAnotherJoke),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        context.push(
                          AppRoutes.detail,
                          extra: {'joke': joke.fullJoke},
                        );
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: Text(l10n.viewDetails),
                    ),
                  ],
                ),
              );
            }

            return Center(child: Text(l10n.noJokeLoaded));
          },
        ),
      ),
    );
  }
}

class _EnvironmentSelectorCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: getIt<EnvironmentManager>(),
      builder: (context, _) {
        final envManager = getIt<EnvironmentManager>();
        final config = getIt<AppConfig>();

        return Card(
          child: ExpansionTile(
            leading: const Icon(Icons.settings),
            title: Text(
              'Environment',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              '${envManager.currentEnvironment.displayName} - ${config.appName}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Environment',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...Environment.values.map((env) {
                      final isSelected = envManager.currentEnvironment == env;
                      return InkWell(
                        onTap: () async {
                          await _changeEnvironment(context, env);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      env.displayName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                    ),
                                    Text(
                                      env.name.toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      'Current Configuration',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildConfigRow('App Name', config.appName),
                    _buildConfigRow('API Base URL', config.apiBaseUrl),
                    _buildConfigRow(
                      'Logging',
                      config.enableLogger ? 'Enabled' : 'Disabled',
                    ),
                    _buildConfigRow(
                      'Environment',
                      envManager.currentEnvironment.name.toUpperCase(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConfigRow(String label, String value) {
    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  '$label:',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _changeEnvironment(
    BuildContext context,
    Environment newEnv,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) =>
          const Center(child: CircularProgressIndicator()),
    );

    try {
      await getIt<EnvironmentManager>().setEnvironment(newEnv);
      await reloadDependenciesForEnvironment();

      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Environment changed to ${newEnv.displayName}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error changing environment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
