# fire_auth

Flutter firebase authentication.

## Getting Started

### Requirement

Berikut beberapa hal yang perlu Anda persiapkan sebelum setup Boilerplate ini:

1. Flutter SDK Stable (Recommend version 2.10.5) [Install](https://flutter.dev/docs/get-started/install)
2. Android Studio [Install](https://developer.android.com/studio)
3. Visual Studio Code (Optional) [Install](https://code.visualstudio.com/)
4. Extension **Dart** dan **Flutter**:
    - Pengguna **Intellij Platform** ([Dart](https://plugins.jetbrains.com/plugin/6351-dart), [Flutter](https://plugins.jetbrains.com/plugin/9212-flutter))
    - Pengguna **Visual Studio Code** ([Dart](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code), [Flutter](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter))

## Setup

Untuk membuat ulang project project berdasarkan dengan repo ini, Anda perlu melakukan beberapa langkah-langkah yang perlu Anda lakukan. Berikut langhkah-langkah untuk menyiapkan Project ini:

**Step 1:**

Langkah pertama yaitu buat project baru pada flutter:

```bash
flutter create fire_auth
```

**Step 2:**

Kemudian jalankan perintah ini ke console:

```bash
flutter pub get
```

**Step 3: Setup Firebase**

Karena pada repo ini menggunkan teknologi dari firebase, maka Anda perlu mengkonfigurasinya terlebih dahulu sebelum Anda menjalankan aplikasi tersebut pertama kalinya. Berikut contoh/tutorial cara setup firebasenya:

### Android

1. Langkah pertama setup firebase pada Android yaitu create project anda terlebih dahulu di [firebase console](https://console.firebase.google.com/). Pastikan Android package name sesuai dengan nama aplikasi pada file android/app/build.gradle > applicationId
![image](https://user-images.githubusercontent.com/52303525/171988126-68400c41-1d8d-4a92-b743-a1b654ab61f4.png)


2. Download file `google-services.json`. Dan pindahkan ke folder android/app

3. Tambahkan "classpath 'com.google.gms:google-services:4.3.10'" pada android/build.gradle pada project flutter
![image](https://user-images.githubusercontent.com/52303525/171988216-1a328ac3-2ee0-45db-b47f-16b5b865d6f8.png)

4. Tambahkan juga "apply plugin: 'com.google.gms.google-services'" pada android/app/buid.gradle
![image](https://user-images.githubusercontent.com/52303525/171988344-678cd836-c4fc-42ac-b551-2764b3824bba.png)

5. Lalu Aktifkan authentikasi lewat email/password pada firebase console.

**Step 4:**

Tambakan kode berikut pada file `lib/main.dart`:
```dart
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
        apiKey: 'ISI SESUAI API KEY KONFIGURASI WEB',
        appId: 'ISI SESUAI APP ID KONFIGURASI WEB',
        messagingSenderId: 'ISI SESUAI messagingSenderId KONFIGURASI WEB',
        projectId: 'ISI SESUAI projectId KONFIGURASI WEB',
        authDomain: 'ISI SESUAI authDomain KONFIGURASI WEB',
        storageBucket: 'ISI SESUAI storageBucket KONFIGURASI WEB',
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


```

**Step 5:**

Kemudian buat file `login_page.dart` dan tambahkan code berikut:
```dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  TextEditingController nameController = TextEditingController();
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
    return Scaffold(
      body: SafeArea(
        child: Form(
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
                const Spacer(),
                const Text(
                  'Social Media',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
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
                        : const Text(
                            'Sign up',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
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


```

**Step 6:**

Kemudian buat file `home_page.dart` berikut codenya:
```dart

import 'package:flutter/material.dart';

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
          Text('Welcome ' + auth.currentUser!.email + ' to home page'),
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


```
