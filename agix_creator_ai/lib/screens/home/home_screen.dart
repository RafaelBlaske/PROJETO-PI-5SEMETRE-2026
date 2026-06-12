import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/cards/feature_card.dart';
import '../content/instagram_screen.dart';
import '../content/video_script_screen.dart';
import '../content/landing_page_screen.dart';
import '../content/brand_name_screen.dart';
import '../content/slogan_screen.dart';
import '../content/proposal_screen.dart';
import '../extras/engagement_analysis_screen.dart';
import '../extras/content_calendar_screen.dart';
import '../history/history_screen.dart';
import '../settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroBanner(context),
                  const SizedBox(height: 28),
                  _buildSectionTitle('Criar Conteúdo'),
                  const SizedBox(height: 14),
                  _buildContentGrid(context),
                  const SizedBox(height: 28),
                  _buildSectionTitle('Ferramentas Extras'),
                  const SizedBox(height: 14),
                  _buildExtrasGrid(context),
                  const SizedBox(height: 28),
                  _buildQuickActions(context),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.bgDark,
      floating: true,
      pinned: false,
      expandedHeight: 0,
      toolbarHeight: 64,
      flexibleSpace: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AGIX Creator AI',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Powered by IA',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              ),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.bgSurface2),
                ),
                child: const Icon(Icons.history_rounded, color: AppColors.textSecondary, size: 20),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.bgSurface2),
                ),
                child: const Icon(Icons.settings_rounded, color: AppColors.textSecondary, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.bolt, color: Colors.white, size: 12),
                    SizedBox(width: 4),
                    Text(
                      'IA Avançada',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Crie conteúdo\nprofissional em segundos',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Roteiros, legendas, copies e muito mais.\nTudo gerado por IA para sua agência.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatChip('10+ Tipos', Icons.category_rounded),
              const SizedBox(width: 8),
              _buildStatChip('Histórico', Icons.history_rounded),
              const SizedBox(width: 8),
              _buildStatChip('Exportar', Icons.share_rounded),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildStatChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.bgSurface2,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.bgSurface2),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildContentGrid(BuildContext context) {
    final items = [
      {
        'title': 'Instagram & Reels',
        'subtitle': 'Ideias, roteiros e legendas',
        'icon': Icons.photo_camera_rounded,
        'gradient': AppColors.primaryGradient,
        'screen': const InstagramScreen(),
      },
      {
        'title': 'Roteiro de Vídeo',
        'subtitle': 'Scripts completos para vídeos',
        'icon': Icons.videocam_rounded,
        'gradient': const LinearGradient(colors: [Colors.red, Colors.orange]),
        'screen': const VideoScriptScreen(),
      },
      {
        'title': 'Copy Landing Page',
        'subtitle': 'Textos que convertem',
        'icon': Icons.web_rounded,
        'gradient': const LinearGradient(colors: [Colors.blue, Colors.cyan]),
        'screen': const LandingPageScreen(),
      },
      {
        'title': 'Nome de Marca',
        'subtitle': 'Nomes criativos e únicos',
        'icon': Icons.auto_awesome_rounded,
        'gradient': const LinearGradient(colors: [Colors.orange, Colors.yellow]),
        'screen': const BrandNameScreen(),
      },
      {
        'title': 'Slogans',
        'subtitle': 'Frases memoráveis',
        'icon': Icons.format_quote_rounded,
        'gradient': const LinearGradient(colors: [Colors.green, Colors.lightGreen]),
        'screen': const SloganScreen(),
      },
      {
        'title': 'Proposta Comercial',
        'subtitle': 'Propostas prontas para enviar',
        'icon': Icons.description_rounded,
        'gradient': const LinearGradient(colors: [Colors.purple, Colors.deepPurple]),
        'screen': const ProposalScreen(),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return FeatureCard(
          title: item['title'] as String,
          subtitle: item['subtitle'] as String,
          icon: item['icon'] as IconData,
          gradient: item['gradient'] as Gradient,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => item['screen'] as Widget),
          ),
        );
      },
    );
  }

  Widget _buildExtrasGrid(BuildContext context) {
    final extras = [
      {
        'title': 'Análise de Engajamento',
        'subtitle': 'Avalie suas legendas',
        'icon': Icons.analytics_rounded,
        'screen': const EngagementAnalysisScreen(),
      },
      {
        'title': 'Calendário de Conteúdo',
        'subtitle': 'Planejamento de 30 dias',
        'icon': Icons.calendar_month_rounded,
        'screen': const ContentCalendarScreen(),
      },
    ];

    return Column(
      children: extras.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.bgSurface2),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item['icon'] as IconData, color: AppColors.primary),
            ),
            title: Text(
              item['title'] as String,
              style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              item['subtitle'] as String,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textMuted, size: 16),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => item['screen'] as Widget),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline_rounded, color: AppColors.primary),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dica Pro',
                  style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Use tons de voz variados para testar o que seu público prefere.',
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
