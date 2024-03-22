import 'package:doan/Bloc/serviceBloc/serviceBloc.dart';
import 'package:doan/SignInScreen/LoginScreen.dart';
import 'package:doan/firebase_options.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Bloc/Schedude/schedude_bloc.dart';
import 'Bloc/sign_up/create_user_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessageBackgroundHandle);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<CreateUserBloc>(
          create: (context) => CreateUserBloc(),
        ),
        BlocProvider<AppointmentBloc>(
          create: (context) => AppointmentBloc(),
        ),
        BlocProvider<serviceBloc>(
          create: (context) => serviceBloc(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
@pragma('vm:entry-point')
Future<void>_firebaseMessageBackgroundHandle(RemoteMessage message)async{
  await Firebase.initializeApp();
  print(message.notification!.title.toString());
  print(message.notification!.body.toString());

}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return LoginScreen();
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
