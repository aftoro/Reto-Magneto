import 'package:flutter/material.dart';

class VisualSelector extends StatefulWidget {
  final Function(Map<String, dynamic>) onSelection;
  final List<Map<String, dynamic>> selections;

  const VisualSelector({
    super.key,
    required this.onSelection,
    required this.selections,
  });

  @override
  State<VisualSelector> createState() => _VisualSelectorState();
}

class _VisualSelectorState extends State<VisualSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Herramientas Visuales',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildToolButton(
                  icon: Icons.crop_free,
                  label: 'Seleccionar',
                  onTap: () => _handleTool('select'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildToolButton(
                  icon: Icons.text_fields,
                  label: 'Texto',
                  onTap: () => _handleTool('text'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildToolButton(
                  icon: Icons.palette,
                  label: 'Color',
                  onTap: () => _handleTool('color'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildToolButton(
                  icon: Icons.aspect_ratio,
                  label: 'Tamaño',
                  onTap: () => _handleTool('size'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF3B82F6).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF3B82F6).withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: const Color(0xFF3B82F6),
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTool(String tool) {
    final selection = {
      'tool': tool,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    widget.onSelection(selection);
  }
}
