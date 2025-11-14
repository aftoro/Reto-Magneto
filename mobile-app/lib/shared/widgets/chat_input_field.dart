import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_strings.dart';

class ChatInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onSend;
  final bool isLoading;

  const ChatInputField({
    super.key,
    required this.controller,
    this.hintText = AppStrings.messagePlaceholder,
    this.onSend,
    this.isLoading = false,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final FocusNode _focusNode = FocusNode();
  int _lineCount = 1;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _hasText = widget.controller.text.trim().isNotEmpty;
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
    final newHasText = text.trim().isNotEmpty;
    
    if (newLineCount != _lineCount || newHasText != _hasText) {
      setState(() {
        _lineCount = newLineCount;
        _hasText = newHasText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
          constraints: BoxConstraints(
        minHeight: 36.0,
        maxHeight: 100.0,
          ),
          decoration: BoxDecoration(
        color: Colors.white, // Fondo blanco para light mode
        borderRadius: BorderRadius.circular(22),
            border: Border.all(
          color: const Color(0xFFE5E7EB), // Borde gris claro
          width: 1,
            ),
          ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Campo de texto expandido
          Expanded(
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                maxLines: null,
                textInputAction: TextInputAction.newline,
                style: const TextStyle(
                color: Color(0xFF1A1A1A), // Texto negro para light mode
                  fontSize: 16,
                  height: 1.2,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: const TextStyle(
                  color: Color(0xFF9CA3AF), // Gris claro para hint
                    fontSize: 16,
                    height: 1.2,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                fillColor: Colors.transparent,
                filled: false,
                  contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                  ),
                isDense: true,
                ),
                onSubmitted: (text) {
                  if (text.trim().isNotEmpty && widget.onSend != null) {
                    widget.onSend!();
                  }
                },
              ),
            ),
          // Botón de emojis
          Container(
            margin: const EdgeInsets.only(right: 4),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  _showEmojiPicker(context);
                },
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: SvgPicture.asset(
                    'assets/icons/emoji.svg',
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                    clipBehavior: Clip.hardEdge,
                  ),
                ),
              ),
            ),
          ),
          // Botón de envío - cambia de gris a morado según si hay texto
          Container(
            margin: const EdgeInsets.only(right: 4),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: widget.isLoading || !_hasText ? null : widget.onSend,
                  child: widget.isLoading
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7C00FF)),
                          ),
                        )
                    : SizedBox(
                        width: 18,
                        height: 18,
                        child: SvgPicture.asset(
                          'assets/icons/send.svg',
                          width: 18,
                          height: 18,
                          fit: BoxFit.contain,
                          clipBehavior: Clip.hardEdge,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEmojiPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A), // Fondo oscuro
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => _EmojiPickerWidget(
        controller: widget.controller,
      ),
    );
  }

}

// Widget del selector de emojis estilo WhatsApp
class _EmojiPickerWidget extends StatefulWidget {
  final TextEditingController controller;

  const _EmojiPickerWidget({required this.controller});

  @override
  State<_EmojiPickerWidget> createState() => _EmojiPickerWidgetState();
}

