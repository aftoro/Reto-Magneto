import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_constants.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: AppConstants.textTertiary.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Back button Cupertino
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppConstants.textTertiary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: AppConstants.textPrimary,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Logo
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppConstants.primaryColor.withValues(alpha: 0.1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Image.asset(
                        'assets/images/logo_m.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title
                  Expanded(
                    child: Text(
                      'Información del Chat',
                      style: GoogleFonts.poppins(
                        color: AppConstants.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
                _buildInfoItem('Nombre completo', conversation.userFullName ?? 'No disponible', icon: CupertinoIcons.person),
                _buildInfoItem('Profesión', conversation.userProfession ?? 'No disponible', icon: CupertinoIcons.briefcase),
                _buildInfoItem('Estudios', conversation.userStudies ?? 'No disponible', icon: CupertinoIcons.book),
                _buildInfoItem('Ubicación', conversation.userLocation ?? 'No disponible', icon: CupertinoIcons.location),
                _buildInfoItem('Años de experiencia', conversation.userExperienceYears?.toString() ?? 'No disponible', icon: CupertinoIcons.clock),
                _buildInfoItem('Nivel de carrera', conversation.userCareerLevel ?? 'No disponible', icon: CupertinoIcons.chart_bar),
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
                _buildInfoItem('Disponibilidad', conversation.userAvailability ?? 'No disponible', icon: CupertinoIcons.calendar),
                _buildInfoItem('Expectativa salarial', conversation.userSalaryExpectation ?? 'No disponible', icon: CupertinoIcons.money_dollar),
                _buildInfoItem('Tipo de empresa', conversation.userCompanySizePreference ?? 'No disponible', icon: CupertinoIcons.building_2_fill),
                _buildInfoItem('Modalidad de trabajo', conversation.userWorkModePreference ?? 'No disponible', icon: CupertinoIcons.briefcase),
                if (conversation.userIndustryPreference != null && conversation.userIndustryPreference!.isNotEmpty)
                  _buildInfoItem('Industrias de interés', conversation.userIndustryPreference!.join(', '), icon: CupertinoIcons.building_2_fill),
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
                _buildInfoItem('Username', conversation.username ?? 'No disponible', icon: CupertinoIcons.at),
                if (conversation.userCurrentEmotion != null)
                  _buildInfoItem('Estado emocional', _getEmotionDisplayName(conversation.userCurrentEmotion!), icon: CupertinoIcons.heart),
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppConstants.textTertiary.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: AppConstants.cardShadow,
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
                    colors: [Color(0xFF5B1DF4), Color(0xFF8B5CF6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF5B1DF4).withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    _getEmotionImagePath(conversation.userCurrentEmotion ?? 'neutral'),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getEmotionColor(conversation.userCurrentEmotion ?? 'neutral').withOpacity(0.2),
                        ),
                        child: Icon(
                          CupertinoIcons.smiley,
                          color: _getEmotionColor(conversation.userCurrentEmotion ?? 'neutral'),
                          size: 40,
                        ),
                      );
                    },
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
                  style: GoogleFonts.poppins(
                    color: AppConstants.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                // Estado emocional en español
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getEmotionColor(conversation.userCurrentEmotion ?? 'neutral').withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _getEmotionColor(conversation.userCurrentEmotion ?? 'neutral').withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _getEmotionDisplayName(conversation.userCurrentEmotion ?? 'neutral'),
                    style: GoogleFonts.poppins(
                      color: _getEmotionColor(conversation.userCurrentEmotion ?? 'neutral'),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.1,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (conversation.userProfession != null)
                  Text(
                    conversation.userProfession!,
                    style: GoogleFonts.manrope(
                      color: AppConstants.textSecondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.2,
                    ),
                  ),
                const SizedBox(height: 8),
                if (conversation.userLocation != null)
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.location,
                        color: AppConstants.primaryColor,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        conversation.userLocation!,
                        style: GoogleFonts.manrope(
                          color: AppConstants.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppConstants.textTertiary.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: AppConstants.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: AppConstants.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, {IconData? icon}) {
    final bool isAvailable = value != 'No disponible';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAvailable 
            ? Colors.white
            : AppConstants.textTertiary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAvailable 
            ? AppConstants.primaryColor.withValues(alpha: 0.2)
            : AppConstants.textTertiary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icono
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isAvailable 
                ? const Color(0xFF5B1DF4).withOpacity(0.2)
                : const Color(0xFF2D2D2D).withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon ?? CupertinoIcons.info_circle,
              color: isAvailable 
                ? AppConstants.primaryColor
                : AppConstants.textTertiary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // Contenido
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.manrope(
                    color: AppConstants.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.manrope(
                    color: isAvailable ? AppConstants.textPrimary : AppConstants.textTertiary,
                    fontSize: 16,
                    fontWeight: isAvailable ? FontWeight.w600 : FontWeight.w400,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
          // Indicador de estado
          if (isAvailable)
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppConstants.successColor,
                shape: BoxShape.circle,
              ),
            )
          else
            Icon(
              CupertinoIcons.minus_circle,
              color: AppConstants.textTertiary.withValues(alpha: 0.5),
              size: 16,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF5B1DF4), Color(0xFF8B5CF6)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5B1DF4).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          skill,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.1,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF10B981), Color(0xFF34D399)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF10B981).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          language,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.1,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF59E0B).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          interest,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.1,
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildLinkItem(String label, String url) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.manrope(
                color: AppConstants.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.1,
              ),
            ),
          ),
          Text(
            ': ',
            style: TextStyle(
              color: AppConstants.textSecondary,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                // TODO: Abrir enlace
              },
              child: Text(
                url,
                style: GoogleFonts.manrope(
                  color: AppConstants.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.1,
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
            Text(
              'Completitud del perfil',
              style: GoogleFonts.manrope(
                color: AppConstants.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.1,
              ),
            ),
            Text(
              '$percentage%',
              style: GoogleFonts.manrope(
                color: AppConstants.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: AppConstants.textTertiary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage / 100,
            child: Container(
              decoration: BoxDecoration(
                gradient: AppConstants.primaryGradient,
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

  String _getEmotionImagePath(String emotion) {
    switch (emotion.toLowerCase()) {
      // POSITIVAS
      case 'happy':
        return 'assets/images/emotions/happy.png';
      case 'excited':
        return 'assets/images/emotions/excited.png';
      case 'hopeful':
        return 'assets/images/emotions/hopeful.png';
      case 'grateful':
        return 'assets/images/emotions/grateful.png';
      case 'calm':
        return 'assets/images/emotions/calm.png';
      // NEGATIVAS
      case 'sad':
        return 'assets/images/emotions/sad.png';
      case 'angry':
        return 'assets/images/emotions/angry.png';
      case 'stressed':
        return 'assets/images/emotions/stressed.png';
      case 'disappointed':
        return 'assets/images/emotions/disappointed.png';
      // NEUTRAS
      case 'confused':
        return 'assets/images/emotions/confused.png';
      case 'curious':
        return 'assets/images/emotions/curious.png';
      case 'neutral':
        return 'assets/images/emotions/neutral.png';
      // Compatibilidad con emociones antiguas
      case 'anxious':
        return 'assets/images/emotions/stressed.png';
      case 'confident':
        return 'assets/images/emotions/happy.png';
      default:
        return 'assets/images/emotions/neutral.png';
    }
  }

  String _getEmotionDisplayName(String emotion) {
    switch (emotion.toLowerCase()) {
      // POSITIVAS
      case 'happy':
        return 'Feliz';
      case 'excited':
        return 'Emocionado';
      case 'hopeful':
        return 'Esperanzado';
      case 'grateful':
        return 'Agradecido';
      case 'calm':
        return 'Calmado';
      // NEGATIVAS
      case 'sad':
        return 'Triste';
      case 'angry':
        return 'Enojado';
      case 'stressed':
        return 'Estresado';
      case 'disappointed':
        return 'Decepcionado';
      // NEUTRAS
      case 'confused':
        return 'Confundido';
      case 'curious':
        return 'Curioso';
      case 'neutral':
        return 'Neutral';
      // Compatibilidad con emociones antiguas
      case 'anxious':
        return 'Ansioso';
      case 'confident':
        return 'Confiado';
      default:
        return 'Neutral';
    }
  }
}
