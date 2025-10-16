import 'package:flutter/material.dart';
import '../../data/models/conversation_entity.dart';

class ChatInfoPage extends StatelessWidget {
  final ConversationEntity conversation;

  const ChatInfoPage({
    super.key,
    required this.conversation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        title: const Text('Información del Chat'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1F2937), Color(0xFF374151)], // Dark mode gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con foto de perfil
            _buildProfileHeader(),
            const SizedBox(height: 24),
            
            // Información básica
            _buildSection(
              title: 'Información Básica',
              children: [
                _buildInfoItem('Nombre completo', conversation.userFullName ?? 'No disponible'),
                _buildInfoItem('Profesión', conversation.userProfession ?? 'No disponible'),
                _buildInfoItem('Estudios', conversation.userStudies ?? 'No disponible'),
                _buildInfoItem('Ubicación', conversation.userLocation ?? 'No disponible'),
                _buildInfoItem('Años de experiencia', conversation.userExperienceYears?.toString() ?? 'No disponible'),
                _buildInfoItem('Nivel de carrera', conversation.userCareerLevel ?? 'No disponible'),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Habilidades
            if (conversation.userSkills != null && conversation.userSkills!.isNotEmpty)
              _buildSection(
                title: 'Habilidades',
                children: [
                  _buildSkillsChips(conversation.userSkills!),
                ],
              ),
            
            const SizedBox(height: 24),
            
            // Idiomas
            if (conversation.userLanguages != null && conversation.userLanguages!.isNotEmpty)
              _buildSection(
                title: 'Idiomas',
                children: [
                  _buildLanguagesChips(conversation.userLanguages!),
                ],
              ),
            
            const SizedBox(height: 24),
            
            // Preferencias laborales
            _buildSection(
              title: 'Preferencias Laborales',
              children: [
                _buildInfoItem('Disponibilidad', conversation.userAvailability ?? 'No disponible'),
                _buildInfoItem('Expectativa salarial', conversation.userSalaryExpectation ?? 'No disponible'),
                _buildInfoItem('Tipo de empresa', conversation.userCompanySizePreference ?? 'No disponible'),
                _buildInfoItem('Modalidad de trabajo', conversation.userWorkModePreference ?? 'No disponible'),
                if (conversation.userIndustryPreference != null && conversation.userIndustryPreference!.isNotEmpty)
                  _buildInfoItem('Industrias de interés', conversation.userIndustryPreference!.join(', ')),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Intereses
            if (conversation.userInterests != null && conversation.userInterests!.isNotEmpty)
              _buildSection(
                title: 'Intereses',
                children: [
                  _buildInterestsChips(conversation.userInterests!),
                ],
              ),
            
            const SizedBox(height: 24),
            
            // Enlaces
            _buildSection(
              title: 'Enlaces',
              children: [
                if (conversation.userPortfolioUrl != null)
                  _buildLinkItem('Portfolio', conversation.userPortfolioUrl!),
                if (conversation.userLinkedinUrl != null)
                  _buildLinkItem('LinkedIn', conversation.userLinkedinUrl!),
                if (conversation.userGithubUrl != null)
                  _buildLinkItem('GitHub', conversation.userGithubUrl!),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Información de Instagram (solo campos disponibles)
            _buildSection(
              title: 'Perfil de Instagram',
              children: [
                _buildInfoItem('Username', conversation.username ?? 'No disponible'),
                if (conversation.userCurrentEmotion != null)
                  _buildInfoItem('Estado emocional', conversation.userCurrentEmotion!),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Progreso de datos
            if (conversation.userDataCompletionPercentage != null)
              _buildSection(
                title: 'Progreso de Perfil',
                children: [
                  _buildProgressBar(conversation.userDataCompletionPercentage!),
                ],
              ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF2D2D2D),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Avatar con inicial y badge de emoción
          Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)], // Blue gradient for dark mode
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    (conversation.userFullName ?? conversation.username ?? 'U').substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                ),
              ),
              // Badge de emoción
              if (conversation.userCurrentEmotion != null)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _getEmotionColor(conversation.userCurrentEmotion!),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF1A1A1A),
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _getEmotionEmoji(conversation.userCurrentEmotion!),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Información básica
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  conversation.userFullName ?? conversation.username ?? 'Usuario',
                  style: const TextStyle(
                    color: Color(0xFFE5E7EB),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                if (conversation.userProfession != null)
                  Text(
                    conversation.userProfession!,
                    style: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 16,
                    ),
                  ),
                const SizedBox(height: 8),
                if (conversation.userLocation != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFF6B7280),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        conversation.userLocation!,
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2D2D2D),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFE5E7EB),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 14,
              ),
            ),
          ),
          const Text(
            ': ',
            style: TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFFE5E7EB),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsChips(List<String> skills) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: skills.map((skill) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF8B5CF6).withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF8B5CF6).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          skill,
          style: const TextStyle(
            color: Color(0xFF8B5CF6),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildLanguagesChips(List<String> languages) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: languages.map((language) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF10B981).withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF10B981).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          language,
          style: const TextStyle(
            color: Color(0xFF10B981),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildInterestsChips(List<String> interests) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: interests.map((interest) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF59E0B).withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFF59E0B).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          interest,
          style: const TextStyle(
            color: Color(0xFFF59E0B),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildLinkItem(String label, String url) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 14,
              ),
            ),
          ),
          const Text(
            ': ',
            style: TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 14,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                // TODO: Abrir enlace
              },
              child: Text(
                url,
                style: const TextStyle(
                  color: Color(0xFF8B5CF6),
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(int percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Completitud del perfil',
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 14,
              ),
            ),
            Text(
              '$percentage%',
              style: const TextStyle(
                color: Color(0xFFE5E7EB),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFF2D2D2D),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage / 100,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
        return const Color(0xFF10B981);
      case 'sad':
        return const Color(0xFF3B82F6);
      case 'angry':
        return const Color(0xFFEF4444);
      case 'excited':
        return const Color(0xFFF59E0B);
      case 'calm':
        return const Color(0xFF8B5CF6);
      case 'anxious':
        return const Color(0xFFF97316);
      case 'confident':
        return const Color(0xFF06B6D4);
      case 'confused':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _getEmotionEmoji(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
        return '😊';
      case 'sad':
        return '😢';
      case 'angry':
        return '😠';
      case 'excited':
        return '🤩';
      case 'calm':
        return '😌';
      case 'anxious':
        return '😰';
      case 'confident':
        return '😎';
      case 'confused':
        return '😕';
      default:
        return '😐';
    }
  }
}
