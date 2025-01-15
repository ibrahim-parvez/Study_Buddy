import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import '../../../constants.dart';
import '../../auth/sign_in_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String university = '';
  String email = '';
  String password = '';
  String matriculationDate = '';
  String graduationDate = '';
  String faculty = '';
  String program = '';
  bool _isLoading = false;
  bool _obscureText = true;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _obscurePassword = true;  // For password visibility
  bool _obscureConfirmPassword = true; 

  Future<void> _signUp() async {
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

      await conn.query(
        'INSERT INTO users (name, university, email, password, matriculationDate, graduationDate, faculty, program) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        [name, university, email, password, matriculationDate, graduationDate, faculty, program],
      );

    // Assuming the sign-up logic is handled earlier
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );

      // Close the connection and update the loading state
      await conn.close();
      setState(() {
        _isLoading = false;
      });
  }


  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isStartDate ? _startDate : _endDate)) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          matriculationDate = '${picked.year}-${picked.month}-${picked.day}';
        } else {
          _endDate = picked;
          graduationDate = '${picked.year}-${picked.month}-${picked.day}';
        }
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
            decoration: const InputDecoration(hintText: "Name"),
            onSaved: (value) {
              name = value!;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            decoration: const InputDecoration(hintText: "University"),
            onSaved: (value) {
              university = value!;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your university';
              }
              return null;
            },
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            decoration: const InputDecoration(hintText: "Email Address"),
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
          const SizedBox(height: defaultPadding), // For confirm password visibility

          TextFormField(
            obscureText: _obscurePassword,  // Use the separate variable for password
            decoration: InputDecoration(
              hintText: "Password",
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;  // Toggle visibility for password
                  });
                },
                child: _obscurePassword
                    ? const Icon(Icons.visibility_off, color: bodyTextColor)
                    : const Icon(Icons.visibility, color: bodyTextColor),
              ),
            ),
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
          // Start Date Field
          GestureDetector(
            onTap: () => _selectDate(context, true), // Tap to select start date
            child: AbsorbPointer(
              child: TextFormField(
                validator: (value) {
                  if (_startDate == null) {
                    return 'Start Date is required';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: _startDate == null
                      ? 'Start Date (DD/MM/YYYY)'
                      : 'Start Date: ${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                ),
                readOnly: true, // Make it read-only since it's handled by the date picker
              ),
            ),
          ),
          const SizedBox(height: 20),

          // End Date Field
          GestureDetector(
            onTap: () => _selectDate(context, false), // Tap to select end date
            child: AbsorbPointer(
              child: TextFormField(
                validator: (value) {
                  if (_endDate == null) {
                    return 'End Date is required';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: _endDate == null
                      ? 'End Date (DD/MM/YYYY)'
                      : 'End Date: ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                ),
                readOnly: true, // Make it read-only since it's handled by the date picker
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(hintText: "Faculty"),
            onSaved: (value) {
              faculty = value!;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your faculty';
              }
              return null;
            },
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            decoration: const InputDecoration(hintText: "Program"),
            onSaved: (value) {
              program = value!;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your program';
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
                      _signUp();
                    }
                  },
                  child: const Text('Sign Up'),
                ),
        ],
      ),
    );
  }
}
