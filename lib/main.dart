import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'pages/page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAP42iiGg0sZoE6dDuUgeXW0aHoAVWhNBg',
        appId: 'fireauth-4865c.firebaseapp.com',
        messagingSenderId: '355468251515',
        projectId: 'fireauth-4865c',
        authDomain: 'fireauth-4865c.firebaseapp.com',
        storageBucket: 'fireauth-4865c.appspot.com',
      ),
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Example App',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: SafeArea(
        child: Scaffold(
          body: LayoutBuilder(
            builder: (context, constraines) {
              return Row(
                children: [
                  Visibility(
                    visible: constraines.maxWidth >= 1200,
                    child: Expanded(
                      child: Container(
                        height: double.infinity,
                        color: Theme.of(context).colorScheme.primary,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Firebase Auth Desktop',
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: constraines.maxWidth >= 1200
                        ? constraines.maxWidth / 2
                        : constraines.maxWidth,
                    child: StreamBuilder<User?>(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return HomePage(
                            auth: FirebaseAuth.instance,
                          );
                        }
                        return const LoginPage();
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