class _EmojiPickerWidgetState extends State<_EmojiPickerWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Barra de agarre
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF4A4A4A),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Buscador
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Buscar emoji...',
                hintStyle: const TextStyle(color: Color(0xFF8E8E8E)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF8E8E8E)),
                filled: true,
                fillColor: const Color(0xFF2A2A2A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          // Tab Bar
          Container(
            color: const Color(0xFF1A1A1A),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: const Color(0xFF0095F6),
              labelColor: const Color(0xFF0095F6),
              unselectedLabelColor: const Color(0xFF8E8E8E),
              tabs: const [
                Tab(text: '😀 Caras'),
                Tab(text: '🐱 Animales'),
                Tab(text: '🍕 Comida'),
                Tab(text: '⚽ Deportes'),
                Tab(text: '✈️ Viajes'),
                Tab(text: '💡 Objetos'),
                Tab(text: '❤️ Símbolos'),
                Tab(text: '🏁 Banderas'),
              ],
            ),
          ),
          // Grid de emojis
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEmojiGrid(_emojiCategories['faces']!),
                _buildEmojiGrid(_emojiCategories['animals']!),
                _buildEmojiGrid(_emojiCategories['food']!),
                _buildEmojiGrid(_emojiCategories['sports']!),
                _buildEmojiGrid(_emojiCategories['travel']!),
                _buildEmojiGrid(_emojiCategories['objects']!),
                _buildEmojiGrid(_emojiCategories['symbols']!),
                _buildEmojiGrid(_emojiCategories['flags']!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiGrid(List<String> emojis) {
    final filteredEmojis = _searchQuery.isEmpty
        ? emojis
        : emojis.where((emoji) => emoji.contains(_searchQuery)).toList();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        childAspectRatio: 1,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: filteredEmojis.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            widget.controller.text += filteredEmojis[index];
            Navigator.pop(context);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                filteredEmojis[index],
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
        );
      },
    );
  }

  // Categorías de emojis
  static const Map<String, List<String>> _emojiCategories = {
    'faces': [
      '😀', '😃', '😄', '😁', '😆', '😅', '🤣', '😂',
      '🙂', '🙃', '😉', '😊', '😇', '🥰', '😍', '🤩',
      '😘', '😗', '😚', '😙', '😋', '😛', '😜', '🤪',
      '😝', '🤑', '🤗', '🤭', '🤫', '🤔', '🤐', '🤨',
      '😐', '😑', '😶', '😏', '😒', '🙄', '😬', '🤥',
      '😌', '😔', '😪', '🤤', '😴', '😷', '🤒', '🤕',
      '🤢', '🤮', '🤧', '🥵', '🥶', '🥴', '😵', '🤯',
      '🤠', '🥳', '😎', '🤓', '🧐', '😕', '😟', '🙁',
      '😮', '😯', '😲', '😳', '🥺', '😦', '😧', '😨',
      '😰', '😥', '😢', '😭', '😱', '😖', '😣', '😞',
      '😓', '😩', '😫', '🥱', '😤', '😡', '😠', '🤬',
      '😈', '👿', '💀', '☠️', '💩', '🤡', '👹', '👺',
    ],
    'animals': [
      '🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼',
      '🐨', '🐯', '🦁', '🐮', '🐷', '🐸', '🐵', '🐔',
      '🐧', '🐦', '🐤', '🐣', '🐥', '🦆', '🦅', '🦉',
      '🦇', '🐺', '🐗', '🐴', '🦄', '🐝', '🐛', '🦋',
      '🐌', '🐞', '🐜', '🦟', '🦗', '🕷', '🦂', '🐢',
      '🐍', '🦎', '🦖', '🦕', '🐙', '🦑', '🦐', '🦞',
      '🦀', '🐡', '🐠', '🐟', '🐬', '🐳', '🐋', '🦈',
      '🐊', '🐅', '🐆', '🦓', '🦍', '🦧', '🐘', '🦛',
    ],
    'food': [
      '🍏', '🍎', '🍐', '🍊', '🍋', '🍌', '🍉', '🍇',
      '🍓', '🍈', '🍒', '🍑', '🥭', '🍍', '🥥', '🥝',
      '🍅', '🍆', '🥑', '🥦', '🥬', '🥒', '🌶', '🌽',
      '🥕', '🧄', '🧅', '🥔', '🍠', '🥐', '🥯', '🍞',
      '🥖', '🥨', '🧀', '🥚', '🍳', '🧈', '🥞', '🧇',
      '🥓', '🥩', '🍗', '🍖', '🦴', '🌭', '🍔', '🍟',
      '🍕', '🥪', '🥙', '🧆', '🌮', '🌯', '🥗', '🥘',
      '🥫', '🍝', '🍜', '🍲', '🍛', '🍣', '🍱', '🥟',
    ],
    'sports': [
      '⚽', '🏀', '🏈', '⚾', '🥎', '🎾', '🏐', '🏉',
      '🥏', '🎱', '🪀', '🏓', '🏸', '🏒', '🏑', '🥍',
      '🏏', '🥅', '⛳', '🪁', '🏹', '🎣', '🤿', '🥊',
      '🥋', '🎽', '🛹', '🛼', '🛷', '⛸', '🥌', '🎿',
      '⛷', '🏂', '🪂', '🏋️', '🤼', '🤸', '🤺', '⛹️',
      '🤾', '🏌️', '🏇', '🧘', '🏊', '🤽', '🚣', '🧗',
      '🚴', '🚵', '🎖', '🏆', '🏅', '🥇', '🥈', '🥉',
    ],
    'travel': [
      '🚗', '🚕', '🚙', '🚌', '🚎', '🏎', '🚓', '🚑',
      '🚒', '🚐', '🛻', '🚚', '🚛', '🚜', '🦯', '🦽',
      '🦼', '🛴', '🚲', '🛵', '🏍', '🛺', '🚨', '🚔',
      '🚍', '🚘', '🚖', '🚡', '🚠', '🚟', '🚃', '🚋',
      '🚞', '🚝', '🚄', '🚅', '🚈', '🚂', '🚆', '🚇',
      '🚊', '🚉', '✈️', '🛫', '🛬', '🛩', '💺', '🛰',
      '🚀', '🛸', '🚁', '🛶', '⛵', '🚤', '🛥', '🛳',
      '⛴', '🚢', '⚓', '⛽', '🚧', '🚦', '🚥', '🗺',
    ],
    'objects': [
      '⌚', '📱', '📲', '💻', '⌨️', '🖥', '🖨', '🖱',
      '🖲', '🕹', '🗜', '💽', '💾', '💿', '📀', '📼',
      '📷', '📸', '📹', '🎥', '📽', '🎞', '📞', '☎️',
      '📟', '📠', '📺', '📻', '🎙', '🎚', '🎛', '🧭',
      '⏱', '⏲', '⏰', '🕰', '⌛', '⏳', '📡', '🔋',
      '🔌', '💡', '🔦', '🕯', '🪔', '🧯', '🛢', '💸',
      '💵', '💴', '💶', '💷', '🪙', '💰', '💳', '💎',
      '⚖️', '🪜', '🧰', '🔧', '🔨', '⚒', '🛠', '⛏',
    ],
    'symbols': [
      '❤️', '🧡', '💛', '💚', '💙', '💜', '🖤', '🤍',
      '🤎', '💔', '❣️', '💕', '💞', '💓', '💗', '💖',
      '💘', '💝', '💟', '☮️', '✝️', '☪️', '🕉', '☸️',
      '✡️', '🔯', '🕎', '☯️', '☦️', '🛐', '⛎', '♈',
      '♉', '♊', '♋', '♌', '♍', '♎', '♏', '♐',
      '♑', '♒', '♓', '🆔', '⚛️', '🉑', '☢️', '☣️',
      '📴', '📳', '🈶', '🈚', '🈸', '🈺', '🈷️', '✴️',
      '🆚', '💮', '🉐', '㊙️', '㊗️', '🈴', '🈵', '🈹',
    ],
    'flags': [
      '🏁', '🚩', '🎌', '🏴', '🏳️', '🏳️‍🌈', '🏳️‍⚧️', '🏴‍☠️',
      '🇦🇨', '🇦🇩', '🇦🇪', '🇦🇫', '🇦🇬', '🇦🇮', '🇦🇱', '🇦🇲',
      '🇦🇴', '🇦🇶', '🇦🇷', '🇦🇸', '🇦🇹', '🇦🇺', '🇦🇼', '🇦🇽',
      '🇦🇿', '🇧🇦', '🇧🇧', '🇧🇩', '🇧🇪', '🇧🇫', '🇧🇬', '🇧🇭',
      '🇧🇮', '🇧🇯', '🇧🇱', '🇧🇲', '🇧🇳', '🇧🇴', '🇧🇶', '🇧🇷',
      '🇧🇸', '🇧🇹', '🇧🇻', '🇧🇼', '🇧🇾', '🇧🇿', '🇨🇦', '🇨🇨',
      '🇨🇩', '🇨🇫', '🇨🇬', '🇨🇭', '🇨🇮', '🇨🇰', '🇨🇱', '🇨🇲',
      '🇨🇳', '🇨🇴', '🇨🇵', '🇨🇷', '🇨🇺', '🇨🇻', '🇨🇼', '🇨🇽',
    ],
  };
}
