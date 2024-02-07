import 'package:blackforesttools/widgets/custom_text_form_field.dart';
import 'package:blackforesttools/widgets/task_status_table.dart';
import 'package:blackforesttools/widgets/custom_form_title.dart';
import 'package:blackforesttools/widgets/gradient_button.dart';
import 'package:blackforesttools/widgets/custom_dropdown.dart';
import 'package:blackforesttools/mixins/app_view_mixin.dart';
import 'package:blackforesttools/mixins/mya_view_mixin.dart';
import 'package:blackforesttools/widgets/text_checkbox.dart';
import 'package:blackforesttools/widgets/show_up_text.dart';
import 'package:blackforesttools/utilities/extensions.dart';
import 'package:blackforesttools/utilities/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blackforesttools/utilities/enums.dart';
import 'package:flutter/material.dart';

class MYARandomDataView extends ConsumerStatefulWidget {
  const MYARandomDataView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MYARandomDataViewState();
}

class _MYARandomDataViewState extends ConsumerState<MYARandomDataView>
    with AppViewMixin, MYAViewMixin {
  static const Map<String, int> _categories = {
    'Default': 0,
    'Film & Animation': 1,
    'Autos & Vehicles': 2,
    'Music': 10,
    'Pets & Animals': 15,
    'Sports': 17,
    'Short Movies': 18,
    'Travel & Events': 19,
    'Gaming': 20,
    'Videoblogging': 21,
    'People & Blogs': 22,
    'Comedy A': 23,
    'Entertainment': 24,
    'News & Politics': 25,
    'Howto & Style': 26,
    'Education': 27,
    'Science & Technology': 28,
    'Nonprofits & Activism': 29,
    'Movies': 30,
    'Anime/Animation': 31,
    'Action/Adventure': 32,
    'Classics': 33,
    'Comedy B': 34,
    'Documentary': 35,
    'Drama': 36,
    'Family': 37,
    'Foreign': 38,
    'Horror': 39,
    'Sci-Fi/Fantasy': 40,
    'Thriller': 41,
    'Shorts': 42,
    'Shows': 43,
    'Trailers': 44,
  };

  @override
  void initState() {
    super.initState();

    appViewMixin(MYAViewMixin.myaEndpoint);
    myaViewMixin(MYAModes.random);

    fetchTasksStatus();
  }

  void _postTask() async {
    postTask(payload);
  }

  String? _validateCheckAmount(String? amount) {
    if (amount == null || amount.isEmpty) {
      return 'Please enter the number of channels to check';
    }

    final int parsedAmount = int.parse(amount);

    if (parsedAmount < 1) {
      return 'Check amount must be more than 0';
    }

    setState(() {
      checkAmount = parsedAmount;
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final Decoration formContainerDecoration = BoxDecoration(
      color: colors.secondary,
      borderRadius: roundedCorners,
    );

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
                  titleText: 'R A N D O M   D A T A   M O D E',
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: rowPadding,
                      child: Container(
                        decoration: formContainerDecoration,
                        child: Padding(
                          padding: padding,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CustomDropdown(
                                  labelText: 'Category',
                                  selectedValue: selectedCategory,
                                  onChanged: (category) {
                                    setState(() {
                                      selectedCategory = category!;
                                    });
                                  },
                                  items: _categories.entries.map(
                                    (entry) {
                                      return DropdownMenuItem<int>(
                                        value: entry.value,
                                        child: Text(entry.key),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: CustomTextFormField(
                                  numeric: true,
                                  hintText: '...',
                                  showBorder: true,
                                  labelText: 'Check amount',
                                  verticalPaddingAmount: 19.5,
                                  validator: _validateCheckAmount,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: rowPadding,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              hintText: 'task name',
                              validator: validateTaskName,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Container(
                              decoration: formContainerDecoration,
                              child: TextCheckbox(
                                onChanged: onNotifyChange,
                                text: 'Notify me when task is done',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: rowPadding,
                      child: Container(
                        height: appFormContainerHeight,
                        decoration: formContainerDecoration,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 10.0,
                                top: halfPaddingAmount,
                                left: halfPaddingAmount,
                                bottom: halfPaddingAmount,
                              ),
                              child: GradientButton(
                                width: 150.0,
                                onPressed: _postTask,
                                lightenGradient: true,
                                buttonText: 'S E N D',
                              ),
                            ),
                            ShowUpText(
                              text: postTaskMessage,
                              visible: postTaskMessage != null,
                              textStyle: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: postTaskError
                                    ? colors.error
                                    : colors.onSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
