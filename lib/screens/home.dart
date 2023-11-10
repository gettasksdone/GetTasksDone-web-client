import 'package:gtdclient/widgets/widgets.dart';
import 'package:gtdclient/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime currentTime = DateTime.now();
    final String dateText =
        DateFormat('EEEE, d MMMM, yyyy').format(currentTime);
    final String timeText = DateFormat.Hm().format(currentTime);

    final deviceSize = context.deviceSize;
    final colors = context.colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: deviceSize.height * 0.3,
                width: deviceSize.width,
                color: colors.primary,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SurfaceText(
                        text: dateText,
                        fontSize: 20,
                      ),
                      SurfaceText(
                        text: timeText,
                        fontSize: 20,
                      ),
                      const Gap(10),
                      const SurfaceText(
                        text: 'G E T   T A S K S   D O N E',
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
