import 'dart:convert';

enum ContentType {
  instagram,
  videoScript,
  landingPage,
  brandName,
  slogan,
  proposal,
  engagementAnalysis,
  contentCalendar,
}

extension ContentTypeExtension on ContentType {
  String get displayName {
    switch (this) {
      case ContentType.instagram:
        return 'Conteúdo Instagram';
      case ContentType.videoScript:
        return 'Roteiro de Vídeo';
      case ContentType.landingPage:
        return 'Copy Landing Page';
      case ContentType.brandName:
        return 'Nome de Marca';
      case ContentType.slogan:
        return 'Slogan';
      case ContentType.proposal:
        return 'Proposta Comercial';
      case ContentType.engagementAnalysis:
        return 'Análise de Engajamento';
      case ContentType.contentCalendar:
        return 'Calendário de Conteúdo';
    }
  }

  String get emoji {
    switch (this) {
      case ContentType.instagram:
        return '📱';
      case ContentType.videoScript:
        return '🎬';
      case ContentType.landingPage:
        return '🖥️';
      case ContentType.brandName:
        return '✨';
      case ContentType.slogan:
        return '💡';
      case ContentType.proposal:
        return '📋';
      case ContentType.engagementAnalysis:
        return '📊';
      case ContentType.contentCalendar:
        return '📅';
    }
  }
}

class ContentModel {
  final String id;
  final ContentType type;
  final String title;
  final String content;
  final Map<String, dynamic> formData;
  final DateTime createdAt;
  bool isFavorite;

  ContentModel({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.formData,
    required this.createdAt,
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'title': title,
      'content': content,
      'formData': formData,
      'createdAt': createdAt.toIso8601String(),
      'isFavorite': isFavorite,
    };
  }

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['id'],
      type: ContentType.values[json['type']],
      title: json['title'],
      content: json['content'],
      formData: Map<String, dynamic>.from(json['formData'] ?? {}),
      createdAt: DateTime.parse(json['createdAt']),
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  String toJsonString() => jsonEncode(toJson());
  factory ContentModel.fromJsonString(String jsonString) =>
      ContentModel.fromJson(jsonDecode(jsonString));
}
