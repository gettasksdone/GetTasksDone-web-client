import 'package:gtd_client/logic/backend_configuration.dart';
import 'package:gtd_client/widgets/custom_form_field.dart';
import 'package:gtd_client/utilities/validators.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:flutter/material.dart';

class BackendUrlField extends StatefulWidget {
  const BackendUrlField({super.key});

  @override
  State<BackendUrlField> createState() => _BackendUrlFieldState();
}

class _BackendUrlFieldState extends State<BackendUrlField> {
  static final BackendConfiguration _backendConfiguration =
      BackendConfiguration();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Autocomplete(
        initialValue: TextEditingValue(text: _backendConfiguration.url),
        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
          return CustomFormField(
            focusNode: focusNode,
            controller: controller,
            label: 'URL del backend',
            hintText: 'url del backend',
            validator: (String? input) => notEmptyValidator(
              input,
              () {
                if (input != null) {
                  setState(() {
                    _backendConfiguration.set(input);
                  });

                  onFieldSubmitted();
                }
              },
            ),
          );
        },
        optionsBuilder: (textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<String>.empty();
          }

          return _backendConfiguration.urls.where((String option) =>
              option.contains(textEditingValue.text.toLowerCase()));
        },
        optionsViewBuilder: (context, onSelected, options) => Align(
          alignment: Alignment.topLeft,
          child: Material(
            borderRadius: roundedCorners,
            child: SizedBox(
              height: 52.0 * options.length,
              width: constraints.biggest.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final String option in options)
                    InkWell(
                      borderRadius: roundedCorners,
                      onTap: () => onSelected(option),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(option),
                      ),
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
