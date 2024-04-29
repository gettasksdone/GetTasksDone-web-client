import 'package:gtd_client/widgets/custom_dismissible.dart';
import 'package:gtd_client/widgets/solid_icon_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/widgets/context_card.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/dialogs/context_modal.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/logic/user_data.dart';
import 'package:gtd_client/logic/context.dart';
import 'package:gtd_client/logic/api.dart';
import 'package:flutter/material.dart';

class ContextsView extends ConsumerStatefulWidget {
  const ContextsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ContextsViewState();
}

class _ContextsViewState extends ConsumerState<ContextsView> {
  static final UserData _userData = UserData();

  void _editContext(BuildContext buildContext, Context context) {
    setState(() {
      showModal(buildContext, ref, () => setState(() {}), context.copy());
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
                                CustomDismissible(
                                  dimissibleKey: ValueKey(entry.value),
                                  onRightSwipe: _userData
                                          .getContextTasks(entry.key)
                                          .isNotEmpty
                                      ? null
                                      : () async {
                                          await deleteContext(
                                            ref,
                                            entry.key,
                                            () async {
                                              final List<String> responses =
                                                  await getUserDataResponse(
                                                      ref);

                                              setState(() {
                                                _userData.clear();
                                                _userData.loadUserData(
                                                  ref,
                                                  responses,
                                                );
                                              });
                                            },
                                          );
                                        },
                                  child: ContextCard(
                                    text: entry.value.name!,
                                    onPressed: () => _editContext(
                                      context,
                                      entry.value,
                                    ),
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
