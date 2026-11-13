/// -----------------------------------------------------------------------
/// ApiException
/// -----------------------------------------------------------------------
/// Erro único usado por toda a camada de dados. As telas capturam esta
/// exceção e mostram `mensagem` direto ao usuário, sem precisar conhecer
/// status HTTP ou detalhes de rede.
/// -----------------------------------------------------------------------
class ApiException implements Exception {
  /// Mensagem pronta para exibir na interface.
  final String mensagem;

  /// Status HTTP retornado pelo backend (null quando o erro foi de rede).
  final int? statusCode;

  const ApiException(this.mensagem, {this.statusCode});

  /// Erro de conexão (backend desligado, IP errado, sem internet).
  factory ApiException.semConexao() => const ApiException(
        'Não foi possível conectar ao servidor. '
        'Verifique se o backend está rodando e tente novamente.',
      );

  /// Sessão inválida/expirada — o app deve voltar para a tela de login.
  factory ApiException.naoAutenticado() => const ApiException(
        'Sua sessão expirou. Faça login novamente.',
        statusCode: 401,
      );

  bool get isNaoAutenticado => statusCode == 401 || statusCode == 403;

  @override
  String toString() => mensagem;
}
