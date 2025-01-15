import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import '../../providers/course_model.dart';

const String geminiApiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=AddYourKey';  // Placeholder URL
const String apiKey = 'AddYourKey';  // Replace with your Gemini API key

class FeynmanChatbot extends StatefulWidget {
  final Course course;

  const FeynmanChatbot({
    super.key,
    required this.course,  // Constructor accepts the course
  });

  @override
  _FeynmanChatbotScreenState createState() => _FeynmanChatbotScreenState();
}

class _FeynmanChatbotScreenState extends State<FeynmanChatbot> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final Gemini gemini = Gemini.instance;

  // Hidden query: This will now apply to every message
  String get _hiddenQuery {
    return """
      You are a chatbot designed to help students with the Feynman technique.
      The student is currently explaining a concept related to their course "${widget.course.courseName}" with class code "${widget.course.courseCode}".
      Please respond to the student's explanation by asking them questions from their explanation and providing feedback. If the student is answering questions, then score them and return an understanding score between 1 and 10.
    """;
  }

  // Function to send a message
  void _sendMessage(String message) {
    setState(() {
      _messages.add({"message": "You: $message", "isUser": true});
    });

    // Combine the hidden query with the user message
    String fullMessage = "$_hiddenQuery\n$message";

    gemini.chat([
      Content(parts: [Part.text(fullMessage)], role: 'user'),
    ]).then((response) {
      setState(() {
        // Add the chatbot's response
        _messages.add({
          "message": "Chatbot: ${response?.output ?? "No response"}",
          "isUser": false,
        });
      });
    }).catchError((e) {
      setState(() {
        _messages.add({"message": "Error: $e", "isUser": false});
      });
    });

    _controller.clear();
  }

  // Function to send the introductory message
void _sendIntroductoryMessage() {
setState(() {
_messages.add({
"message": """
Chatbot: Welcome to the Feynman Technique chatbot!
In this technique, you will explain a concept you've learned in ${widget.course.courseName} as if you're teaching it to someone else. 
After your explanation, I will ask questions to test your understanding. Then, I will provide an understanding rating between 1 and 10. 
Let's get started! 
""",
"isUser": false,
});
});
}

  @override
  void initState() {
    super.initState();
    // Start by sending the introductory message
    _sendIntroductoryMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feynman Chatbot"),
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
                      hintText: "Explain the concept you've learned...",
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
