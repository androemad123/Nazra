import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nazra/app/nazra_app.dart';
import 'package:nazra/app/providers/language_provider.dart';
import 'package:nazra/app/providers/theme_provider.dart';
import 'package:nazra/routing/app_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nazra/routing/routes.dart';

// Bloc imports
import 'app/bloc/location_bloc/location_bloc.dart';
import 'app/services/location_service.dart';
import 'app/repositories/auth_repository.dart';
import 'app/bloc/auth/auth_bloc.dart';
import 'app/bloc/notification/notification_bloc.dart';
import 'app/repositories/notification_repository.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Handling a background message: ${message.messageId}");
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await ScreenUtil.ensureScreenSize();

  // ✅ Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ FCM Setup
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  final messaging = FirebaseMessaging.instance;
  
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  // Print FCM Token for testing
  final fcmToken = await messaging.getToken();
  print('FCM Token: $fcmToken');

  // Foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  // Background/Terminated tap
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
    navigatorKey.currentState?.pushNamed(Routes.notificationsScreen);
  });
  
  // Check if app was opened from a terminated state
  final initialMessage = await messaging.getInitialMessage();
  if (initialMessage != null) {
     Future.delayed(Duration(seconds: 1), () {
        navigatorKey.currentState?.pushNamed(Routes.notificationsScreen);
     });
  }

  // ✅ Load user preferences before building the app
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  final languageCode = prefs.getString('languageCode') ?? 'en';

  // ✅ Initialize services
  final appRouter = AppRouter();
  final authRepository = AuthRepository();
  final notificationRepository = NotificationRepository();

  // ✅ Determine Initial Route
  final user = await authRepository.currentUser;
  String initialRoute = Routes.onboardingRoute;

  if (user != null) {
    if (user.role == 'admin') {
      initialRoute = Routes.adminHomeScreen;
    } else {
      initialRoute = Routes.homeScreenState;
    }
  }
  final cloudDNS = dotenv.env['CLOUDINARY_CLOUD_DNS'];
  if (cloudDNS == null || cloudDNS.isEmpty) {
    throw StateError(
      'CLOUDINARY_CLOUD_DNS is not set. Please add it to your .env file.',
    );
  }
  if (kReleaseMode) {
    await SentryFlutter.init(
          (options) {
        options.dsn =
            cloudDNS;

        // Capture 1% of transactions in production
        options.tracesSampleRate = 0.01;
      },
      appRunner: () => runApp(
        SentryWidget(
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => ThemeProvider(isDarkMode),
              ),
              ChangeNotifierProvider(
                create: (_) => LanguageProvider(languageCode),
              ),
            ],
            child: MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => LocationBloc(LocationService())),
                BlocProvider(
                    create: (_) => AuthBloc(authRepository: authRepository)),
                BlocProvider(
                    create: (_) => NotificationBloc(notificationRepository: notificationRepository)),
              ],
              child: NazraApp.getInstance(appRouter, navigatorKey, initialRoute),
            ),
          ),
        ),
      ),
    );
  } else {
    // When NOT in release mode → run without Sentry
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ThemeProvider(isDarkMode),
          ),
          ChangeNotifierProvider(
            create: (_) => LanguageProvider(languageCode),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => LocationBloc(LocationService())),
            BlocProvider(
                create: (_) => AuthBloc(authRepository: authRepository)),
            BlocProvider(
                create: (_) => NotificationBloc(notificationRepository: notificationRepository)),
          ],
          child: NazraApp.getInstance(appRouter, navigatorKey, initialRoute),
        ),
      ),
    );
  }
}
