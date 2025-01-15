import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import '../../providers/course_model.dart';

const String geminiApiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=AddYourKey';  // Placeholder URL
const String apiKey = 'AddYourKey';  // Replace with your Gemini API key

class brAIny_ChatbotScreen extends StatefulWidget {
  final Course course;

  const brAIny_ChatbotScreen({
    super.key,
    required this.course,  // Constructor accepts the course
  });


  @override
  _brAIny_ChatbotScreenState createState() => _brAIny_ChatbotScreenState();
}

class _brAIny_ChatbotScreenState extends State<brAIny_ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final Gemini gemini = Gemini.instance;

  // Hidden query to customize chatbot behavior
  String get _hiddenQuery {
    return """
      You are a chatbot designed to help students with their course material.
      The class is "${widget.course.courseName}" with class code "${widget.course.courseCode}".
      Always provide relevant information from the textbook or class material and quiz the student on the topics they are learning.
      The textbook for this class is "${widget.course.textbook}". 
    """;
  }


  @override
  void initState() {
    super.initState();
    // Add an initial message from the chatbot
    _messages.add({
      "message": "Hello! I'm brAIny. I'm here to help you with your course material. What topic would you like to be quizzed on today? (I can also ask you questions from your textbook)",
      "isUser": false,
    });
  }

  void _sendMessage(String message) {
    // Append the hidden query to the user's input
    final customizedMessage = "$message\n$_hiddenQuery";

    setState(() {
      _messages.add({"message": "You: $message", "isUser": true});
    });

    // Send the customized message (with hidden query) to Gemini API
    gemini.chat([
      Content(parts: [Part.text(customizedMessage)], role: 'user'),
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
        title: const Text("Study With brAIny"),
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