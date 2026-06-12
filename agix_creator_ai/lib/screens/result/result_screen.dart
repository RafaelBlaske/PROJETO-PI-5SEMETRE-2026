import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/theme/app_theme.dart';
import '../../models/content_model.dart';
import '../../services/storage_service.dart';
import '../../widgets/common/gradient_button.dart';

class ResultScreen extends StatefulWidget {
  final ContentModel content;

  const ResultScreen({super.key, required this.content});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late String _currentContent;
  bool _isEditing = false;
  late TextEditingController _editController;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _currentContent = widget.content.content;
    _isFavorite = widget.content.isFavorite;
    _editController = TextEditingController(text: _currentContent);
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _currentContent));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
            SizedBox(width: 8),
            Text('Conteúdo copiado!'),
          ],
        ),
        backgroundColor: AppColors.bgSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareContent() {
    Share.share(_currentContent, subject: widget.content.title);
  }

  Future<void> _toggleFavorite() async {
    await StorageService().toggleFavorite(widget.content.id);
    setState(() => _isFavorite = !_isFavorite);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFavorite ? 'Adicionado aos favoritos!' : 'Removido dos favoritos'),
        backgroundColor: AppColors.bgSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleEdit() {
    setState(() {
      if (_isEditing) {
        _currentContent = _editController.text;
        // Save updated content
        final updated = ContentModel(
          id: widget.content.id,
          type: widget.content.type,
          title: widget.content.title,
          content: _currentContent,
          formData: widget.content.formData,
          createdAt: widget.content.createdAt,
          isFavorite: _isFavorite,
        );
        StorageService().updateContent(updated);
      } else {
        _editController.text = _currentContent;
      }
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgDark,
        title: Column(
          children: [
            Text(
              widget.content.type.displayName,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.content.title,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
              color: _isFavorite ? AppColors.warning : AppColors.textMuted,
            ),
            onPressed: _toggleFavorite,
          ),
          IconButton(
            icon: Icon(
              _isEditing ? Icons.check_rounded : Icons.edit_rounded,
              color: _isEditing ? AppColors.success : AppColors.textMuted,
            ),
            onPressed: _toggleEdit,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isEditing ? _buildEditView() : _buildResultView(),
          ),
          _buildActionBar(),
        ],
      ),
    );
  }

  Widget _buildResultView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTypeChip(),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.bgSurface2),
            ),
            child: MarkdownBody(
              data: _currentContent,
              styleSheet: MarkdownStyleSheet(
                h1: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                h2: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
                h3: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                p: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.6,
                ),
                strong: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                em: const TextStyle(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
                listBullet: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                ),
                blockquote: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
                blockquoteDecoration: BoxDecoration(
                  color: AppColors.bgSurface,
                  borderRadius: BorderRadius.circular(8),
                  border: const Border(
                    left: BorderSide(color: AppColors.primary, width: 3),
                  ),
                ),
                code: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 13,
                  backgroundColor: Color(0xFF1A1A35),
                ),
                codeblockDecoration: BoxDecoration(
                  color: AppColors.bgSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                tableHead: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                tableBody: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
                tableBorder: TableBorder.all(
                  color: AppColors.bgSurface2,
                  width: 1,
                ),
                horizontalRuleDecoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppColors.bgSurface2, width: 1),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildEditView() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.warning.withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.edit_note_rounded, color: AppColors.warning, size: 16),
                SizedBox(width: 8),
                Text(
                  'Modo de edição ativo. Toque em ✓ para salvar.',
                  style: TextStyle(color: AppColors.warning, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: TextField(
                controller: _editController,
                maxLines: null,
                expands: true,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  height: 1.6,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Text(widget.content.type.emoji, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(
                widget.content.type.displayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Text(
          _formatDate(widget.content.createdAt),
          style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildActionBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.bgCard,
        border: Border(top: BorderSide(color: AppColors.bgSurface2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GradientButton(
              text: 'Copiar',
              onPressed: _copyToClipboard,
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _shareContent,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.bgSurface2),
              ),
              child: const Icon(Icons.share_rounded, color: AppColors.textSecondary, size: 20),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _toggleEdit,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: _isEditing
                    ? AppColors.success.withOpacity(0.15)
                    : AppColors.bgSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isEditing ? AppColors.success : AppColors.bgSurface2,
                ),
              ),
              child: Icon(
                _isEditing ? Icons.check_rounded : Icons.edit_rounded,
                color: _isEditing ? AppColors.success : AppColors.textSecondary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
