import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/providers/project_provider.dart';

// Core Screens
import 'package:frontend/features/auth/screens/welcome_screen.dart';
import 'package:frontend/features/auth/screens/login_screen.dart';
import 'package:frontend/features/auth/screens/create_account_screen.dart';
import 'package:frontend/features/dashboard/screens/home_screen.dart';
import 'package:frontend/features/dashboard/screens/history_screen.dart';
import 'package:frontend/features/dashboard/screens/profile_screen.dart';
import 'package:frontend/features/dashboard/screens/processing_screen.dart';
import 'package:frontend/features/dashboard/screens/preview_payment_screen.dart';

// Structure Screens
import 'package:frontend/features/structure/screens/result_structure_safety_screen.dart';
import 'package:frontend/features/structure/screens/result_structure_plan_screen.dart';
import 'package:frontend/features/structure/screens/result_structure_schedule_screen.dart';
import 'package:frontend/features/structure/screens/result_structure_quantity_screen.dart';
import 'package:frontend/features/structure/screens/result_structure_3d_footing_screen.dart';
import 'package:frontend/features/structure/screens/result_structure_3d_frame_screen.dart';
import 'package:frontend/features/structure/screens/result_structure_3d_slab_screen.dart';
import 'package:frontend/features/structure/screens/result_3d_model_screen.dart';

// Vastu Screens
import 'package:frontend/features/vastu/screens/result_vastu_score_screen.dart';
import 'package:frontend/features/vastu/screens/result_vastu_rooms_screen.dart';
import 'package:frontend/features/vastu/screens/result_vastu_fixes_screen.dart';

// Cost Screens
import 'package:frontend/features/cost_estimation/screens/result_cost_tiers_screen.dart';
import 'package:frontend/features/cost_estimation/screens/result_cost_stages_screen.dart';
import 'package:frontend/features/cost_estimation/screens/result_cost_boq_screen.dart';
import 'package:frontend/features/cost_estimation/screens/result_cost_search_result_screen.dart';
import 'package:frontend/core/providers/app_config_provider.dart';

void main() {
  runApp(const MyApp());
}

final _router = GoRouter(
  initialLocation: '/welcome',
  routes: [
    // Auth & Main
    GoRoute(path: '/welcome', builder: (context, state) => const WelcomeScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/create_account', builder: (context, state) => const CreateAccountScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/history', builder: (context, state) => const HistoryScreen()),
    GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
    GoRoute(
      path: '/processing', 
      builder: (context, state) {
        final fileData = state.extra as Map<String, String>?;
        return ProcessingScreen(fileData: fileData);
      }
    ),
    GoRoute(
      path: '/preview_payment',
      builder: (context, state) {
        final fileData = state.extra as Map<String, String>?;
        return PreviewPaymentScreen(fileData: fileData);
      }
    ),
    
    // Structure
    GoRoute(path: '/result/structure/safety', builder: (context, state) => const ResultStructureSafetyScreen()),
    GoRoute(path: '/result/structure/plan', builder: (context, state) => const ResultStructurePlanScreen()),
    GoRoute(path: '/result/structure/schedule', builder: (context, state) => const ResultStructureScheduleScreen()),
    GoRoute(path: '/result/structure/quantity', builder: (context, state) => const ResultStructureQuantityScreen()),
    GoRoute(path: '/result/3d_model', builder: (context, state) => const Result3dModelScreen()),
    GoRoute(path: '/result/structure/3d/footing', builder: (context, state) => const ResultStructure3dFootingScreen()),
    GoRoute(path: '/result/structure/3d/frame', builder: (context, state) => const ResultStructure3dFrameScreen()),
    GoRoute(path: '/result/structure/3d/slab', builder: (context, state) => const ResultStructure3dSlabScreen()),

    // Vastu
    GoRoute(path: '/result/vastu/score', builder: (context, state) => const ResultVastuScoreScreen()),
    GoRoute(path: '/result/vastu/rooms', builder: (context, state) => const ResultVastuRoomsScreen()),
    GoRoute(path: '/result/vastu/fixes', builder: (context, state) => const ResultVastuFixesScreen()),

    // Cost
    GoRoute(path: '/result/cost/tiers', builder: (context, state) => const ResultCostTiersScreen()),
    GoRoute(path: '/result/cost/stages', builder: (context, state) => const ResultCostStagesScreen()),
    GoRoute(path: '/result/cost/boq', builder: (context, state) => const ResultCostBoqScreen()),
    GoRoute(path: '/result/cost/search', builder: (context, state) => const ResultCostSearchResultScreen()),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppConfigProvider()),
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
      ],
      child: Builder(
        builder: (context) {
          final config = context.watch<AppConfigProvider>();
          return MaterialApp.router(
            title: 'Kanavu Illam',
            themeMode: config.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData(
              scaffoldBackgroundColor: const Color(0xFFF3F3F3),
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.black, brightness: Brightness.light),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              scaffoldBackgroundColor: const Color(0xFF111317),
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.white, brightness: Brightness.dark),
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
