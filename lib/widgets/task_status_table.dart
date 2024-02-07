import 'package:blackforesttools/utilities/extensions.dart';
import 'package:blackforesttools/utilities/constants.dart';
import 'package:flutter/material.dart';

class TaskStatusTable extends StatelessWidget {
  static const double _tableHeadingHeight = 50.0;

  final List<List<String>>? taskStatusList;
  final VoidCallback? refreshOnPressed;

  const TaskStatusTable({
    super.key,
    required this.taskStatusList,
    this.refreshOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: taskStatusList != null && taskStatusList!.isNotEmpty
          ? Container(
              constraints: const BoxConstraints.expand(),
              decoration: BoxDecoration(
                color: colors.secondary,
                borderRadius: roundedCorners,
              ),
              child: Padding(
                padding: padding,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: ClipRRect(
                          borderRadius: roundedCorners,
                          child: DataTable(
                            headingRowHeight: _tableHeadingHeight,
                            headingRowColor: MaterialStatePropertyAll(
                              colors.primary,
                            ),
                            headingTextStyle: TextStyle(
                              color: colors.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                            dataTextStyle: TextStyle(
                              color: colors.onTertiary,
                              fontWeight: FontWeight.bold,
                            ),
                            columns: const [
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('Task Name')),
                              DataColumn(label: Text('By')),
                            ],
                            rows: taskStatusList!
                                .map((e) => DataRow(
                                      cells: [
                                        DataCell(
                                          ConstrainedBox(
                                            constraints: const BoxConstraints(
                                              minWidth: 80.0,
                                              maxWidth: 80.0,
                                            ),
                                            child: Text(e[0]),
                                          ),
                                        ),
                                        DataCell(
                                          ConstrainedBox(
                                            constraints: const BoxConstraints(
                                              minWidth: 250.0,
                                              maxWidth: 250.0,
                                            ),
                                            child: Text(
                                              e[1],
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          ConstrainedBox(
                                            constraints: const BoxConstraints(
                                              minWidth: 300.0,
                                              maxWidth: 300.0,
                                            ),
                                            child: Text(
                                              e[2],
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    IconButton(
                      color: colors.onPrimary,
                      onPressed: refreshOnPressed,
                      icon: const Icon(Icons.refresh),
                      style: ButtonStyle(
                        iconSize: const MaterialStatePropertyAll(30.0),
                        fixedSize: const MaterialStatePropertyAll(
                          Size(
                            _tableHeadingHeight,
                            _tableHeadingHeight,
                          ),
                        ),
                        backgroundColor:
                            MaterialStatePropertyAll(colors.primary),
                        shape: const MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: roundedCorners,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(
              constraints: const BoxConstraints.expand(),
              decoration: BoxDecoration(
                color: colors.secondary,
                borderRadius: roundedCorners,
              ),
              child: Center(
                child: Text(
                  'No tasks in queue...',
                  style: TextStyle(
                    color: colors.onSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                ),
              ),
            ),
    );
  }
}
