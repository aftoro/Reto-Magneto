import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/simple_home_page.dart';
import '../../features/navigation/presentation/pages/main_app_page.dart';
import '../../features/messages/presentation/pages/send_message_page.dart';
import '../../features/messages/presentation/pages/conversations_page.dart';
import '../../features/posts/presentation/pages/create_post_page.dart';
import '../../features/posts/presentation/pages/create_story_page.dart';

class AppRouter {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String mainApp = '/main-app';
  static const String sendMessage = '/send-message';
  static const String conversations = '/conversations';
  static const String createPost = '/create-post';
  static const String createStory = '/create-story';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
      
      case register:
        return MaterialPageRoute(
          builder: (_) => const RegisterPage(),
          settings: settings,
        );
      
      case home:
        return MaterialPageRoute(
          builder: (_) => const SimpleHomePage(),
          settings: settings,
        );
      
      case mainApp:
        return MaterialPageRoute(
          builder: (_) => const MainAppPage(),
          settings: settings,
        );
      
      case sendMessage:
        return MaterialPageRoute(
          builder: (_) => const SendMessagePage(),
          settings: settings,
        );
      
      case conversations:
        return MaterialPageRoute(
          builder: (_) => const ConversationsPage(),
          settings: settings,
        );
      
      case createPost:
        return MaterialPageRoute(
          builder: (_) => const CreatePostPage(),
          settings: settings,
        );
      
      case createStory:
        return MaterialPageRoute(
          builder: (_) => const CreateStoryPage(),
          settings: settings,
        );
      
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Página no encontrada'),
            ),
          ),
        );
    }
  }
}
