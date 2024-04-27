import 'package:gtd_client/widgets/solid_icon_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/widgets/card_element.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/modals/context_modal.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/logic/user_data.dart';
import 'package:gtd_client/logic/context.dart';
import 'package:flutter/material.dart';

class ContextsView extends ConsumerStatefulWidget {
  const ContextsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ContextsViewState();
}

class _ContextsViewState extends ConsumerState<ContextsView> {
  void _editContext(BuildContext buildContext, Context context) {
    setState(() {
      showModal(buildContext, ref, () => setState(() {}), context);
    });
  }

  void _createContext(BuildContext context) {
    setState(() {
      showModal(context, ref, () => setState(() {}), null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

    return Center(
      child: Padding(
        padding: viewPadding,
        child: SizedBox(
          width: 400.0,
          height: 600.0,
          child: Container(
            decoration: BoxDecoration(
              color: colors.secondary,
              borderRadius: roundedCorners,
            ),
            child: Padding(
              padding: cardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: rowPadding,
                    child: Text(
                      'Tus contextos',
                      style: TextStyle(fontSize: 23.0),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: rowPadding,
                      child: Container(
                        decoration: BoxDecoration(
                          color: colors.tertiary,
                          borderRadius: roundedCorners,
                        ),
                        child: Padding(
                          padding: cardPadding,
                          child: ListView(
                            children: [
                              for (final MapEntry<int, Context> entry
                                  in UserData().contexts.entries)
                                CardElement(
                                  cells: [
                                    CardCellData(
                                      icon: Icons.push_pin,
                                      text: entry.value.name!,
                                    ),
                                  ],
                                  onPressed: () => _editContext(
                                    context,
                                    entry.value,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SolidIconButton(
                    center: true,
                    size: cardElementSize,
                    text: 'Agregar contexto',
                    icon: Icons.add_box_outlined,
                    innerSize: cardElementFontSize,
                    onPressed: () => _createContext(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
