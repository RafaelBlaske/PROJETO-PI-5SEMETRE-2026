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

class SloganScreen extends StatefulWidget {
  const SloganScreen({super.key});

  @override
  State<SloganScreen> createState() => _SloganScreenState();
}

class _SloganScreenState extends State<SloganScreen> {
  String? _niche;
  String? _audience;
  String? _voiceTone;
  String? _sloganStyle = 'Todos os estilos';
  final _brandNameController = TextEditingController();
  final _mainValueController = TextEditingController();
  final _keywordsController = TextEditingController();
  bool _isLoading = false;

  static const List<String> _sloganStyles = [
    'Todos os estilos',
    'Somente Emocionais',
    'Somente Benefício',
    'Somente Minimalistas',
    'Somente Provocativos',
  ];

  @override
  void dispose() {
    _brandNameController.dispose();
    _mainValueController.dispose();
    _keywordsController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    if (_niche == null || _audience == null || _voiceTone == null ||
        _brandNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prompt = '''Gere slogans memoráveis e estratégicos para a marca com as seguintes informações:

Nome da Marca: ${_brandNameController.text}
Nicho de Atuação: $_niche
Público-alvo: $_audience
Valor Principal/Diferencial: ${_mainValueController.text.isNotEmpty ? _mainValueController.text : 'Qualidade e Confiança'}
Palavras-chave para inspiração: ${_keywordsController.text.isNotEmpty ? _keywordsController.text : 'Relevantes ao nicho'}
Tom de Voz da Marca: $_voiceTone
Estilo preferido: $_sloganStyle

Gere 20 slogans divididos em categorias (Emocionais, Benefício, Minimalistas, Provocativos) e destaque os TOP 3 mais recomendados com justificativa.''';

      final content = await AIService().generateContent(prompt, type: 'slogan');

      final model = ContentModel(
        id: const Uuid().v4(),
        type: ContentType.slogan,
        title: 'Slogans - ${_brandNameController.text}',
        content: content,
        formData: {
          'brandName': _brandNameController.text,
          'niche': _niche,
          'audience': _audience,
          'voiceTone': _voiceTone,
          'mainValue': _mainValueController.text,
          'keywords': _keywordsController.text,
          'sloganStyle': _sloganStyle,
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
        title: const Text('Gerador de Slogans'),
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
              label: 'Nome da Marca *',
              hint: 'Ex: NutriVida, TechPro, FitLife...',
              controller: _brandNameController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Principal Valor/Diferencial (opcional)',
              hint: 'Ex: Qualidade premium, Resultados rápidos...',
              controller: _mainValueController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Palavras-chave para inspiração (opcional)',
              hint: 'Ex: força, transformação, confiança, futuro...',
              controller: _keywordsController,
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Estilo de Slogan',
              value: _sloganStyle,
              items: _sloganStyles,
              onChanged: (v) => setState(() => _sloganStyle = v),
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
              label: 'Tom de Voz *',
              value: _voiceTone,
              items: AppConstants.voiceTones,
              onChanged: (v) => setState(() => _voiceTone = v),
            ),
            const SizedBox(height: 32),
            GradientButton(
              text: 'Gerar Slogans com IA',
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
        border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.format_quote_rounded, color: AppColors.secondary, size: 24),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gerador de Slogans',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  '20 slogans em 4 categorias + TOP 3 recomendados',
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
