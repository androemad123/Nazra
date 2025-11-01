import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nazra/app/nazra_app.dart';
import 'package:nazra/app/providers/language_provider.dart';
import 'package:nazra/app/providers/theme_provider.dart';
import 'package:nazra/routing/app_router.dart';
import 'package:provider/provider.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Bloc imports
import 'app/bloc/location_bloc/location_bloc.dart';
import 'app/services/location_service.dart';
import 'app/repositories/auth_repository.dart';
import 'app/bloc/auth/auth_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();

  // ✅ Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ Initialize services
  final appRouter = AppRouter();
  final authRepository = AuthRepository();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => LocationBloc(LocationService())),
          BlocProvider(create: (_) => AuthBloc(authRepository: authRepository)),
        ],
        child: NazraApp.getInstance(appRouter),
      ),
    ),
  );
}
