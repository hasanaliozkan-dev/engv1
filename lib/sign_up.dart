import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'sign_in.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool showProgress = false;

  final _formkey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpassController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool _isObscure = true;
  bool _isObscure2 = true;

  int? department;
  int? grade;
  String role = "teacher";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(12),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 40),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      },
                    ),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(24.0),
                  child: const Image(
                    image: AssetImage('assets/logononame.png'),
                    height: 150,
                    width: 150,
                  ),
                ),
                const SizedBox(height: 50),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Email',
                    contentPadding: const EdgeInsets.all(14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email cannot be empty";
                    }
                    if (!RegExp(r"[A-Za-z0-9._%+-]+@(posta\.mu\.edu\.tr|mu\.edu\.tr)")
                        .hasMatch(value)) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Password',
                    contentPadding: const EdgeInsets.all(14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password cannot be empty";
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: confirmpassController,
                  obscureText: _isObscure2,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                          _isObscure2 ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _isObscure2 = !_isObscure2;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Confirm Password',
                    contentPadding: const EdgeInsets.all(14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value != passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        hint: const Text("Department"),
                        items: const [
                          DropdownMenuItem(value: 0, child: Text("Computer E.")),
                          DropdownMenuItem(value: 1, child: Text("Software E.")),
                          DropdownMenuItem(value: 2, child: Text("Civil E.")),
                          DropdownMenuItem(value: 3, child: Text("Electrical and Electronics E.")),
                          DropdownMenuItem(value: 4, child: Text("Metallurgy and Materials E.")),
                          DropdownMenuItem(value: 5, child: Text("Geological E.")),
                          DropdownMenuItem(value: 6, child: Text("Mining E.")),
                        ],
                        onChanged: (value) {
                          department = value;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        hint: const Text("Grade"),
                        items: const [
                          DropdownMenuItem(value: 0, child: Text("Prep School")),
                          DropdownMenuItem(value: 1, child: Text("1st Grade")),
                          DropdownMenuItem(value: 2, child: Text("2nd Grade")),
                          DropdownMenuItem(value: 3, child: Text("3rd Grade")),
                          DropdownMenuItem(value: 4, child: Text("4th Grade")),
                          DropdownMenuItem(value: 5, child: Text("Graduated")),
                        ],
                        onChanged: (value) {
                          grade = value;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                showProgress
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      setState(() {
                        showProgress = true;
                      });
                      if (emailController.text.contains("posta")) {
                        role = "student";
                      }
                      signUp(emailController.text, passwordController.text);
                    }
                  },
                  child: const Text("Sign Up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      postDetailsToFirestore(email);
    } catch (e) {
      setState(() {
        showProgress = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
        backgroundColor: Colors.red,
      ));
    }
  }

  void postDetailsToFirestore(String email) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;

    CollectionReference ref = firestore.collection('users');
    if (role == "student") {
      ref.doc(user!.uid).set({
        'email': email,
        'role': role,
        'department': department,
        'grade': grade,
        'received_messages': []
      });
    } else {
      ref.doc(user!.uid).set({'email': email, 'role': role});
    }

    setState(() {
      showProgress = false;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }
}
