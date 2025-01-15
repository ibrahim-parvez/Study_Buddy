import 'package:flutter/material.dart';
import 'package:study_buddy/screens/class_details/components/course_info.dart';
import '../../constants.dart';
import 'components/featured_items.dart';
import 'components/iteams.dart';
import 'components/timeline.dart';
import '../../providers/course_model.dart';
import '../../providers/course_model.dart';

class DetailsScreen extends StatelessWidget {
  final Course course;

  const DetailsScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: defaultPadding / 2),
              ClassInfo(course: course),  // Pass the course to ClassInfo
              SizedBox(height: defaultPadding),
              FeaturedItems(course: course), // Pass the course to other widgets if needed
              SizedBox(height: defaultPadding),
              Timeline(course: course), // Same for Timeline widget
              SizedBox(height: defaultPadding),
              Items(course: course), // Pass course to Items widget
            ],
          ),
        ),
      ),
    );
  }
}
