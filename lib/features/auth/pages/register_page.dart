import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flashcards/features/home/pages/home_page.dart';
import 'package:flutter/material.dart';

import '../../../firebase_options.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        centerTitle: true,
      ),
      body: Center(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildUsernameInput(usernameController),
                  SizedBox(
                    height: 15,
                  ),
                  _buildPasswordInput(passwordController),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => HomePage()));
                          print("Hello: ${usernameController.text}");
                        }
                      },
                      child: Text("Submit"))
                ],
              ),
            )),
      ),
    );
  }

  Widget _buildUsernameInput(TextEditingController textEditingController) {
    return TextFormField(
      controller: textEditingController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter username';
        }
        return null;
      },
      decoration: InputDecoration(hintText: "Username"),
    );
  }

  Widget _buildPasswordInput(TextEditingController passwordControler) {
    return TextFormField(
      controller: passwordControler,
      validator: (value) {
        if (value == null) {
          return 'Enter password';
        }
        if (value.length < 4) {
          return 'Password is too short.';
        }
        return null;
      },
      decoration: InputDecoration(hintText: "Password"),
    );
  }

  // Widget _buildPasswordInput(){
  //   return TextFormField(
  //     controller: ,
  //   )
  // }

  Future<DocumentReference> addUser(String username) async {
    await Future.delayed(Duration(seconds: 1));
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final db = FirebaseFirestore.instance;

    final user = <String, dynamic>{
      "name": username,
      "born": 2002,
    };
    return db.collection("users").add(user);
  }
}
