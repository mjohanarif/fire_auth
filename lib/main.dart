import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
      home: Scaffold(
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
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String error = '';
  String verificationId = '';
  bool isLoading = false;

  void setIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Visibility(
              visible: error.isNotEmpty,
              child: MaterialBanner(
                backgroundColor: Theme.of(context).errorColor,
                content: Text(error),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        error = '';
                      });
                    },
                    child: const Text(
                      'dismiss',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
                contentTextStyle: const TextStyle(color: Colors.white),
                padding: const EdgeInsets.all(10),
              ),
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value != null && value.isNotEmpty ? null : 'Required',
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value != null && value.isNotEmpty ? null : 'Required',
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : _emailAndPassword,
                child: isLoading
                    ? const CircularProgressIndicator.adaptive()
                    : const Text('email password'),
              ),
            ),
            Row(
              children: [
                const Text('Already have an Account?'),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => SignUpPage(auth: _auth))),
                  ),
                  child: const Text('sign up'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _emailAndPassword() async {
    if (formKey.currentState?.validate() ?? false) {
      setIsLoading();

      try {
        await _auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          error = '${e.message}';
        });
      } catch (e) {
        setState(() {
          error = '$e';
        });
      } finally {
        setIsLoading();
      }
    }
  }
}

class SignUpPage extends StatefulWidget {
  final dynamic auth;
  const SignUpPage({
    Key? key,
    required this.auth,
  }) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String error = '';
  String verificationId = '';
  bool isLoading = false;

  void setIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Visibility(
              visible: error.isNotEmpty,
              child: MaterialBanner(
                backgroundColor: Theme.of(context).errorColor,
                content: Text(error),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        error = '';
                      });
                    },
                    child: const Text(
                      'dismiss',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
                contentTextStyle: const TextStyle(color: Colors.white),
                padding: const EdgeInsets.all(10),
              ),
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value != null && value.isNotEmpty ? null : 'Required',
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value != null && value.isNotEmpty ? null : 'Required',
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : _emailAndPassword,
                child: isLoading
                    ? const CircularProgressIndicator.adaptive()
                    : const Text('email password'),
              ),
            ),
            Row(
              children: [
                const Text('Already have an Account?'),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => SignUpPage(auth: _auth))),
                  ),
                  child: const Text('sign up'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _emailAndPassword() async {
    if (formKey.currentState?.validate() ?? false) {
      setIsLoading();
      try {
        await _auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          error = '${e.message}';
        });
      } catch (e) {
        setState(() {
          error = '$e';
        });
      } finally {
        setIsLoading();
      }
    }
  }
}

class HomePage extends StatelessWidget {
  final dynamic auth;
  const HomePage({
    Key? key,
    required this.auth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Welcome ' + auth.currentUser!.email + 'to home page'),
          IconButton(
            onPressed: () {
              auth.signOut();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
    );
  }
}
