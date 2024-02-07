import 'package:blackforesttools/widgets/app_required_fields.dart';
import 'package:blackforesttools/widgets/task_status_table.dart';
import 'package:blackforesttools/widgets/custom_form_title.dart';
import 'package:blackforesttools/mixins/app_view_mixin.dart';
import 'package:blackforesttools/mixins/apa_view_mixin.dart';
import 'package:blackforesttools/utilities/validators.dart';
import 'package:blackforesttools/utilities/extensions.dart';
import 'package:blackforesttools/utilities/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blackforesttools/utilities/enums.dart';
import 'package:flutter/material.dart';

class APAInstagramModeView extends ConsumerStatefulWidget {
  const APAInstagramModeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _APAInstagramModeViewState();
}

class _APAInstagramModeViewState extends ConsumerState<APAInstagramModeView>
    with AppViewMixin, APAViewMixin {
  @override
  void initState() {
    super.initState();

    appViewMixin(APAViewMixin.apaEndpoint);
    apaViewMixin(APAModes.instagram);

    fetchTasksStatus();
  }

  void _postTask() {
    postTask(payload);
  }

  String? _validateUsernames(String? usernames) {
    return validateItems(
      usernames,
      'Instagram username',
      isAtPrefixedNameValid,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

    return Center(
      child: Padding(
        padding: padding,
        child: Container(
          constraints: const BoxConstraints.expand(width: 900.0),
          decoration: BoxDecoration(
            color: colors.tertiary,
            borderRadius: roundedCorners,
          ),
          child: Column(
            children: [
              const Padding(
                padding: padding,
                child: CustomFormTitle(
                  primaryColored: true,
                  titleText: APAViewMixin.apaTitle,
                ),
              ),
              const Padding(
                padding: rowPadding,
                child: CustomFormTitle(
                  titleText: 'I N S T A G R A M   M O D E',
                ),
              ),
              Form(
                key: formKey,
                child: AppRequiredFields(
                  itemsHint: 'usernames...',
                  onButtonPressed: _postTask,
                  showUpError: postTaskError,
                  showUpText: postTaskMessage,
                  enableButton: items != null,
                  belowTextBoxWidget: promptField,
                  onCheckboxChange: onNotifyChange,
                  itemsValidator: _validateUsernames,
                  taskNameValidator: validateTaskName,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: rowPadding,
                  child: TaskStatusTable(
                    taskStatusList: taskStatus,
                    refreshOnPressed: fetchTasksStatus,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
