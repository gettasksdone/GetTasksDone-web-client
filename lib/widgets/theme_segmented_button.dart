import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/providers/theme_picker.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:flutter/material.dart';

class ThemeSegmentedButton extends ConsumerStatefulWidget {
  const ThemeSegmentedButton({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ThemeSegmentedButtonState();
}

class ThemeSegmentedButtonState extends ConsumerState<ThemeSegmentedButton> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

    return SegmentedButton(
      selected: {ref.watch(themePickerProvider)},
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: colors.primary,
        selectedForegroundColor: colors.onPrimary,
      ),
      onSelectionChanged: (Set<ThemeMode> selected) => setState(() {
        ref.read(themePickerProvider.notifier).set(selected.first);
      }),
      segments: const [
        ButtonSegment(
          label: Text('SO'),
          value: ThemeMode.system,
          icon: Icon(Icons.terminal),
        ),
        ButtonSegment(
          label: Text('Claro'),
          value: ThemeMode.light,
          icon: Icon(Icons.sunny),
        ),
        ButtonSegment(
          label: Text('Oscuro'),
          value: ThemeMode.dark,
          icon: Icon(Icons.bedtime),
        ),
      ],
    );
  }
}
