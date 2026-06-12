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

class InstagramScreen extends StatefulWidget {
  const InstagramScreen({super.key});

  @override
  State<InstagramScreen> createState() => _InstagramScreenState();
}

class _InstagramScreenState extends State<InstagramScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _niche;
  String? _audience;
  String? _objective;
  String? _platform = 'Instagram';
  String? _voiceTone;
  final _clientTypeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _clientTypeController.dispose();
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
      final content = await AIService().generateInstagramContent(
        niche: _niche!,
        audience: _audience!,
        objective: _objective!,
        platform: _platform ?? 'Instagram',
        voiceTone: _voiceTone!,
        clientType: _clientTypeController.text.isNotEmpty ? _clientTypeController.text : null,
      );

      final model = ContentModel(
        id: const Uuid().v4(),
        type: ContentType.instagram,
        title: 'Conteúdo $_platform - $_niche',
        content: content,
        formData: {
          'niche': _niche,
          'audience': _audience,
          'objective': _objective,
          'platform': _platform,
          'voiceTone': _voiceTone,
          'clientType': _clientTypeController.text,
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
        title: const Text('Instagram & Reels'),
        backgroundColor: AppColors.bgDark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Tipo de Cliente (opcional)',
                hint: 'Ex: Clínica odontológica, Loja de roupas...',
                controller: _clientTypeController,
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
                label: 'Plataforma',
                value: _platform,
                items: AppConstants.platforms,
                onChanged: (v) => setState(() => _platform = v),
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
                text: 'Gerar com IA',
                isLoading: _isLoading,
                onPressed: _generate,
              ),
              const SizedBox(height: 12),
              _buildInfoBox(),
            ],
          ),
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
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.photo_camera_rounded, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Conteúdo para Instagram',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Gera 10 ideias de reels, 5 roteiros, 5 legendas e muito mais',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'A IA vai gerar: 10 ideias de reels, 5 roteiros completos, 5 legendas otimizadas, 3 CTAs e 3 conjuntos de hashtags.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
