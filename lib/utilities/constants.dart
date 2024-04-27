import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const bool testNavigation = kDebugMode && false;

const String appName = 'Get Tasks Done';

const double edgeWidth = 3.0;

const double paddingAmount = 10.0;

const double cardPaddingAmount = 10.0;

const double cardElementFontSize = 20.0;

const double modalButtonFontSize = 18.0;

const Size modalButtonSize = Size(120.0, 60.0);

const Size cardElementSize = Size(120.0, 80.0);

const Radius cornerRadius = Radius.circular(10.0);

const EdgeInsets padding = EdgeInsets.all(paddingAmount);

const EdgeInsets cardPadding = EdgeInsets.all(cardPaddingAmount);

const EdgeInsets rowPadding = EdgeInsets.only(bottom: paddingAmount);

const BorderRadius roundedCorners = BorderRadius.all(cornerRadius);

const RoundedRectangleBorder roundedBorder = RoundedRectangleBorder(
  borderRadius: roundedCorners,
);

final DateFormat backEndDateFormat = DateFormat(
  'yyyy-MM-dd hh:mm:ss',
);
