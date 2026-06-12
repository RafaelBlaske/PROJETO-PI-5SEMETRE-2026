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

class ProposalScreen extends StatefulWidget {
  const ProposalScreen({super.key});

  @override
  State<ProposalScreen> createState() => _ProposalScreenState();
}

class _ProposalScreenState extends State<ProposalScreen> {
  final _clientNameController = TextEditingController();
  final _agencyNameController = TextEditingController();
  final _valueController = TextEditingController();
  final _deadlineController = TextEditingController();
  final _deliverablesController = TextEditingController();
  final _clientProblemController = TextEditingController();
  String? _serviceType;
  String? _clientNiche;
  String? _contractType = 'Mensal (recorrente)';
  bool _isLoading = false;

  static const List<String> _serviceTypes = [
    'Gestão de Redes Sociais',
    'Criação de Site',
    'Tráfego Pago (Google/Meta Ads)',
    'Produção de Conteúdo',
    'Identidade Visual',
    'SEO',
    'E-mail Marketing',
    'Consultoria de Marketing',
    'Produção de Vídeo',
    'Fotografia Profissional',
    'Gestão Completa de Marketing',
    'Outro',
  ];

  static const List<String> _contractTypes = [
    'Projeto único',
    'Mensal (recorrente)',
    'Trimestral',
    'Semestral',
    'Anual',
    'Por hora/demanda',
  ];

  @override
  void dispose() {
    _clientNameController.dispose();
    _agencyNameController.dispose();
    _valueController.dispose();
    _deadlineController.dispose();
    _deliverablesController.dispose();
    _clientProblemController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    if (_serviceType == null || _clientNiche == null ||
        _clientNameController.text.isEmpty ||
        _valueController.text.isEmpty ||
        _deadlineController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prompt = '''Gere uma Proposta Comercial profissional, completa e persuasiva com as seguintes informações:

Agência/Profissional: ${_agencyNameController.text.isNotEmpty ? _agencyNameController.text : 'Consultoria Especializada'}
Cliente: ${_clientNameController.text}
Nicho do Cliente: $_clientNiche
Serviço a ser Prestado: $_serviceType
Tipo de Contrato: $_contractType
Problema/Dor do Cliente: ${_clientProblemController.text.isNotEmpty ? _clientProblemController.text : 'Dificuldades com presença digital e resultados'}
Entregáveis: ${_deliverablesController.text.isNotEmpty ? _deliverablesController.text : 'Conforme escopo do serviço'}
Valor do Investimento: ${_valueController.text}
Prazo de Entrega/Contrato: ${_deadlineController.text}

Inclua: apresentação, entendimento do problema, solução proposta, escopo detalhado, cronograma por fases, tabela de investimento e próximos passos.''';

      final content = await AIService().generateContent(prompt, type: 'proposal');

      final model = ContentModel(
        id: const Uuid().v4(),
        type: ContentType.proposal,
        title: 'Proposta - ${_clientNameController.text}',
        content: content,
        formData: {
          'serviceType': _serviceType,
          'clientName': _clientNameController.text,
          'clientNiche': _clientNiche,
          'contractType': _contractType,
          'value': _valueController.text,
          'deadline': _deadlineController.text,
          'deliverables': _deliverablesController.text,
          'agencyName': _agencyNameController.text,
          'clientProblem': _clientProblemController.text,
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
        title: const Text('Proposta Comercial'),
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
              label: 'Nome da Agência (opcional)',
              hint: 'Ex: AGIX Marketing...',
              controller: _agencyNameController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Nome do Cliente *',
              hint: 'Ex: João Silva, Empresa XYZ...',
              controller: _clientNameController,
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Nicho do Cliente *',
              value: _clientNiche,
              items: AppConstants.niches,
              onChanged: (v) => setState(() => _clientNiche = v),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Problema/Dor do Cliente (opcional)',
              hint: 'Ex: Pouca visibilidade online, queda nas vendas...',
              controller: _clientProblemController,
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Tipo de Serviço *',
              value: _serviceType,
              items: _serviceTypes,
              onChanged: (v) => setState(() => _serviceType = v),
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Tipo de Contrato',
              value: _contractType,
              items: _contractTypes,
              onChanged: (v) => setState(() => _contractType = v),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Investimento *',
              hint: 'Ex: R\$ 2.500/mês, R\$ 15.000 único...',
              controller: _valueController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Prazo *',
              hint: 'Ex: 30 dias, 3 meses, contrato anual...',
              controller: _deadlineController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Entregas/Deliverables (opcional)',
              hint: 'Ex: 12 posts/mês, 2 reels/semana, relatório mensal...',
              controller: _deliverablesController,
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            GradientButton(
              text: 'Gerar Proposta Comercial com IA',
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
            child: const Icon(Icons.description_rounded, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Proposta Comercial',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Proposta completa com escopo, cronograma e investimento',
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
