import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:study_buddy/constants.dart';
import 'user_model.dart'; // Import your User class
import 'course_model.dart'; // Import Course model

class UserProvider with ChangeNotifier {
  User? _user;
  List<Course> _courses = [];  // List to store Course objects

  User? get user => _user;
  List<Course> get courses => _courses;

  // Set the user in the provider
  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  // Method to fetch user data along with courses
  Future<void> fetchUserData(String email, String password) async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'sql5.freesqldatabase.com',
      port: 3306,
      user: 'sql5757142',
      db: 'sql5757142',
      password: 'tghuKCuYTv',
    ));

    try {
      // Fetch user info
      var userResults = await conn.query(
        'SELECT * FROM users WHERE email = ? AND password = ?',
        [email, password],
      );

      if (userResults.isEmpty) {
        throw Exception('Invalid email or password');
      }

      var userData = userResults.first;
      _user = User(
        id: userData['id'],  // ID is now an int
        name: userData['name'],
        email: userData['email'],
        university: userData['university'],
        faculty: userData['faculty'],
        program: userData['program'],
        matriculationDate: userData['matriculation_date'],
        graduationDate: userData['graduation_date'],
      );

      // Fetch courses after user is set
      await fetchUserCourses();

      // Notify listeners after fetching the courses
      notifyListeners(); // Notify listeners when data is fetched
    } catch (e) {
      print("Error fetching user data: $e");
    } finally {
      await conn.close();
    }
  }

  // Method to clear user data (optional)
  void clearUser() {
    _user = null;
    _courses = [];
    notifyListeners();
  }

  // Method to fetch courses for a specific user and store as Course objects
Future<void> fetchUserCourses() async {
    if (_user == null) return;

    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'sql5.freesqldatabase.com',
      port: 3306,
      user: 'sql5757142',
      db: 'sql5757142',
      password: 'tghuKCuYTv',
    ));

    try {
      var results = await conn.query(
        'SELECT * FROM courses WHERE user_id = ?',
        [_user!.id],
      );

      _courses = results.map((row) {
        return Course(
          courseId: row['course_id'],
          userId: row['user_id'],
          courseCode: row['course_code'],
          courseName: row['course_name'],
          profName: row['prof_name'],
          roomNum: row['room_num'],
          courseStart: row['course_start'],
          courseEnd: row['course_end'],
          topics: row['topics'],
          homeworkDue: row['homework_due'],
          midtermDate: row['midterm_date'],
          finalExamDate: row['final_exam_date'],
          courseConfidence: row['course_confidence'],
          textbook: row['textbook'],
          email: row['email'],
        );
      }).toList();

      notifyListeners(); // Notify listeners when courses are fetched
    } catch (e) {
      print('Error fetching courses: $e');
    } finally {
      await conn.close();
    }
  }

  List<Map<String, dynamic>> getCourseEvents() {
    List<Map<String, dynamic>> events = [];
    for (var course in _courses) {
      if (course.homeworkDue.isNotEmpty) {
        events.add({
          "title": "Homework due for ${course.courseName}",
          "date": DateTime.parse(course.homeworkDue),
        });
      }
      if (course.midtermDate.isNotEmpty) {
        events.add({
          "title": "Midterm for ${course.courseName}",
          "date": DateTime.parse(course.midtermDate),
        });
      }
      if (course.finalExamDate.isNotEmpty) {
        events.add({
          "title": "Final Exam for ${course.courseName}",
          "date": DateTime.parse(course.finalExamDate),
        });
      }
    }
    return events;
  }






  //THIS ONE WORKS
  // Method to add a course
  Future<void> addCourse({
    required String courseCode,
    required String courseName,
    required String profName,
    required String roomNum,
    required List<String> selectedDays,
    required String courseStart,
    required String courseEnd,
    required String topics,
    required String homeworkDue,
    required String midtermDate,
    required String finalExamDate,
    required double courseConfidence,
    required String textbook,

  }) async {
    if (_user == null) {
      throw Exception('User not logged in');
    }

    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'sql5.freesqldatabase.com',
      port: 3306,
      user: 'sql5757142',
      db: 'sql5757142',
      password: 'tghuKCuYTv',
    ));

    try {
      // Prepare the insert query
      var result = await conn.query(
        'INSERT INTO courses (user_id, course_code, course_name, prof_name, room_num, days, course_start, course_end, topics, homework_due, midterm_date, final_exam_date, course_confidence, textbook_name, email) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          _user!.id,  // Use the logged-in user's ID
          courseCode,
          courseName,
          profName,
          roomNum,
          selectedDays.join(','), // Store days as comma-separated string
          courseStart,
          courseEnd,
          topics,
          homeworkDue,
          midtermDate,
          finalExamDate,
          courseConfidence,
          textbook,

        ],
      );

      // Check if the insertion was successful
      if (result.affectedRows == 1) {
        print('Course added successfully');
        notifyListeners(); // Optionally notify listeners to update the UI
      } else {
        throw Exception('Failed to add course');
      }
    } catch (e) {
      rethrow;
    } finally {
      await conn.close();
    }
  }
}







