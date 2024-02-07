import 'package:gtd_client/mixins/sign_in_screen_mixin.dart';
import 'package:gtd_client/widgets/account_form_field.dart';
import 'package:gtd_client/widgets/clear_svg_button.dart';
import 'package:gtd_client/widgets/gradient_button.dart';
import 'package:gtd_client/providers/session_token.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/providers/account.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignInScreen extends ConsumerStatefulWidget {
  static const double _subTitleFontSize = 25.0;

  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen>
    with SignInScreenMixin {
  void _submitLogin(BuildContext context) async {
    if (kDebugMode) {
      ref.read(sessionTokenProvider.notifier).set('session_token');
      ref.read(accountProvider.notifier).set('account@account.acc');

      if (context.mounted) {
        context.go('/app');
      }

      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/background.png'),
          ),
        ),
        child: Center(
          child: SizedBox(
            width: 600.0,
            child: Column(
              children: [
                const SizedBox(height: 200.0),
                Text(
                  'Inicio de sesión',
                  style: TextStyle(
                    fontSize: 35.0,
                    color: colors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Inicia sesión con tu cuenta de ',
                        style: TextStyle(
                          color: colors.onPrimary,
                          fontSize: SignInScreen._subTitleFontSize,
                        ),
                      ),
                      Text(
                        'get tasks done',
                        style: TextStyle(
                          color: colors.onPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: SignInScreen._subTitleFontSize,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 350.0,
                  child: Column(
                    children: [
                      Padding(
                        padding: padding,
                        child: Text(
                          'Email',
                          style: TextStyle(
                            fontSize: labelFontSize,
                            color: colors.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: padding,
                              child: AccountFormField(
                                validator: validateEmail,
                                hintText: 'tu@correo.com',
                                autofillHint: AutofillHints.username,
                              ),
                            ),
                            Padding(
                              padding: padding,
                              child: Text(
                                'Contraseña',
                                style: TextStyle(
                                  fontSize: labelFontSize,
                                  color: colors.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Padding(
                              padding: padding,
                              child: AccountFormField(
                                validator: validatePassword,
                                hintText: 'Introduce tu contraseña',
                                autofillHint: AutofillHints.password,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: padding,
                        child: GradientButton(
                          height: 60.0,
                          buttonText: 'Inicia sesión',
                          onPressed: (account != null) && (password != null)
                              ? () => _submitLogin(context)
                              : null,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '¿Todavía no tienes cuenta? ',
                            style: TextStyle(
                              color: colors.onPrimary,
                              fontSize: SignInScreenMixin.messageFontSize,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(5.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                            ),
                            child: Text(
                              'Regístrate',
                              style: TextStyle(
                                color: colors.onPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: SignInScreenMixin.messageFontSize,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: padding,
                        child: ClearSvgButton(
                          height: 60.0,
                          onPressed: () {},
                          fileName: 'google_logo',
                          buttonText: 'Continuar con Google',
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
