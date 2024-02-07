import 'package:blackforesttools/views/mya/name_to_channel.dart';
import 'package:blackforesttools/views/apa/instagram_mode.dart';
import 'package:blackforesttools/providers/session_token.dart';
import 'package:blackforesttools/views/apa/channel_mode.dart';
import 'package:blackforesttools/widgets/custom_app_bar.dart';
import 'package:blackforesttools/views/mya/channel_data.dart';
import 'package:blackforesttools/views/apa/tiktok_mode.dart';
import 'package:blackforesttools/views/mya/random_data.dart';
import 'package:blackforesttools/views/apa/video_mode.dart';
import 'package:blackforesttools/views/mya/video_data.dart';
import 'package:blackforesttools/utilities/extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppScreen extends ConsumerStatefulWidget {
  const AppScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppScreenState();
}

class _AppScreenState extends ConsumerState<AppScreen> {
  static const List<Widget> _views = [
    MYAChannelDataView(),
    MYAVideoDataView(),
    MYARandomDataView(),
    MYANameToChannelView(),
    APAChannelModeView(),
    APAInstagramModeView(),
    APATikTokModeView(),
    APAVideoModeView(),
  ];

  int _viewIndex = 0;

  @override
  void initState() {
    super.initState();

    if (kDebugMode) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted && (ref.watch(sessionTokenProvider) == null)) {
        context.go('/');
      }
    });
  }

  void _setView(BuildContext context, int viewIndex) {
    setState(() {
      _viewIndex = viewIndex;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(height: 50.0),
      drawer: Drawer(
        width: 430.0,
        shape: const ContinuousRectangleBorder(),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 120.0,
              child: DrawerHeader(
                decoration: BoxDecoration(color: colors.primary),
                child: Text(
                  'B L A C K   F O R E S T   T O O L S',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: colors.onPrimary,
                  ),
                ),
              ),
            ),
            Theme(
              data: context.theme.copyWith(dividerColor: Colors.transparent),
              child: Column(
                children: [
                  ExpansionTile(
                    title: const Text(
                      'M A C R O   Y O U T U B E   A N A L Y S I S',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    leading: SvgPicture.asset(
                      'assets/svgs/youtube.svg',
                      width: 25.0,
                    ),
                    trailing: const SizedBox.shrink(),
                    children: [
                      ListTile(
                        onTap: () => _setView(context, 0),
                        leading: const Icon(Icons.account_circle),
                        title: const Text('C H A N N E L   D A T A'),
                      ),
                      ListTile(
                        onTap: () => _setView(context, 1),
                        leading: const Icon(Icons.video_collection),
                        title: const Text('V I D E O   D A T A'),
                      ),
                      ListTile(
                        onTap: () => _setView(context, 2),
                        leading: const Icon(Icons.data_thresholding),
                        title: const Text('R A N D O M   D A T A'),
                      ),
                      ListTile(
                        onTap: () => _setView(context, 3),
                        leading: const Icon(Icons.manage_search),
                        title: const Text('N A M E   T O   C H A N N E L'),
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: const Text(
                      'A U T O M A T I C   P R A I S E   A P P L I C A T I O N',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    leading: SvgPicture.asset(
                      'assets/svgs/chatgpt.svg',
                      width: 25.0,
                    ),
                    trailing: const SizedBox.shrink(),
                    children: [
                      ListTile(
                        onTap: () => _setView(context, 4),
                        leading: const Icon(Icons.account_circle),
                        title: const Text('C H A N N E L   M O D E'),
                      ),
                      ListTile(
                        onTap: () => _setView(context, 5),
                        leading: const Icon(Icons.camera_alt),
                        title: const Text('I N S T A G R A M   M O D E'),
                      ),
                      ListTile(
                        onTap: () => _setView(context, 6),
                        leading: const Icon(Icons.phone_android),
                        title: const Text('T I K T O K   M O D E'),
                      ),
                      ListTile(
                        onTap: () => _setView(context, 7),
                        leading: const Icon(Icons.video_collection),
                        title: const Text('V I D E O   M O D E'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: _views[_viewIndex],
    );
  }
}
