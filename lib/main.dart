import 'package:flutter/material.dart';
import 'constants.dart';
import 'screens/onboarding/onboarding_scrreen.dart';
import 'screens/auth/sign_in_screen.dart'; // Import the SignInScreen
import 'screens/home/home_screen.dart'; // Import the HomeScreen
import 'screens/auth/sign_up_screen.dart'; // Import the SignUpScreen
import 'entry_point.dart';
import 'package:provider/provider.dart'; // Import the provider package
import 'providers/user_provider.dart'; // Import your UserProvider

import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_cohere/flutter_cohere.dart';

const apiKey = 'AddYourKey';

void main() {
  Gemini.init(apiKey: apiKey);
  var co = CohereClient(apiKey: 'AddYourKey');
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(), // Create and provide UserProvider
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Study Buddy - An Educational Assistant',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: bodyTextColor),
            bodySmall: TextStyle(color: bodyTextColor),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            contentPadding: EdgeInsets.all(defaultPadding),
            hintStyle: TextStyle(color: bodyTextColor),
          ),
        ),
        home: const OnboardingScreen(),
        routes: {
          '/sign_in': (context) => const SignInScreen(),
          '/home': (context) => const EntryPoint(), // Define home route
          '/sign_up': (context) => const SignUpScreen(),
        },
        // Optional: onGenerateRoute for dynamic routing
        onGenerateRoute: (settings) {
          if (settings.name == '/home') {
            return MaterialPageRoute(builder: (context) => const HomeScreen());
          }
          // Handle other routes as needed
          return null; // Return null for routes not explicitly handled
        },
        // Optional: onUnknownRoute for undefined routes
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => const UnknownRouteScreen(),
          );
        },
      ),
    );
  }
}

class UnknownRouteScreen extends StatelessWidget {
  const UnknownRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Unknown Route")),
      body: const Center(
        child: Text('Unknown Route, 404!'),
      ),
    );
  }
}
