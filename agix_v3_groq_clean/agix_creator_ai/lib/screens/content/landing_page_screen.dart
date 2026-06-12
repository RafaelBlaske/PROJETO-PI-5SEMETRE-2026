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

class LandingPageScreen extends StatefulWidget {
  const LandingPageScreen({super.key});

  @override
  State<LandingPageScreen> createState() => _LandingPageScreenState();
}

class _LandingPageScreenState extends State<LandingPageScreen> {
  String? _niche;
  String? _audience;
  String? _objective;
  String? _voiceTone;
  String? _pageGoal = 'Captar leads';
  final _productController = TextEditingController();
  final _benefitController = TextEditingController();
  final _differentialController = TextEditingController();
  bool _isLoading = false;

  static const List<String> _pageGoals = [
    'Captar leads',
    'Vender produto',
    'Vender serviço',
    'Inscrição em evento',
    'Download de material',
    'Agendamento de consulta',
    'Demonstração gratuita',
  ];

  @override
  void dispose() {
    _productController.dispose();
    _benefitController.dispose();
    _differentialController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    if (_niche == null || _audience == null || _objective == null || _voiceTone == null ||
        _productController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prompt = '''Crie um PROMPT completo e um ESBOÇO DETALHADO de Landing Page com as seguintes informações:

Produto/Serviço: ${_productController.text}
Principal Benefício: ${_benefitController.text.isNotEmpty ? _benefitController.text : 'Não especificado'}
Diferenciais/Destaques: ${_differentialController.text.isNotEmpty ? _differentialController.text : 'Não especificado'}
Objetivo da Página: $_pageGoal
Nicho: $_niche
Público-alvo: $_audience
Meta de Negócio: $_objective
Tom de Voz: $_voiceTone

Gere: um prompt para IA de design + esboço completo com headline, sub-headline, seções de benefícios, prova social, FAQ e CTAs. Inclua também a copy final pronta para cada seção.''';

      final content = await AIService().generateContent(prompt, type: 'landing_page');

      final model = ContentModel(
        id: const Uuid().v4(),
        type: ContentType.landingPage,
        title: 'Landing Page - ${_productController.text}',
        content: content,
        formData: {
          'niche': _niche,
          'audience': _audience,
          'objective': _objective,
          'voiceTone': _voiceTone,
          'product': _productController.text,
          'benefit': _benefitController.text,
          'differential': _differentialController.text,
          'pageGoal': _pageGoal,
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
        title: const Text('Copy Landing Page'),
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
              label: 'Produto/Serviço *',
              hint: 'Ex: Consultoria de marketing, Curso online...',
              controller: _productController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Principal Benefício (opcional)',
              hint: 'Ex: Dobrar vendas em 30 dias...',
              controller: _benefitController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Diferenciais / Destaques (opcional)',
              hint: 'Ex: 10 anos de experiência, garantia de 30 dias, suporte 24h...',
              controller: _differentialController,
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Objetivo da Página *',
              value: _pageGoal,
              items: _pageGoals,
              onChanged: (v) => setState(() => _pageGoal = v),
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
              label: 'Meta de Negócio *',
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
              text: 'Gerar Prompt + Esboço com IA',
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
        border: Border.all(color: AppColors.info.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.web_rounded, color: AppColors.info, size: 24),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Prompt + Esboço de Landing Page',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Prompt para IA + estrutura completa com copy pronta',
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
