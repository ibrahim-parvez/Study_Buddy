class Course {
  final int courseId;
  final int userId;
  final String email;
  final String courseCode;
  final String courseName;
  final String profName;
  final String roomNum;
  final String courseStart;
  final String courseEnd;
  final String topics;
  final String homeworkDue;
  final String midtermDate;
  final String finalExamDate;
  final double courseConfidence;
  final String textbook;  // Add the textbook field

  Course({
    required this.courseId,
    required this.userId,
    required this.email,
    required this.courseCode,
    required this.courseName,
    required this.profName,
    required this.roomNum,
    required this.courseStart,
    required this.courseEnd,
    required this.topics,
    required this.homeworkDue,
    required this.midtermDate,
    required this.finalExamDate,
    required this.courseConfidence,
    required this.textbook,  // Make sure to add textbook to the constructor
  });
}
