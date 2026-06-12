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

class ContentCalendarScreen extends StatefulWidget {
  const ContentCalendarScreen({super.key});

  @override
  State<ContentCalendarScreen> createState() => _ContentCalendarScreenState();
}

class _ContentCalendarScreenState extends State<ContentCalendarScreen> {
  String? _niche;
  String? _objective;
  String? _platform = 'Instagram';
  String? _postsPerWeek = '3 posts por semana';
  final _brandNameController = TextEditingController();
  bool _isLoading = false;

  static const List<String> _postFrequencies = [
    '1 post por semana',
    '2 posts por semana',
    '3 posts por semana',
    '4 posts por semana',
    '5 posts por semana',
    '7 posts por semana (diário)',
  ];

  @override
  void dispose() {
    _brandNameController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    if (_niche == null || _objective == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final content = await AIService().generateContentCalendar(
        niche: _niche!,
        postsPerWeek: _postsPerWeek!,
        objective: _objective!,
        platform: _platform!,
        brandName: _brandNameController.text.isNotEmpty ? _brandNameController.text : null,
      );

      final model = ContentModel(
        id: const Uuid().v4(),
        type: ContentType.contentCalendar,
        title: 'Calendário 30 dias - $_niche',
        content: content,
        formData: {
          'niche': _niche,
          'objective': _objective,
          'platform': _platform,
          'postsPerWeek': _postsPerWeek,
          'brandName': _brandNameController.text,
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
        title: const Text('Calendário de Conteúdo'),
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
              label: 'Nome da Marca/Negócio (opcional)',
              hint: 'Ex: Clínica Odonto Vida, Studio Fitness...',
              controller: _brandNameController,
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
              label: 'Objetivo Principal *',
              value: _objective,
              items: AppConstants.objectives,
              onChanged: (v) => setState(() => _objective = v),
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Plataforma',
              value: _platform,
              items: AppConstants.platforms,
              onChanged: (v) => setState(() => _platform = v),
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Frequência de Posts',
              value: _postsPerWeek,
              items: _postFrequencies,
              onChanged: (v) => setState(() => _postsPerWeek = v),
            ),
            const SizedBox(height: 24),
            _buildPreview(),
            const SizedBox(height: 24),
            GradientButton(
              text: 'Gerar Calendário com IA',
              isLoading: _isLoading,
              onPressed: _generate,
            ),
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
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.calendar_month_rounded, color: AppColors.accent, size: 24),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Calendário de Conteúdo',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Planejamento completo de 30 dias de posts',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'O que você vai receber:',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildPreviewItem('Calendário organizado por semanas'),
          _buildPreviewItem('Tema e objetivo de cada post'),
          _buildPreviewItem('Tipo de conteúdo sugerido'),
          _buildPreviewItem('Formato recomendado (foto, vídeo, carrossel)'),
          _buildPreviewItem('Ideia/legenda para cada post'),
          _buildPreviewItem('Estratégia e dicas de produção'),
        ],
      ),
    );
  }

  Widget _buildPreviewItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 16),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
