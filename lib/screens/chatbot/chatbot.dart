import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'package:flutter_cohere/flutter_cohere.dart';

const String cohereApiKey = 'AddYourKey'; 


const String geminiApiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=AddYourKey';  // Placeholder URL
const String apiKey = 'AddYourKey';  // Replace with your Gemini API key

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final Gemini gemini = Gemini.instance;

  // Hidden message providing context to the AI
  String _hiddenContext = """
      You are an AI Study Assistant helping the user manage their study schedule, class-related events, assignments, and other academic-related tasks.
      Your role is to answer questions about their calendar, upcoming assignments, and provide study-related assistance. For testing purposes, here is a 
      sample data i want you to use to reply to the user. 
      {
        "student": "John Doe",
        "schedule": [
          {
            "date": "2025-01-14",
            "events": [
              {
                "event": "Midterm exam for COMPSCI 2C03"
              }
            ]
          },
          {
            "date": "2025-01-21",
            "events": [
              {
                "event": "Complete homework assignment COMPSCI 2C03"
              }
            ]
          },
          {
            "date": "2025-01-28",
            "events": [
              {
                "event": "Final exam for COMPSCI 2C03"
              }
            ]
          }
        ],
        "assignments": [
          {
            "name": "Homework Assignment",
            "due_date": "2025-01-21",
            "description": "Complete the assignment on COMPSCI 2C03"
          }
        ],
        "midterms": [
          {
            "name": "Midterm Exam",
            "date": "2025-01-14",
            "description": "Midterm covering COMPSCI 2C03 "
          }
        ],
        "extracurriculars": []
      }

    """;

  @override
  void initState() {
    super.initState();
    // Send an initial greeting message
    _sendInitialMessage();
  }

  // Function to send the initial message
  void _sendInitialMessage() {
    setState(() {
      _messages.add({
        "message": "Hi! I'm your personal AI Study Buddy. 😊\n\n"
            "I will help you manage your classes, schedule, calendar, and more.\n\n"
            "You can ask me questions like, 'What's my next event on my calendar?' or 'What are my upcoming assignments?'.\n\n"
            "Let's get started! Feel free to ask me anything.",
        "isUser": false,
      });
    });
  }

  // Function to update the hidden context
  void _updateHiddenContext(String newContext) {
    setState(() {
      _hiddenContext += "\n$newContext";
    });
  }

  // Function to send messages to the chatbot
  void _sendMessage(String message) {
    setState(() {
      _messages.add({"message": "You: $message", "isUser": true});
    });

    // Combine the hidden context and the user's message
    String fullMessage = "$_hiddenContext\n$message";

    gemini.chat([
      Content(parts: [Part.text(fullMessage)], role: 'user'),
    ]).then((response) {
      setState(() {
        _messages.add({
          "message": response?.output ?? "No response",
          "isUser": false,
          "image": "../../../assets/Illustrations/ai-mi-algorithm-svgrepo-com.svg"
        });
      });
    }).catchError((e) {
      setState(() {
        _messages.add({"message": "Error: $e", "isUser": false});
      });
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Study Assistant"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Align(
                    alignment: message["isUser"] ? Alignment.centerRight : Alignment.centerLeft,
                    child: Card(
                      color: message["isUser"] ? Colors.blue[100] : Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          message["message"],
                          style: TextStyle(
                            color: message["isUser"] ? Colors.black : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Ask a question...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _sendMessage(_controller.text);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
