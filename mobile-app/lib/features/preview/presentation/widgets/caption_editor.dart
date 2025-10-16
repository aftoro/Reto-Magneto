import 'package:flutter/material.dart';

class CaptionEditor extends StatefulWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final String? hintText;
  final int maxLines;
  final int maxLength;

  const CaptionEditor({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText,
    this.maxLines = 4,
    this.maxLength = 2200,
  });

  @override
  State<CaptionEditor> createState() => _CaptionEditorState();
}

class _CaptionEditorState extends State<CaptionEditor>
    with TickerProviderStateMixin {
  late AnimationController _charCountController;
  late Animation<Color?> _charCountAnimation;
  
  bool _isFocused = false;
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _charCount = widget.controller.text.length;
    
    _charCountController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _charCountAnimation = ColorTween(
      begin: Colors.grey[400],
      end: const Color(0xFF3B82F6),
    ).animate(CurvedAnimation(
      parent: _charCountController,
      curve: Curves.easeInOut,
    ));
    
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _charCountController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _charCount = widget.controller.text.length;
    });
    
    if (_charCount > widget.maxLength * 0.8) {
      _charCountController.forward();
    } else {
      _charCountController.reverse();
    }
    
    widget.onChanged?.call(widget.controller.text);
  }

  @override
  Widget build(BuildContext context) {
    print('CaptionEditor - Caption text: ${widget.controller.text}');
    
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isFocused ? const Color(0xFF3B82F6) : const Color(0xFF4B5563),
          width: _isFocused ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.edit_note,
                  color: Color(0xFF3B82F6),
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Caption',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                AnimatedBuilder(
                  animation: _charCountAnimation,
                  builder: (context, child) {
                    return Text(
                      '$_charCount/${widget.maxLength}',
                      style: TextStyle(
                        color: _charCount > widget.maxLength * 0.9 
                            ? Colors.red 
                            : _charCountAnimation.value,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          
          // Text Field
          TextField(
            controller: widget.controller,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.4,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText ?? 'Escribe tu caption aquí...',
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              counterText: '', // Hide default counter
            ),
            onChanged: (value) {
              widget.onChanged?.call(value);
            },
            onTap: () {
              setState(() {
                _isFocused = true;
              });
            },
            onSubmitted: (value) {
              setState(() {
                _isFocused = false;
              });
            },
          ),
          
          // Footer with suggestions
          if (_isFocused) _buildSuggestions(),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xFF4B5563),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sugerencias de hashtags:',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _buildHashtagSuggestion('#marketing'),
              _buildHashtagSuggestion('#digital'),
              _buildHashtagSuggestion('#tendencias'),
              _buildHashtagSuggestion('#innovación'),
              _buildHashtagSuggestion('#contenido'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHashtagSuggestion(String hashtag) {
    return GestureDetector(
      onTap: () {
        final currentText = widget.controller.text;
        final newText = currentText.isEmpty 
            ? '$hashtag '
            : '$currentText $hashtag ';
        widget.controller.text = newText;
        widget.controller.selection = TextSelection.fromPosition(
          TextPosition(offset: newText.length),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF3B82F6).withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: const Color(0xFF3B82F6).withOpacity(0.3),
          ),
        ),
        child: Text(
          hashtag,
          style: const TextStyle(
            color: Color(0xFF3B82F6),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
