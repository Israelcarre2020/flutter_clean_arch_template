// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Gist';

  @override
  String get demoScreen => 'Pantalla de Demostración';

  @override
  String get detailScreen => 'Pantalla de Detalles';

  @override
  String get getAnotherJoke => 'Obtener Otro Chiste';

  @override
  String get viewDetails => 'Ver Detalles';

  @override
  String get goBack => 'Volver';

  @override
  String get error => 'Error';

  @override
  String get tryAgain => 'Intentar de Nuevo';

  @override
  String get jokeDetails => 'Detalles del Chiste';

  @override
  String get noJokeProvided => 'No se proporcionó ningún chiste';

  @override
  String get noJokeLoaded => 'No se cargó ningún chiste';

  @override
  String get toggleTheme => 'Cambiar Tema';

  @override
  String get loading => 'Cargando...';

  @override
  String get serverError => 'Ocurrió un error en el servidor';

  @override
  String get networkError => 'Sin conexión a internet';

  @override
  String get language => 'Idioma';

  @override
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';
}
