import 'package:flutter/material.dart';

/// Categoriza o tipo de notificação para escolher ícone/cor corretos.
enum NotificationType { sessaoConfirmada, lembrete, avaliacao, dica, conquista }

/// -----------------------------------------------------------------------
/// NotificationModel
/// -----------------------------------------------------------------------
/// Representa um item da tela de notificações.
/// -----------------------------------------------------------------------
class NotificationModel {
  final String id;
  final NotificationType type;
  final String titulo;
  final String descricao;
  final String tempoRelativo; // Ex: "há 5h", "há 2 dias"
  final bool lida;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.titulo,
    required this.descricao,
    required this.tempoRelativo,
    this.lida = false,
  });

  /// Ícone correspondente ao tipo de notificação.
  IconData get icone {
    switch (type) {
      case NotificationType.sessaoConfirmada:
        return Icons.event_available_rounded;
      case NotificationType.lembrete:
        return Icons.notifications_active_rounded;
      case NotificationType.avaliacao:
        return Icons.star_rounded;
      case NotificationType.dica:
        return Icons.lightbulb_rounded;
      case NotificationType.conquista:
        return Icons.emoji_events_rounded;
    }
  }

  static List<NotificationModel> mockList() {
    return const [
      NotificationModel(
        id: 'n1',
        type: NotificationType.sessaoConfirmada,
        titulo: 'Sessão confirmada',
        descricao: 'Sua sessão com Laura Almeida foi confirmada para hoje às 15:00.',
        tempoRelativo: 'há 1h',
        lida: false,
      ),
      NotificationModel(
        id: 'n2',
        type: NotificationType.lembrete,
        titulo: 'Lembrete de sessão',
        descricao: 'Você tem uma sessão em 2 horas. Prepare seu ambiente.',
        tempoRelativo: 'há 1h',
        lida: false,
      ),
      NotificationModel(
        id: 'n3',
        type: NotificationType.avaliacao,
        titulo: 'Avalie sua última sessão',
        descricao: 'Como foi sua sessão com Laura Almeida em 15/09?',
        tempoRelativo: 'há 2 dias',
      ),
      NotificationModel(
        id: 'n4',
        type: NotificationType.dica,
        titulo: 'Dica de bem-estar',
        descricao: 'Pratique 5 minutos de respirações antes de dormir para reduzir a ansiedade.',
        tempoRelativo: 'há 3 dias',
      ),
      NotificationModel(
        id: 'n5',
        type: NotificationType.conquista,
        titulo: '3 meses de jornada!',
        descricao: 'Você completou 3 meses no Mind. Continue assim!',
        tempoRelativo: 'há 1 sem',
      ),
    ];
  }
}
