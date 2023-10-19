import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static initEnvironment() async {
    if (!dotenv.isEveryDefined(['API_URL'])) {
      print('Falta definir alguna(s) variable(s) de entorno.');
      return;
    }

    await dotenv.load(fileName: '.env');
  }

  static String apiUrl = dotenv.env['API_URL'] ?? 'no esta configurada';
}
