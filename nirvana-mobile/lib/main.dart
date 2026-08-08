import 'package:flutter/material.dart';
import 'presentation/pages/splash_screen.dart';
import 'presentation/pages/login_screen.dart';
import 'presentation/pages/dashboard_screen.dart';
import 'config/routes.dart';
import 'config/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize secure storage
  // await SecureStorageService.init();
  
  // Initialize local database for offline support
  // await DatabaseHelper.initDatabase();
  
  runApp(const NirvanaMobileApp());
}

class NirvanaMobileApp extends StatelessWidget {
  const NirvanaMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nirvana Digital Mobile',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: Routes.splash,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
