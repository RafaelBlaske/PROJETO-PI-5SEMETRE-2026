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

class BrandNameScreen extends StatefulWidget {
  const BrandNameScreen({super.key});

  @override
  State<BrandNameScreen> createState() => _BrandNameScreenState();
}

class _BrandNameScreenState extends State<BrandNameScreen> {
  String? _niche;
  String? _audience;
  String? _voiceTone;
  final _keywordsController = TextEditingController();
  final _styleController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _keywordsController.dispose();
    _styleController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    if (_niche == null || _audience == null || _voiceTone == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final content = await AIService().generateBrandNames(
        niche: _niche!,
        audience: _audience!,
        voiceTone: _voiceTone!,
        keywords: _keywordsController.text.isNotEmpty ? _keywordsController.text : null,
        style: _styleController.text.isNotEmpty ? _styleController.text : null,
      );

      final model = ContentModel(
        id: const Uuid().v4(),
        type: ContentType.brandName,
        title: 'Nomes de Marca - $_niche',
        content: content,
        formData: {
          'niche': _niche,
          'audience': _audience,
          'voiceTone': _voiceTone,
          'keywords': _keywordsController.text,
          'style': _styleController.text,
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
        title: const Text('Nome de Marca'),
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
              label: 'Palavras-chave (opcional)',
              hint: 'Ex: saúde, vida, bem-estar, natural...',
              controller: _keywordsController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Estilo desejado (opcional)',
              hint: 'Ex: moderno, minimalista, premium, jovem...',
              controller: _styleController,
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
              text: 'Gerar Nomes com IA',
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
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: AppColors.warning, size: 24),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gerador de Nomes de Marca',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  '15 sugestões de nomes criativos com conceito e slogan',
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
