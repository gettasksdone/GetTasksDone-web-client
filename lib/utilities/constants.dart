import 'package:flutter/material.dart';

const String serverUrl = '';

const double edgeWidth = 3.0;

const double paddingAmount = 10.0;

const double labelFontSize = 15.0;

const BorderRadius roundedCorners = BorderRadius.all(Radius.circular(10.0));

const EdgeInsets padding = EdgeInsets.all(paddingAmount);

final BoxDecoration background = BoxDecoration(
  image: DecorationImage(
    fit: BoxFit.cover,
    image: const AssetImage('assets/images/background.png'),
    colorFilter: ColorFilter.mode(
      Colors.black.withOpacity(0.2),
      BlendMode.dstATop,
    ),
  ),
);
