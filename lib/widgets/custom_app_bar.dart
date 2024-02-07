import 'package:blackforesttools/widgets/black_forest_logo.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool implyLeading;
  final double height;

  const CustomAppBar({
    super.key,
    this.implyLeading = true,
    this.height = 200.0,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      toolbarHeight: height,
      automaticallyImplyLeading: implyLeading,
      title: BlackForestLogo(size: height),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
