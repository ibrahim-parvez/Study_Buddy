class User {
  final int id;  // Change from String to int
  final String name;
  final String email;
  final String university;
  final String faculty;
  final String program;
  final DateTime? matriculationDate;  // Keep this nullable DateTime
  final DateTime? graduationDate;     // Keep this nullable DateTime

  User({
    required this.id,  // id is now an int
    required this.name,
    required this.email,
    required this.university,
    required this.faculty,
    required this.program,
    this.matriculationDate,
    this.graduationDate,
  });

  // Updated constructor to handle `id` as an int
  factory User.fromDatabase(Map<String, dynamic> userData) {
    return User(
      id: userData['id'],  // Directly use the int from database
      name: userData['name'],
      email: userData['email'],
      university: userData['university'],
      faculty: userData['faculty'],
      program: userData['program'],
      matriculationDate: userData['matriculation_date'] != null
          ? DateTime.tryParse(userData['matriculation_date'])
          : null,  // Parse if not null
      graduationDate: userData['graduation_date'] != null
          ? DateTime.tryParse(userData['graduation_date'])
          : null,  // Parse if not null
    );
  }
}
