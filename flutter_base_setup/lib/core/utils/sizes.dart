import 'package:flutter/material.dart';

// 

class AppSpacing {
  // Global Padding Sizes
  static const EdgeInsets paddingXS = EdgeInsets.all(4.0); // Extra Small
  static const EdgeInsets paddingS = EdgeInsets.all(8.0); // Small
  static const EdgeInsets paddingM = EdgeInsets.all(12.0); // Medium
  static const EdgeInsets paddingL = EdgeInsets.all(16.0); // Large
  static const EdgeInsets paddingXL = EdgeInsets.all(24.0); // Extra Large
  static const EdgeInsets paddingXXL =
      EdgeInsets.all(32.0); // Double Extra Large

  // Horizontal Padding
  static const EdgeInsets paddingHorizontalXS =
      EdgeInsets.symmetric(horizontal: 4.0);
  static const EdgeInsets paddingHorizontalS =
      EdgeInsets.symmetric(horizontal: 8.0);
  static const EdgeInsets paddingHorizontalM =
      EdgeInsets.symmetric(horizontal: 12.0);
  static const EdgeInsets paddingHorizontalL =
      EdgeInsets.symmetric(horizontal: 16.0);
  static const EdgeInsets paddingHorizontalXL =
      EdgeInsets.symmetric(horizontal: 24.0);
  static const EdgeInsets paddingHorizontalXXL =
      EdgeInsets.symmetric(horizontal: 32.0);

  // Vertical Padding
  static const EdgeInsets paddingVerticalXS =
      EdgeInsets.symmetric(vertical: 4.0);
  static const EdgeInsets paddingVerticalS =
      EdgeInsets.symmetric(vertical: 8.0);
  static const EdgeInsets paddingVerticalM =
      EdgeInsets.symmetric(vertical: 12.0);
  static const EdgeInsets paddingVerticalL =
      EdgeInsets.symmetric(vertical: 16.0);
  static const EdgeInsets paddingVerticalXL =
      EdgeInsets.symmetric(vertical: 24.0);
  static const EdgeInsets paddingVerticalXXL =
      EdgeInsets.symmetric(vertical: 32.0);

  // Global Margin Sizes
  static const EdgeInsets marginXS = EdgeInsets.all(4.0); // Extra Small
  static const EdgeInsets marginS = EdgeInsets.all(8.0); // Small
  static const EdgeInsets marginM = EdgeInsets.all(12.0); // Medium
  static const EdgeInsets marginL = EdgeInsets.all(16.0); // Large
  static const EdgeInsets marginXL = EdgeInsets.all(24.0); // Extra Large
  static const EdgeInsets marginXXL =
      EdgeInsets.all(32.0); // Double Extra Large

  // Horizontal Margin
  static const EdgeInsets marginHorizontalXS =
      EdgeInsets.symmetric(horizontal: 4.0);
  static const EdgeInsets marginHorizontalS =
      EdgeInsets.symmetric(horizontal: 8.0);
  static const EdgeInsets marginHorizontalM =
      EdgeInsets.symmetric(horizontal: 12.0);
  static const EdgeInsets marginHorizontalL =
      EdgeInsets.symmetric(horizontal: 16.0);
  static const EdgeInsets marginHorizontalXL =
      EdgeInsets.symmetric(horizontal: 24.0);
  static const EdgeInsets marginHorizontalXXL =
      EdgeInsets.symmetric(horizontal: 32.0);

  // Vertical Margin
  static const EdgeInsets marginVerticalXS =
      EdgeInsets.symmetric(vertical: 4.0);
  static const EdgeInsets marginVerticalS = EdgeInsets.symmetric(vertical: 8.0);
  static const EdgeInsets marginVerticalM =
      EdgeInsets.symmetric(vertical: 12.0);
  static const EdgeInsets marginVerticalL =
      EdgeInsets.symmetric(vertical: 16.0);
  static const EdgeInsets marginVerticalXL =
      EdgeInsets.symmetric(vertical: 24.0);
  static const EdgeInsets marginVerticalXXL =
      EdgeInsets.symmetric(vertical: 32.0);

  // Vertical Spacing
  static const SizedBox verticalSpaceXS = SizedBox(height: 4.0);
  static const SizedBox verticalSpaceS = SizedBox(height: 8.0);
  static const SizedBox verticalSpaceM = SizedBox(height: 12.0);
  static const SizedBox verticalSpaceL = SizedBox(height: 16.0);
  static const SizedBox verticalSpaceXL = SizedBox(height: 24.0);
  static const SizedBox verticalSpaceXXL = SizedBox(height: 32.0);

  // Horizontal Spacing
  static const SizedBox horizontalSpaceXS = SizedBox(width: 4.0);
  static const SizedBox horizontalSpaceS = SizedBox(width: 8.0);
  static const SizedBox horizontalSpaceM = SizedBox(width: 12.0);
  static const SizedBox horizontalSpaceL = SizedBox(width: 16.0);
  static const SizedBox horizontalSpaceXL = SizedBox(width: 24.0);
  static const SizedBox horizontalSpaceXXL = SizedBox(width: 32.0);
}


class AppTextStyles {
  // Headings
  static const TextStyle headingXL = TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold);
  static const TextStyle headingL = TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold);
  static const TextStyle headingM = TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold);
  static const TextStyle headingS = TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);

  // Body Text
  static const TextStyle bodyL = TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal);
  static const TextStyle bodyM = TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal);
  static const TextStyle bodyS = TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal);

  // Captions & Labels
  static const TextStyle caption = TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400);
  static const TextStyle label = TextStyle(fontSize: 10.0, fontWeight: FontWeight.w400);
}


/*
instead of this:

Text("Hello", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
SizedBox(height: 12),
Padding(padding: EdgeInsets.all(16)),

you can use this:

Text("Hello", style: AppTextStyles.headingM),
AppSpacing.verticalSpaceM,
Padding(padding: AppSpacing.paddingL),

 */