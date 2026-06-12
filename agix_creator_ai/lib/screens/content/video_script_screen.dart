import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../models/content_model.dart';
import '../../services/ai_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/common/gradient_button.dart';
import '../../widgets/common/custom_form_field.dart';
import '../result/result_screen.dart';

class VideoScriptScreen extends StatefulWidget {
  const VideoScriptScreen({super.key});

  @override
  State<VideoScriptScreen> createState() => _VideoScriptScreenState();
}

class _VideoScriptScreenState extends State<VideoScriptScreen> {
  String? _niche;
  String? _audience;
  String? _objective;
  String? _voiceTone;
  String? _duration = '60 segundos';
  String? _platform = 'Instagram Reels';
  String? _videoType = 'Educativo/Tutorial';
  final _topicController = TextEditingController();
  final _keyPointsController = TextEditingController();
  bool _isLoading = false;

  static const List<String> _durations = [
    '15 segundos (Reels/TikTok)',
    '30 segundos',
    '60 segundos',
    '2 minutos',
    '5 minutos',
    '10 minutos',
    '15+ minutos (YouTube)',
  ];

  static const List<String> _platforms = [
    'Instagram Reels',
    'TikTok',
    'YouTube Shorts',
    'YouTube',
    'Facebook',
    'LinkedIn',
  ];

  static const List<String> _videoTypes = [
    'Educativo/Tutorial',
    'Entretenimento',
    'Depoimento/Case',
    'Bastidores',
    'Lançamento de produto',
    'Tendências/Notícias',
    'Motivacional',
    'Promocional/Oferta',
  ];

  @override
  void dispose() {
    _topicController.dispose();
    _keyPointsController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    if (_niche == null || _audience == null || _objective == null || _voiceTone == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prompt = '''Crie um roteiro de vídeo completo e detalhado com as seguintes informações:

Tema/Assunto: ${_topicController.text.isNotEmpty ? _topicController.text : 'Tendências e dicas do nicho'}
Pontos-chave a abordar: ${_keyPointsController.text.isNotEmpty ? _keyPointsController.text : 'Os mais relevantes para o público'}
Tipo de Vídeo: $_videoType
Plataforma: $_platform
Duração: $_duration
Nicho: $_niche
Público-alvo: $_audience
Objetivo: $_objective
Tom de Voz: $_voiceTone

Inclua: gancho irresistível nos primeiros segundos, desenvolvimento com notas de cena entre [], CTA final e legenda pronta para o post com hashtags.''';

      final content = await AIService().generateContent(prompt, type: 'video_script');

      final model = ContentModel(
        id: const Uuid().v4(),
        type: ContentType.videoScript,
        title: 'Roteiro - ${_topicController.text.isNotEmpty ? _topicController.text : _niche}',
        content: content,
        formData: {
          'niche': _niche,
          'audience': _audience,
          'objective': _objective,
          'voiceTone': _voiceTone,
          'duration': _duration,
          'platform': _platform,
          'videoType': _videoType,
          'topic': _topicController.text,
          'keyPoints': _keyPointsController.text,
        },
        createdAt: DateTime.now(),
      );

      await StorageService().saveContent(model);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ResultScreen(content: model)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: ${e.toString()}'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        title: const Text('Roteiro de Vídeo'),
        backgroundColor: AppColors.bgDark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            CustomTextField(
              label: 'Tema/Assunto (opcional)',
              hint: 'Ex: Como perder peso rápido, 5 dicas de...',
              controller: _topicController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Pontos-chave a abordar (opcional)',
              hint: 'Ex: Ponto 1, Ponto 2, Dica especial...',
              controller: _keyPointsController,
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Tipo de Vídeo',
              value: _videoType,
              items: _videoTypes,
              onChanged: (v) => setState(() => _videoType = v),
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Plataforma',
              value: _platform,
              items: _platforms,
              onChanged: (v) => setState(() => _platform = v),
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Duração do Vídeo',
              value: _duration,
              items: _durations,
              onChanged: (v) => setState(() => _duration = v),
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Nicho *',
              value: _niche,
              items: AppConstants.niches,
              onChanged: (v) => setState(() => _niche = v),
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Público-alvo *',
              value: _audience,
              items: AppConstants.audiences,
              onChanged: (v) => setState(() => _audience = v),
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Objetivo *',
              value: _objective,
              items: AppConstants.objectives,
              onChanged: (v) => setState(() => _objective = v),
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Tom de Voz *',
              value: _voiceTone,
              items: AppConstants.voiceTones,
              onChanged: (v) => setState(() => _voiceTone = v),
            ),
            const SizedBox(height: 32),
            GradientButton(
              text: 'Gerar Roteiro com IA',
              isLoading: _isLoading,
              onPressed: _generate,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: AppColors.bgSurface,
              hint: const Text('Selecione...', style: TextStyle(color: AppColors.textSecondary)),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: const TextStyle(color: AppColors.textPrimary)),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.videocam_rounded, color: AppColors.error, size: 24),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Roteiro de Vídeo',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Gancho + desenvolvimento + CTA + legenda pronta',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
