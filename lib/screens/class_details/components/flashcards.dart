import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import '../../../providers/course_model.dart';

const String apiKey = 'AddYourKey';  // Replace with your Gemini API key

class Flashcards extends StatefulWidget {
  final Course course;
  const Flashcards({
    super.key,
    required this.course,  // Constructor accepts the course
  });

  @override
  _FlashcardsState createState() => _FlashcardsState();
}

class _FlashcardsState extends State<Flashcards> {
  final PageController _pageController = PageController();
  bool _isFront = true;
  List<Map<String, String>> _flashcards = [];
  final Gemini gemini = Gemini.instance;
  bool _isLoading = false;

  // Function to fetch flashcards from Gemini
  Future<void> _fetchFlashcards() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Sending the prompt to Gemini
      final response = await gemini.chat([
        Content(parts: [
          Part.text('Give me a list of terms and definitions for studying for ${widget.course.courseName} in this format. Do not include any unnecessary instructions as I need that format for parsing correctly.\n____________\nTerm - Definition\nTerm - Definition')
        ], role: 'user'),
      ]);

      // Assuming the response format gives you a list of terms and definitions
      final generatedContent = response?.output ?? 'No flashcards generated';
      
      // Parsing the content into terms and definitions
      final List<Map<String, String>> flashcards = _parseFlashcards(generatedContent);
      
      setState(() {
        _flashcards = flashcards;
      });
    } catch (e) {
      print('Failed to load flashcards: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to parse the flashcards from the generated content
  List<Map<String, String>> _parseFlashcards(String content) {
    final List<Map<String, String>> flashcards = [];
    final lines = content.split('\n');
    for (var line in lines) {
      if (line.contains(' - ')) {
        final parts = line.split(' - ');
        if (parts.length == 2) {
          flashcards.add({'term': parts[0].trim(), 'definition': parts[1].trim()});
        }
      }
    }
    return flashcards;
  }

  void _flipCard() {
    setState(() {
      _isFront = !_isFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _flashcards.isEmpty
              ? Center(
                  child: SizedBox(
                    width: 200, // Set the desired width
                    child: ElevatedButton(
                      onPressed: _fetchFlashcards,
                      child: const Text('Make Flashcards'),
                    ),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _flashcards.length,
                        itemBuilder: (context, index) {
                          final flashcard = _flashcards[index];
                          return GestureDetector(
                            onTap: _flipCard,
                            child: Card(
                              margin: const EdgeInsets.all(16.0),
                              child: Center(
                                child: Text(
                                  _isFront ? flashcard['term']! : flashcard['definition']!,
                                  style: Theme.of(context).textTheme.headlineMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            if (_pageController.page! > 0) {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.flip),
                          onPressed: _flipCard,
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: () {
                            if (_pageController.page! < _flashcards.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
    );
  }
}