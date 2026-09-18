import 'package:flutter/material.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final FirebaseAuth auth =
      FirebaseAuth.instance;

  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  Future<void> signUp() async {

    try {

      await auth.createUserWithEmailAndPassword(

        email: emailController.text.trim(),

        password:
        passwordController.text.trim(),
      );

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (context) =>
          const SpeakBridgeApp(),
        ),
      );
    }

    catch (e) {

      print(e);
    }
  }

  Future<void> login() async {

    try {

      await auth.signInWithEmailAndPassword(

        email: emailController.text.trim(),

        password:
        passwordController.text.trim(),
      );

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (context) =>
          const SpeakBridgeApp(),
        ),
      );
    }

    catch (e) {

      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF8F6EC),

      body: SafeArea(

        child: SingleChildScrollView(

          child: Padding(

            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 40,
            ),

            child: Column(

              children: [

                const SizedBox(height: 8),

                // LOGO
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),

                  child: Image.asset(
                    "assets/logo.png",
                    height: 180,
                  ),
                ),

                const SizedBox(height: 15),

                // TITLE
                const Text(
                  "Welcome to Speak Bridge",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7F5539),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "AI-powered passive English immersion for Indian households",
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFA68A64),
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 25),

                // EMAIL FIELD
            TextField(

              controller: emailController,



                  decoration: InputDecoration(

                    hintText: "Email",

                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Color(0xFFA8BE6F),
                    ),

                    filled: true,
                    fillColor: Colors.white,

                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // PASSWORD FIELD
                TextField(
                  controller: passwordController,

                  obscureText: true,

                  decoration: InputDecoration(

                    hintText: "Password",

                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Color(0xFFA8BE6F),
                    ),

                    filled: true,
                    fillColor: Colors.white,

                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // LOGIN BUTTON
                SizedBox(

                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(

                    onPressed: login,

                    style: ElevatedButton.styleFrom(

                      backgroundColor: const Color(0xFFA8BE6F),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),

                      elevation: 8,
                    ),

                    child: const Text(
                      "LOGIN",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // SIGNUP BUTTON
                SizedBox(

                  width: double.infinity,
                  height: 50,

                  child: OutlinedButton(

                    onPressed: signUp,

                    style: OutlinedButton.styleFrom(

                      side: const BorderSide(
                        color: Color(0xFFA8BE6F),
                        width: 2,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),

                    child: const Text(
                      "SIGN UP",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7F5539),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 17),

                const Text(
                  "Speak naturally. Connect deeply.",
                  style: TextStyle(
                    color: Color(0xFFA68A64),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}