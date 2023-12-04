import 'package:authen_firebase/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  initFirebase();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(padding: const EdgeInsets.all(10), child: const MyForm()),
      ),
    );
  }
}

initFirebase() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyForm();
  }
}

class _MyForm extends State<MyForm> {
  final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return (Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Center(
                    child: Text(
                  "Authentification",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                )),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _emailcontroller,
                  decoration: const InputDecoration(
                    labelText: "Enter Email",
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (val) {
                    if (val == null ||
                        val.isEmpty ||
                        !emailRegExp.hasMatch(val)) return ("Incorrect email");
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    controller: _passwordcontroller,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: "Enter password",
                        prefixIcon: Icon(Icons.lock))),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        authentification(context, _emailcontroller.text,
                            _passwordcontroller.text);
                      }
                    },
                    child: const Text("Sign IN"))
              ],
            ))));
  }

  authentification(BuildContext context, String emailAddress, password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      // ignore: use_build_context_synchronously
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Detail();
      }));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("User not found")));
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Wrong password")));
      }
    }
  }
}

class Detail extends StatelessWidget {
  const Detail({super.key});

  @override
  Widget build(BuildContext context) {
    return (MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text("title"),
      ),
      body: const Center(child: Text("Details")),
    )));
  }
}
