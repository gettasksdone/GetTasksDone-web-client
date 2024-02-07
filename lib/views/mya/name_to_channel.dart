import 'package:blackforesttools/widgets/app_required_fields.dart';
import 'package:blackforesttools/widgets/task_status_table.dart';
import 'package:blackforesttools/widgets/custom_form_title.dart';
import 'package:blackforesttools/mixins/app_view_mixin.dart';
import 'package:blackforesttools/mixins/mya_view_mixin.dart';
import 'package:blackforesttools/utilities/extensions.dart';
import 'package:blackforesttools/utilities/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blackforesttools/utilities/enums.dart';
import 'package:flutter/material.dart';

class MYANameToChannelView extends ConsumerStatefulWidget {
  const MYANameToChannelView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MYANameToChannelViewState();
}

class _MYANameToChannelViewState extends ConsumerState<MYANameToChannelView>
    with AppViewMixin, MYAViewMixin {
  @override
  void initState() {
    super.initState();

    appViewMixin(MYAViewMixin.myaEndpoint);
    myaViewMixin(MYAModes.name);

    fetchTasksStatus();
  }

  void _postTask() async {
    postTask(payload);
  }

  String? _validateChannelNames(String? channelNames) {
    return validateItems(channelNames, 'YouTube channel name', (name) => true);
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
                  titleText: MYAViewMixin.myaTitle,
                ),
              ),
              const Padding(
                padding: rowPadding,
                child: CustomFormTitle(
                  titleText: 'N A M E   T O   C H A N N E L   M O D E',
                ),
              ),
              Form(
                key: formKey,
                child: AppRequiredFields(
                  itemsHint: 'names...',
                  onButtonPressed: _postTask,
                  showUpError: postTaskError,
                  showUpText: postTaskMessage,
                  enableButton: items != null,
                  onCheckboxChange: onNotifyChange,
                  taskNameValidator: validateTaskName,
                  itemsValidator: _validateChannelNames,
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
