import 'package:gtd_client/widgets/loading_solid_button.dart';
import 'package:gtd_client/providers/completed_registry.dart';
import 'package:gtd_client/mixins/sign_in_screen_mixin.dart';
import 'package:gtd_client/widgets/custom_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/widgets/show_up_text.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/providers/new_user.dart';
import 'package:gtd_client/logic/api.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class CompleteRegistryScreen extends ConsumerStatefulWidget {
  const CompleteRegistryScreen({super.key});

  @override
  ConsumerState<CompleteRegistryScreen> createState() =>
      _CompleteRegistryScreenState();
}

class _CompleteRegistryScreenState extends ConsumerState<CompleteRegistryScreen>
    with SignInScreenMixin {
  String? _phoneNumber;
  String? _department;
  String? _jobTitle;
  String? _name;

  Future<void> _submitUserData(BuildContext context) async {
    if (testNavigation) {
      if (context.mounted) {
        context.go('/app');
      }

      return;
    }

    await postUserData(
      ref,
      _name!,
      _phoneNumber,
      _jobTitle!,
      _department!,
      () {
        ref.read(newUserProvider.notifier).set(true);
        ref.read(completedRegistryProvider.notifier).set(true);
      },
      () => setState(() {
        errorMessage = 'Hubo un error inesperado';
        showError = true;
      }),
    );
  }

  String? _validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Por favor introduzca nombre';
    }

    if (name.contains(RegExp(r''' [^$*.[\]{}()?\-"'!@#%&/\\,><:;_~`+=]'''))) {
      return 'Los nombres no pueden contener caracteres especiales';
    }

    setState(() {
      _name = name;
    });

    return null;
  }

  String? _validatePhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return null;
    }

    if (!RegExp(r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)')
        .hasMatch(phoneNumber)) {
      return 'Introduzca un número de teléfono válido';
    }

    setState(() {
      _phoneNumber = phoneNumber;
    });

    return null;
  }

  String? _validateJobTitle(String? jobTitle) {
    if (jobTitle == null || jobTitle.isEmpty) {
      return 'Por favor introduzca puesto';
    }

    setState(() {
      _jobTitle = jobTitle;
    });

    return null;
  }

  String? _validateDepartment(String? department) {
    if (department == null || department.isEmpty) {
      return 'Por favor introduzca departamento';
    }

    setState(() {
      _department = department;
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: SignInScreenMixin.formWidth,
              child: Column(
                children: [
                  const Padding(
                    padding: SignInScreenMixin.doublePadding,
                    child: Text(
                      'Completar registro de usuario',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: SignInScreenMixin.doublePadding,
                          child: CustomFormField(
                            label: 'Nombre',
                            hintText: 'tu nombre',
                            validator: _validateName,
                            autofillHint: AutofillHints.name,
                          ),
                        ),
                        Padding(
                          padding: SignInScreenMixin.doublePadding,
                          child: CustomFormField(
                            hintText: 'tu teléfono',
                            label: 'Número de teléfono',
                            validator: _validatePhoneNumber,
                            autofillHint: AutofillHints.telephoneNumber,
                          ),
                        ),
                        Padding(
                          padding: SignInScreenMixin.doublePadding,
                          child: CustomFormField(
                            label: 'Puesto',
                            hintText: 'tu puesto',
                            validator: _validateJobTitle,
                            autofillHint: AutofillHints.jobTitle,
                          ),
                        ),
                        Padding(
                          padding: SignInScreenMixin.doublePadding,
                          child: CustomFormField(
                            label: 'Departamento',
                            hintText: 'tu departamento',
                            validator: _validateDepartment,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: SignInScreenMixin.buttonPadding,
                    child: LoadingSolidButton(
                      text: 'Completar registro',
                      size: SignInScreenMixin.buttonSize,
                      textSize: SignInScreenMixin.buttonFontSize,
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          return await _submitUserData(context);
                        }
                      },
                    ),
                  ),
                  ShowUpText(
                    visible: showError,
                    text: errorMessage,
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.error,
                      fontSize: SignInScreenMixin.errorFontSize,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
