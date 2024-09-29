import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:tweet_app/src/features/auth/components/auth_button.dart';
import 'package:tweet_app/src/features/auth/components/auth_error_snackbar.dart';
import 'package:tweet_app/src/features/auth/login/store/login_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:validatorless/validatorless.dart';

import '../components/auth_header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginStore loginStore;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    loginStore = Modular.get<LoginStore>();
    autorun((_) {
      if (loginStore.screenState == LoginState.error) {
        showAuthErrorSnackBar(
            context: context, message: loginStore.errorMessage!);
      }
    });
    when((_) => loginStore.screenState == LoginState.success, () {
      loginStore.setScreenState(newState: LoginState.idle);
      Modular.to.navigate('/tweet/');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const AuthHeader(
                title: 'Login',
                subTitle: 'Welcome Back',
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0), // Điều chỉnh giá trị này để thay đổi độ cong của góc
                    ),
                    labelText: 'Email',
                    labelStyle:
                    TextStyle(color: Theme.of(context).primaryColor),
                    prefixIcon: const Icon(Icons.email),
                  ),
                  validator: Validatorless.multiple([
                    Validatorless.required(
                        'Validation error: The field is obligatory.'),
                    Validatorless.email(
                        'Validation error: The field requires an email address'),
                  ]),
                  onChanged: (value) {
                    loginStore.loginModel =
                        loginStore.loginModel.copyWith(email: value);
                  },
                ),
              ),
              Observer(
                builder: (_) => Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0), // Điều chỉnh giá trị này để thay đổi độ cong của góc
                          ),
                          labelText: 'Password',
                          labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                          prefixIcon: const Icon(Icons.password),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              loginStore.changePasswordVisibility();
                            },
                            child: const Icon(Icons.remove_red_eye),
                          ),
                        ),
                        obscureText: loginStore.isPasswordFieldObscure,
                        validator: Validatorless.multiple([
                          Validatorless.required(
                              'Validation error: The field is obligatory.'),
                        ]),
                        onChanged: (value) {
                          loginStore.loginModel =
                              loginStore.loginModel.copyWith(password: value);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        child: const Text(
                          'Forget Password?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Observer(
                builder: (_) => Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: AuthButton(
                    labelButton: loginStore.screenState == LoginState.loading
                        ? 'Loading'
                        : 'Login',
                    onTap: () {
                      if (loginStore.screenState != LoginState.loading &&
                          loginStore.screenState != LoginState.success) {
                        if (_formKey.currentState!.validate()) {
                          loginStore.loginAction();
                        }
                      }
                    },
                  ),
                ),
              ),
              Text.rich(
                TextSpan(
                  text: "Don't have an account?",
                  style: const TextStyle(fontSize: 16),
                  children: [
                    TextSpan(
                      text: ' Register',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 16),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Modular.to.navigate('./registration');
                        },
                    ),
                  ],
                ),
              ),
              // const Padding(
              //                 padding: EdgeInsets.all(16),
              //                 child: Row(
              //                   mainAxisAlignment: MainAxisAlignment.center,
              //                   children: [
              //                     Icon(Icons.mark_unread_chat_alt_sharp, size: 70,),
              //                   ],
              //                 ),
              //               ),
            ],
          ),
        ),
      ),
    );
  }
}
