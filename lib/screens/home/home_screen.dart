import 'package:flutter/material.dart';
import '../../components/section_title.dart';
import '../../constants.dart';
import '../../screens/filter/filter_screen.dart';
import '../class_details/class_details_screen.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

import '../../providers/user_provider.dart'; // Make sure this is the correct import path
import '../../providers/user_model.dart';   // Ensure this is the correct import path
import '../../providers/course_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> selectedDays = [];


    // Define the courses separately
  List<Course> courses = [
    Course(
      courseId: 1,
      userId: 123,
      email: 'user@example.com',
      courseCode: "COMPSCI 2C03",
      courseName: "Data Structures & Algorithms",
      profName: "Dr. Prof 1",
      roomNum: "Room 101",
      courseStart: "2025-01-01",
      courseEnd: "2025-01-31",
      topics: "Testing",
      homeworkDue: "2025-01-15",
      midtermDate: "2025-01-10",
      finalExamDate: "2025-01-21",
      courseConfidence: 0.8,
      textbook: "Algorithms 4th Edition by Robert Sedgewick",
    ),
    Course(
      courseId: 2,
      userId: 123,
      email: 'user@example.com',
      courseCode: "COMPSCI 2F04",
      courseName: "Operating Systems",
      profName: "Dr. Prof 2",
      roomNum: "Room 102",
      courseStart: "2025-02-01",
      courseEnd: "2025-02-28",
      topics: "Processes, Threads, Memory Management",
      homeworkDue: "2025-02-15",
      midtermDate: "2025-02-10",
      finalExamDate: "2025-02-21",
      courseConfidence: 0.75,
      textbook: "Operating Systems Concepts 10th Edition",
    ),
    Course(
      courseId: 3,
      userId: 123,
      email: 'user@example.com',
      courseCode: "MATH 3A01",
      courseName: "Calculus I",
      profName: "Dr. Prof 3",
      roomNum: "Room 203",
      courseStart: "2025-03-01",
      courseEnd: "2025-03-31",
      topics: "Limits, Derivatives, Integrals",
      homeworkDue: "2025-03-15",
      midtermDate: "2025-03-10",
      finalExamDate: "2025-03-21",
      courseConfidence: 0.9,
      textbook: "Calculus: Early Transcendentals 8th Edition",
    ),
    Course(
      courseId: 4,
      userId: 123,
      email: 'user@example.com',
      courseCode: "PHYS 1B03",
      courseName: "Physics I: Mechanics",
      profName: "Dr. Prof 4",
      roomNum: "Room 304",
      courseStart: "2025-04-01",
      courseEnd: "2025-04-30",
      topics: "Kinematics, Newton's Laws, Energy",
      homeworkDue: "2025-04-15",
      midtermDate: "2025-04-10",
      finalExamDate: "2025-04-21",
      courseConfidence: 0.85,
      textbook: "University Physics 14th Edition by Young & Freedman",
    ),
  ];



  @override
  void initState() {
    super.initState();
    // Fetch courses when the screen is initialized
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user != null) {
      userProvider.fetchUserCourses();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: Column(
          children: [
            Text(
              "Study Buddy".toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: primaryColor),
            ),
            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                // Access the User object
                final user = userProvider.user;

                // If the user is null (e.g., not logged in), show a placeholder text
                if (user == null) {
                  return const Text(
                    "Welcome Back, Guest!",
                    style: TextStyle(color: Colors.black),
                  );
                }

                // If the user is logged in, show the user's name
                return Text(
                  "Welcome Back, ${user.name}!",
                  style: const TextStyle(color: Colors.black),
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(title: "Classes", press: () {}),
            const SizedBox(height: 16),

            // Now, we use the `courses` list and map over it to generate the class cards
              ...courses.map((course) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(defaultPadding, 0, defaultPadding, defaultPadding),
                  child: ClassInfoBigCard(
                    classCode: course.courseCode,
                    className: course.courseName,
                    classRoom: course.roomNum,
                    professor: course.profName,
                    schedule: "${course.courseStart} - ${course.courseEnd}",
                    press: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsScreen(course: course), // Pass the Course object
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddCourseDialog(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: primaryColor,
      ),
    );
  }

  // Method to show dialog for adding a new course
  void _showAddCourseDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String courseCode = '';
    String courseName = '';
    String professor = '';
    String room = '';
    String schedule = '';
    String textbook = '';
    DateTime? homeworkDue;
    DateTime? midtermDate;
    DateTime? finalExamDate;

    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Builder(
            builder: (context) {
              return Container(
                padding: const EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
                child: SingleChildScrollView( // Wrap the entire dialog in a scrollable view
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Add New Course', style: TextStyle(color: Colors.black, fontSize: 18)),
                      const SizedBox(height: 16),
                      // File Upload Section for Course Outline
                      const Text('Upload Course Outline (PDF)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      
                      GestureDetector(
                        onTap: () async {
                          // Pick the file using file_picker
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.custom, 
                            allowedExtensions: ['pdf'], // Allow only PDF files
                          );

                          if (result != null) {
                            // Get the path of the selected file
                            String? filePath = result.files.single.path;
                            // You can handle the file path here, such as uploading or storing it
                            print("Selected file path: $filePath");
                          } else {
                            // User canceled the picker
                            print("No file selected");
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.upload_file, size: 40, color: Colors.blue),
                              SizedBox(height: 8),
                              Text("Click to Upload", style: TextStyle(color: Colors.blue)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Form Section (Course Code, Name, etc.)
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Course Code'),
                              onSaved: (value) {
                                courseCode = value!;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the course code';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Course Name'),
                              onSaved: (value) {
                                courseName = value!;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the course name';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Professor Name'),
                              onSaved: (value) {
                                professor = value!;
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Room Number'),
                              onSaved: (value) {
                                room = value!;
                              },
                            ),
                            const SizedBox(height: 16),

                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Textbook Name & Author'),
                              onSaved: (value) {
                                textbook = value!; // Store the value in the textbook variable
                              },
                            ),
                            const SizedBox(height: 16),
                        
                            // Days Selection with Checkboxes
                            const Text('Select Days', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Column(
                              children: List.generate(
                                7, // 7 days of the week
                                (index) {
                                  final days = [
                                    'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
                                  ];
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return CheckboxListTile(
                                        title: Text(days[index]),
                                        value: selectedDays.contains(days[index]),
                                        onChanged: (bool? value) {
                                          setState(() {
                                            if (value != null) {
                                              if (value) {
                                                selectedDays.add(days[index]);
                                              } else {
                                                selectedDays.remove(days[index]);
                                              }
                                            }
                                          });
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                        
                            // Time Picker to select class time
                            Row(
                              children: [
                                const Text('Class Time: '),
                                TextButton(
                                  onPressed: () async {
                                    final TimeOfDay? pickedTime = await showTimePicker(
                                      context: context,
                                      initialTime: selectedTime,
                                    );
                                    if (pickedTime != null && pickedTime != selectedTime) {
                                      setState(() {
                                        selectedTime = pickedTime;
                                      });
                                    }
                                  },
                                  child: Text(
                                    selectedTime.format(context), // Display selected time
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                        
                            // Homework Due Date
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Homework Due Date'),
                              onTap: () async {
                                FocusScope.of(context).requestFocus(FocusNode());
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    homeworkDue = pickedDate;
                                  });
                                }
                              },
                              readOnly: true,
                              controller: TextEditingController(
                                text: homeworkDue != null ? homeworkDue!.toLocal().toString().split(' ')[0] : '',
                              ),
                            ),
                            // Midterm Date
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Midterm Date'),
                              onTap: () async {
                                FocusScope.of(context).requestFocus(FocusNode());
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    midtermDate = pickedDate;
                                  });
                                }
                              },
                              readOnly: true,
                              controller: TextEditingController(
                                text: midtermDate != null ? midtermDate!.toLocal().toString() : '',
                              ),
                            ),
                            // Final Exam Date
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Final Exam Date'),
                              onTap: () async {
                                FocusScope.of(context).requestFocus(FocusNode());
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    finalExamDate = pickedDate;
                                  });
                                }
                              },
                              readOnly: true,
                              controller: TextEditingController(
                                text: finalExamDate != null ? finalExamDate!.toLocal().toString().split(' ')[0] : '',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                
                                // Call the method to insert the course into the database
                                Provider.of<UserProvider>(context, listen: false)
                                    .addCourse(
                                  courseCode: courseCode,
                                  courseName: courseName,
                                  profName: professor,
                                  textbook: textbook,
                                  roomNum: room,
                                  selectedDays: selectedDays,
                                  courseStart: "2025-01-01",
                                  courseEnd: "2025-01-31",
                                  topics: "Testing",
                                  homeworkDue: homeworkDue?.toIso8601String() ?? '',
                                  midtermDate: midtermDate?.toIso8601String() ?? '',
                                  finalExamDate: finalExamDate?.toIso8601String() ?? '',
                                  courseConfidence: 0,
                                ).then((_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Course added successfully')),
                                  );
                                  Navigator.of(context).pop();
                                }).catchError((error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error: $error')),
                                  );
                                });
                              }
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class ClassInfoBigCard extends StatelessWidget {
  final String classCode;
  final String className;
  final String classRoom;
  final String professor;
  final String schedule;
  final VoidCallback press;

  const ClassInfoBigCard({
    Key? key,
    required this.classCode,
    required this.className,
    required this.classRoom,
    required this.professor,
    required this.schedule,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                classCode,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                className,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 20),
                  const SizedBox(width: 5),
                  Text(
                    classRoom,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person, size: 20),
                  const SizedBox(width: 5),
                  Text(
                    professor,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 20),
                  const SizedBox(width: 5),
                  Text(
                    schedule,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}