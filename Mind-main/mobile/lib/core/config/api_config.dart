// Usamos defaultTargetPlatform (e não dart:io) para que este arquivo
// também compile no Flutter Web, onde dart:io não existe.
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// -----------------------------------------------------------------------
/// ApiConfig
/// -----------------------------------------------------------------------
/// Centraliza a URL base do backend Spring Boot.
///
/// O endereço muda conforme onde o app roda:
///   - Emulador Android : 10.0.2.2 é o "localhost" da máquina host
///   - Emulador iOS/Web : localhost funciona normalmente
///   - Celular físico   : precisa do IP da máquina na rede local
///
/// Para apontar para outro host (celular físico, servidor de homologação),
/// rode o app com --dart-define, sem alterar código:
///
///   flutter run --dart-define=API_BASE_URL=http://192.168.0.15:8080
/// -----------------------------------------------------------------------
class ApiConfig {
  ApiConfig._();

  /// Valor opcional injetado em tempo de compilação.
  static const String _override = String.fromEnvironment('API_BASE_URL');

  /// Porta padrão do backend (ver `server.port` no application.properties).
  static const int port = 8080;

  /// URL base usada por todas as chamadas HTTP.
  static String get baseUrl {
    if (_override.isNotEmpty) return _removerBarraFinal(_override);

    if (kIsWeb) return 'http://localhost:$port';

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:$port';
    }

    return 'http://localhost:$port';
  }

  /// Monta a URL pública de uma imagem de perfil salva no backend.
  /// O backend guarda apenas o nome do arquivo (ex: "perfil-joao-a1b2.png")
  /// e serve o binário em GET /api/images/{filename}.
  static String? imagemUrl(String? filename) {
    if (filename == null || filename.isEmpty) return null;
    if (filename.startsWith('http')) return filename;
    return '$baseUrl/api/images/$filename';
  }

  static String _removerBarraFinal(String url) =>
      url.endsWith('/') ? url.substring(0, url.length - 1) : url;
}
