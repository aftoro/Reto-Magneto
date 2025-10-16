import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/app_router.dart';
import 'core/config/supabase_config.dart';
import 'core/services/notification_display_service.dart';
import 'core/widgets/sse_initializer.dart';
import 'shared/theme/app_theme.dart';
import 'features/navigation/presentation/pages/main_app_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Supabase
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SSEInitializer(
      child: MaterialApp(
        title: 'magneto empleos',
        debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.dark,
            initialRoute: AppRouter.mainApp,
            onGenerateRoute: AppRouter.generateRoute,
            home: const MainAppPage(),
        scaffoldMessengerKey: NotificationDisplayService.scaffoldKey,
      ),
    );
  }
}
