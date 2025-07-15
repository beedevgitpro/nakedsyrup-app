import 'package:flutter/material.dart';
import 'package:naked_syrups/utility/responsive_UI.dart';

const double kLargeFont = 19;
const double kMediumFont = 18;
const double kSmallFont = 15;

double getFontSize(BuildContext context, double factor) {
  bool large = ResponsiveWidget.isScreenLarge(
    MediaQuery.of(context).size.width,
    MediaQuery.of(context).devicePixelRatio,
  );
  bool medium = ResponsiveWidget.isScreenMedium(
    MediaQuery.of(context).size.width,
    MediaQuery.of(context).devicePixelRatio,
  );
  return (large ? kLargeFont : (medium ? kMediumFont : kSmallFont)) + factor;
}
