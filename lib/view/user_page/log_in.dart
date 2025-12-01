import 'package:flutter/material.dart';
import 'package:notflix/util/db.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<StatefulWidget> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  DbConnection? db; 
  String? errorMessage;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login () async {
    String email = _emailController.text;
    String password = _passwordController.text;

    setState(() {
      errorMessage = null;
    });

    if(email.isNotEmpty && password.isNotEmpty) {
      try {
        db = DbConnection();
      } catch(e) {
        print("Could not connect to DB!");
        setState(() {
          errorMessage = "Could not connect to database";
        });
        return;
      }
      try {
        bool goodRes = await db!.logInUser(email, password);
        if(goodRes) {
          print("Login successful!");
          Navigator.pop(context);
        } else {
          print("Login failed - invalid credentials");
          setState(() {
            errorMessage = "Invalid email or password";
          });
        }
      } catch (e) {
        print("Couldn't log in: $e");
        setState(() {
          errorMessage = "Login failed. Please try again.";
        });
      }

    } else {
      print("Email and password cannot be empty");
      setState(() {
        errorMessage = "Email and password cannot be empty";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _login(),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true, // Hides the input text
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _login(),
            ),
            SizedBox(height: 20),
            if (errorMessage != null)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade300, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red.shade700,
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        errorMessage!,
                        style: TextStyle(
                          color: Colors.red.shade900,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                // Navigate to registration page or handle "Forgot Password"
                print('Forgot Password / Register pressed');
              },
              child: Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}