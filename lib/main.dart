import 'package:doan/LoginScreen.dart';
import 'package:doan/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  // khoi tao firebase
  const HomePage({
    super.key,
  });

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    // tra về giao diện đăng nhập
    return Scaffold(
      body: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return LoginScreen();
            }
            else{
            return const Center(
              child: CircularProgressIndicator(),
            );
            }
          }),
    );
  }
}