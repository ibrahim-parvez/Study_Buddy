import 'package:flutter/material.dart';
import '../../../constants.dart';

class FeaturedItemCard extends StatelessWidget {
  const FeaturedItemCard({
    super.key,
    required this.title,
    required this.image,
    required this.description,
    required this.press,
  });

  final String title, image, description;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.labelLarge!.copyWith(
          color: titleColor.withOpacity(0.64),
          fontWeight: FontWeight.normal,
        );
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          width: 100, // Adjusted width to make the image smaller
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: titleColor, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: textStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}