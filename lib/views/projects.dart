import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class ProjectsView extends ConsumerStatefulWidget {
  const ProjectsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProjectsViewState();
}

class _ProjectsViewState extends ConsumerState<ProjectsView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 600.0,
        width: 350.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: _rowPadding,
              child: Text(
                'Tus tareas',
                style: TextStyle(
                  fontSize: 23.0,
                  color: colors.onSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            for (int i = 0; i < _tasks.length; i++)
              Padding(
                padding: _rowPadding,
                child: Row(
                  children: [
                    Expanded(
                      child: CheckboxButton(
                        text: _tasks[i].name,
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    SizedBox(
                      width: _editButtonSize,
                      height: _editButtonSize,
                      child: IconButton(
                        icon: const Icon(Icons.edit),
                        style: IconButton.styleFrom(
                          backgroundColor: colors.onSurface.lighten(80),
                          shape: const RoundedRectangleBorder(
                            borderRadius: roundedCorners,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _editTaskIndex = i;
                            _editTask = true;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 50.0),
            const CustomIconButton(
              label: 'Agregar tarea',
              icon: Icons.add_box_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
