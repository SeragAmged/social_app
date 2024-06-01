import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/network/remote/firebase_constants.dart';
import 'package:social_app/shared/network/remote/firebase_options.dart';
import 'package:social_app/layout/app_layout.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/shared/components/variables.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'bloc_observer.dart';
import 'styles/styles.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> _remoteMessageHandler(RemoteMessage message) async {
  print('message: ${message.data}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  String? token = await FirebaseMessaging.instance.getToken();
  print('token: ${token!}');

  FirebaseMessaging.onMessage.listen((event) {
    print('event: ${event.data}');
  });

  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print('event: ${event.data}');
  });

  FirebaseMessaging.onBackgroundMessage(_remoteMessageHandler);

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();

  uId = CacheHelper.getData(key: userCollectionId) ?? '';
  firstLogin = CacheHelper.getData(key: "firstLogin") ?? '';

  Widget startWidget() => uId.isNotEmpty ? const AppLayout() : LoginScreen();

  bool isDark = CacheHelper.getData(key: "isDark") ?? false;

  runApp(
    MyApp(
      startWidget(),
      isDark: isDark,
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isDark;

  const MyApp(this.startWidget, {super.key, required this.isDark});

  final Widget startWidget;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppCubit()
            ..changeMode(fromShared: isDark)
            ..getUserData()
            ..getPosts()
            ..getUsers(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            title: 'Social app',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode:
                AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}
