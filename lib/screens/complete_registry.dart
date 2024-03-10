import 'package:gtd_client/providers/completed_registry.dart';
import 'package:gtd_client/mixins/sign_in_screen_mixin.dart';
import 'package:gtd_client/widgets/account_form_field.dart';
import 'package:gtd_client/providers/session_token.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/widgets/show_up_text.dart';
import 'package:gtd_client/widgets/solid_button.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

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

  @override
  void initState() {
    super.initState();

    if (kDebugMode) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        if (ref.watch(sessionTokenProvider) == null) {
          context.go('/');
        }

        if (ref.watch(completedRegistryProvider)) {
          context.go('/app');
        }
      }
    });
  }

  void _submitUserData(BuildContext context) async {
    if (kDebugMode) {
      if (context.mounted) {
        context.go('/app');
      }

      return;
    }

    final String? sessionToken = ref.watch(sessionTokenProvider);

    final http.Response response = await http.post(
      Uri.parse('$serverUrl/userData/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $sessionToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'nombre': _name,
          'telefono': _phoneNumber,
          'puesto': _jobTitle,
          'departamento': _department,
        },
      ),
    );

    if (response.statusCode == 200) {
      ref.read(completedRegistryProvider.notifier).set(true);

      if (context.mounted) {
        context.go('/app');
      }

      return;
    }

    setState(() {
      errorMessage = 'Hubo un error inesperado';
      showError = true;
    });
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
      return 'Por favor introduzca número de teléfono';
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
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 200.0),
            SizedBox(
              width: 450.0,
              child: Column(
                children: [
                  const Padding(
                    padding: SignInScreenMixin.doublePadding,
                    child: Text(
                      'Completar registro de usuario',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Form(
                    child: Column(
                      children: [
                        Padding(
                          padding: SignInScreenMixin.doublePadding,
                          child: AccountFormField(
                            label: 'Nombre',
                            hintText: 'tu nombre',
                            validator: _validateName,
                            autofillHint: AutofillHints.name,
                          ),
                        ),
                        Padding(
                          padding: SignInScreenMixin.doublePadding,
                          child: AccountFormField(
                            hintText: 'tu teléfono',
                            label: 'Número de teléfono',
                            validator: _validatePhoneNumber,
                            autofillHint: AutofillHints.telephoneNumber,
                          ),
                        ),
                        Padding(
                          padding: SignInScreenMixin.doublePadding,
                          child: AccountFormField(
                            label: 'Puesto',
                            hintText: 'tu puesto',
                            validator: _validateJobTitle,
                            autofillHint: AutofillHints.jobTitle,
                          ),
                        ),
                        Padding(
                          padding: SignInScreenMixin.doublePadding,
                          child: AccountFormField(
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
                    child: SolidButton(
                      text: 'Completar registro',
                      size: SignInScreenMixin.buttonSize,
                      textSize: SignInScreenMixin.buttonFontSize,
                      onPressed: (_name != null) &&
                              (_phoneNumber != null) &&
                              (_jobTitle != null) &&
                              (_department != null)
                          ? () => _submitUserData(context)
                          : null,
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
