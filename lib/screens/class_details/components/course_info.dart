import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../constants.dart';
import '../../../providers/course_model.dart'; // Ensure Course model is imported

class ClassInfo extends StatelessWidget {
  final Course course; // Accept the Course object

  const ClassInfo({
    super.key,
    required this.course,  // Receive the course object
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course Code and Name
          Text(
            course.courseCode,  // Use course code dynamically
            style: Theme.of(context).textTheme.headlineMedium,
            maxLines: 1,
          ),
          const SizedBox(height: defaultPadding / 2),
          Text(
            course.courseName,  // Use course name dynamically
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
            maxLines: 1,
          ),
          const SizedBox(height: defaultPadding),

          // Instructor Name
          Text(
            "Instructor: ${course.profName}",  // Use professor's name dynamically
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
            maxLines: 1,
          ),
          const SizedBox(height: defaultPadding / 2),

          // Class Days and Timings
          Row(
            children: [
              Icon(Icons.access_time, size: 18), // Clock Icon
              const SizedBox(width: 8),
              Text(
                "${course.courseStart} - ${course.courseEnd}",  // Use start and end times dynamically
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: defaultPadding / 2),

          // Classroom/Room Info
          Row(
            children: [
              Icon(Icons.location_on, size: 18), // Location Icon
              const SizedBox(width: 8),
              Text(
                "Room: ${course.roomNum}",  // Use room number dynamically
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: defaultPadding / 2),
        ],
      ),
    );
  }
}


class DeliveryInfo extends StatelessWidget {
  const DeliveryInfo({
    super.key,
    required this.iconSrc,
    required this.text,
    required this.subText,
  });

  final String iconSrc, text, subText;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          iconSrc,
          height: 20,
          width: 20,
          colorFilter: const ColorFilter.mode(
            primaryColor,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 8),
        Text.rich(
          TextSpan(
            text: "$text\n",
            style: Theme.of(context).textTheme.labelLarge,
            children: [
              TextSpan(
                text: subText,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(fontWeight: FontWeight.normal),
              )
            ],
          ),
        ),
      ],
    );
  }
}
