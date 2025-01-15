import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:intl/intl.dart'; 

import '../../components/buttons/socal_button.dart';
import '../../components/welcome_text.dart';
import '../../constants.dart';
import 'sign_up_screen.dart';
import '../../providers/user_provider.dart'; // Import UserProvider
import '../../providers/user_model.dart'; // Import UserProvider

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: const Text("Sign In"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WelcomeText(
                title: "Welcome to STUDY BUDDY",
                text: "Sign in to continue",
              ),
              const SizedBox(height: defaultPadding * 2),
              const SignInForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool _isLoading = false;

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'sql5.freesqldatabase.com',
      port: 3306,
      user: 'sql5757142',
      db: 'sql5757142',
      password: 'tghuKCuYTv',
    ));

    try {
      var results = await conn.query(
        'SELECT * FROM users WHERE email = ? AND password = ?',
        [email, password],
      );

      if (results.isNotEmpty) {
        // User found, create a User object and save it to the UserProvider
        var userData = results.first;

        // Ensure the matriculation and graduation dates are parsed as DateTime
        DateTime? matriculationDate = userData['matriculation_date'] != null
            ? DateTime.tryParse(userData['matriculation_date'])
            : null;

        DateTime? graduationDate = userData['graduation_date'] != null
            ? DateTime.tryParse(userData['graduation_date'])
            : null;

        final user = User(
          id: userData['id'],
          name: userData['name'],
          email: userData['email'],
          university: userData['university'],
          faculty: userData['faculty'],
          program: userData['program'],
          matriculationDate: matriculationDate, // Now passing DateTime
          graduationDate: graduationDate,       // Now passing DateTime
        );

        // Update the UserProvider
        Provider.of<UserProvider>(context, listen: false).setUser(user);

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // User not found, show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      await conn.close();
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Email'),
            onSaved: (value) {
              email = value!;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            onSaved: (value) {
              password = value!;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(height: defaultPadding),
          _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _signIn();
                    }
                  },
                  child: const Text('Sign In'),
                ),
          const SizedBox(height: defaultPadding),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()),
              );
            },
            child: const Text('Don\'t have an account? Sign Up'),
          ),
        ],
      ),
    );
  }
}
