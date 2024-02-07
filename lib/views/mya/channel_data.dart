import 'package:blackforesttools/widgets/app_required_fields.dart';
import 'package:blackforesttools/widgets/task_status_table.dart';
import 'package:blackforesttools/widgets/custom_form_title.dart';
import 'package:blackforesttools/mixins/app_view_mixin.dart';
import 'package:blackforesttools/mixins/mya_view_mixin.dart';
import 'package:blackforesttools/utilities/validators.dart';
import 'package:blackforesttools/utilities/extensions.dart';
import 'package:blackforesttools/utilities/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blackforesttools/utilities/enums.dart';
import 'package:flutter/material.dart';

class MYAChannelDataView extends ConsumerStatefulWidget {
  const MYAChannelDataView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MYAChannelDataViewState();
}

class _MYAChannelDataViewState extends ConsumerState<MYAChannelDataView>
    with AppViewMixin, MYAViewMixin {
  @override
  void initState() {
    super.initState();

    appViewMixin(MYAViewMixin.myaEndpoint);
    myaViewMixin(MYAModes.channel);

    fetchTasksStatus();
  }

  void _postTask() {
    postTask(payload);
  }

  String? _validateChannels(String? urls) {
    return validateItems(
      urls,
      'YouTube channel url',
      isYouTubeChannelValid,
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
                  titleText: MYAViewMixin.myaTitle,
                ),
              ),
              const Padding(
                padding: rowPadding,
                child: CustomFormTitle(
                  titleText: 'C H A N N E L   D A T A   M O D E',
                ),
              ),
              Form(
                key: formKey,
                child: AppRequiredFields(
                  itemsHint: 'channels...',
                  onButtonPressed: _postTask,
                  showUpError: postTaskError,
                  showUpText: postTaskMessage,
                  enableButton: items != null,
                  onCheckboxChange: onNotifyChange,
                  itemsValidator: _validateChannels,
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
