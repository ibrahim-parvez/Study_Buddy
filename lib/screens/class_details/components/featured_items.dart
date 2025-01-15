import 'package:flutter/material.dart';
import 'featured_item_card.dart';
import '../../../constants.dart';

import '../../../providers/course_model.dart';

class FeaturedItems extends StatelessWidget {
  final Course course;
  const FeaturedItems({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Text("Course Resources",
              style: Theme.of(context).textTheme.titleLarge),
        ),
        const SizedBox(height: defaultPadding / 2),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(
                3, // for demo we use 3
                (index) => Padding(
                  padding: const EdgeInsets.only(left: defaultPadding),
                  child: FeaturedItemCard(
                    title: courseTitles[index],
                    image: courseImages[index],
                    description: courseDescriptions[index],
                    press: () {
                      // Add your navigation or action here
                    },
                  ),
                ),
              ),
              const SizedBox(width: defaultPadding),
            ],
          ),
        ),
      ],
    );
  }
}

const List<String> courseTitles = [
  "Course Outline",
  "Textbook",
  "Discussion Questions"
];

const List<String> courseImages = [
  "assets/images/course_outline.png",
  "assets/images/textbook.png",
  "assets/images/discussion_questions.png"
];

const List<String> courseDescriptions = [
  "View the course outline",
  "Access the textbook",
  "Join the discussion"
];