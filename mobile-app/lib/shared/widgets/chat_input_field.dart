import 'package:flutter/material.dart';

class ChatInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onSend;
  final bool isLoading;

  const ChatInputField({
    super.key,
    required this.controller,
    this.hintText = 'Escribe tu mensaje...',
    this.onSend,
    this.isLoading = false,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final FocusNode _focusNode = FocusNode();
  int _lineCount = 1;
  final double _minHeight = 40.0;
  final double _maxHeight = 120.0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = widget.controller.text;
    final lines = text.split('\n').length;
    final newLineCount = lines > 1 ? lines : 1;
    
    if (newLineCount != _lineCount) {
      setState(() {
        _lineCount = newLineCount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: _minHeight,
        maxHeight: _maxHeight,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF2D2D2D),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              maxLines: null,
              textInputAction: TextInputAction.newline,
              style: const TextStyle(
                color: Color(0xFFE5E7EB),
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: (text) {
                if (text.trim().isNotEmpty && widget.onSend != null) {
                  widget.onSend!();
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          Container(
            margin: const EdgeInsets.only(right: 8, bottom: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: widget.isLoading ? null : widget.onSend,
                child: Container(
                  width: 32,
                  height: 32,
                  child: widget.isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
