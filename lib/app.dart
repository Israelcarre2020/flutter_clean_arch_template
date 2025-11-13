import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gist/core/config/app_config.dart';
import 'package:gist/core/config/app_theme.dart';
import 'package:gist/core/config/environment_manager.dart';
import 'package:gist/core/di/injection_container.dart';
import 'package:gist/core/l10n/app_localizations.dart';
import 'package:gist/core/l10n/locale_cubit.dart';
import 'package:gist/core/router/app_router.dart';
import 'package:gist/core/theme/theme_cubit.dart';
import 'package:google_fonts/google_fonts.dart';

/// Main application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<ThemeCubit>()),
        BlocProvider.value(value: getIt<LocaleCubit>()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return ListenableBuilder(
                listenable: getIt<EnvironmentManager>(),
                builder: (context, _) {
                  final config = getIt<AppConfig>();

                  return MaterialApp.router(
                    title: config.appName,
                    debugShowCheckedModeBanner: false,
                    routerConfig: AppRouter.router,

                    // Localization
                    locale: locale,
                    localizationsDelegates: const [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: LocaleCubit.supportedLocales,

                    // Theme
                    themeMode: themeMode,
                    theme: AppTheme.lightTheme.copyWith(
                      textTheme: GoogleFonts.poppinsTextTheme(
                        Theme.of(context).textTheme,
                      ),
                    ),
                    darkTheme: AppTheme.darkTheme.copyWith(
                      textTheme: GoogleFonts.poppinsTextTheme(
                        Theme.of(context).textTheme,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
