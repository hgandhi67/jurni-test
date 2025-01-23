import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:jurni_test/cubits/auth/auth_cubit.dart';
import 'package:jurni_test/cubits/user_data/user_data_cubit.dart';
import 'package:jurni_test/data/constants.dart';
import 'package:jurni_test/data/models/user_data_model.dart';
import 'package:jurni_test/utils/pref_utils.dart';
import 'package:jurni_test/utils/size_utils.dart';
import 'package:jurni_test/utils/theme_helper.dart';
import 'package:jurni_test/utils/validations.dart';
import 'package:jurni_test/widgets/custom_loader_button.dart';
import 'package:jurni_test/widgets/custom_textfield.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isBusy = false;
  bool isBusyFetching = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      final isLogged = PrefUtils().getBool(Constants.isLoggedIn);
      final userString = PrefUtils().getString(Constants.firebaseUser);

      if (isLogged && userString.isNotEmpty) {
        final user = UserData.fromJson(jsonDecode(userString));

        if (user.goals != null && user.goals!.isNotEmpty) {
          context.pushReplacement("/${Constants.profile}", extra: user);
        } else {
          context.pushReplacement("/${Constants.onBoardingPage}", extra: {"currentLevel": 0});
        }
      } else {
        setBusyFetching(false);
        /// Do nothing user is not logged in yet
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state is AuthFailed) {
          setBusy(false);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
          return;
        }
        if (state is AuthSuccess) {
          final user = state.user;

          final userCubit = context.read<UserDataCubit>();
          await userCubit.updateUserDataOnFirebase(
            displayName: user.displayName,
            email: user.email,
            photoUrl: user.photoURL,
            phoneNumber: user.phoneNumber,
          );

          setBusy(false);
          context.go("/${Constants.onBoardingPage}", extra: {"currentLevel": 0});
          return;
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: appTheme.darkGrey,
          body: Builder(
            builder: (context) {
              if (isBusyFetching) {
                return SpinKitThreeBounce(
                  size: 40.fSize,
                  color: appTheme.white,
                );
              }

              return Column(
                children: [
                  _topView(),
                  _signUpView(),
                ],
              );
            },
          ),
        );
      },
    );
  }

  /// Widget which separates out the top view
  Widget _topView() {
    return Expanded(
      flex: 2,
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: appTheme.darkGrey,
        child: Center(
          child: Text(
            Constants.appName,
            style: TextStyle(color: Colors.white, fontSize: AppFontSizes.headingBigFontSize),
          ),
        ),
      ),
    );
  }

  /// Widget which separates out the bottom SignUp View.
  Widget _signUpView() {
    return Expanded(
      flex: 3,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 1, spreadRadius: 1, offset: Offset(0, 0)),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Text(
                        Constants.signUp,
                        style: TextStyle(
                          color: appTheme.primaryBlack,
                          fontSize: AppFontSizes.headingh1FontSize,
                        ),
                      ),
                      const SizedBox(height: 50),
                      CustomTextField(
                        textEditingController: _emailController,
                        fillColor: appTheme.lighterGrey,
                        hintText: Constants.enterEmail,
                        validator: (value) {
                          return Validation().validateEmail(value!);
                        },
                      ),
                      const SizedBox(height: 25),
                      CustomTextField(
                        textEditingController: _passwordController,
                        fillColor: appTheme.lighterGrey,
                        hintText: Constants.enterPassword,
                        validator: (value) {
                          return Validation().validatePassword(value!);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return CustomLoadingButton(
                        onPressed: _onSignUpClicked,
                        title: Constants.next,
                        context: context,
                        isBusy: isBusy,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// List of different functions for the click events, setter-getter
  void _onSignUpClicked() async {
    final validation = Validation();
    if (validation.validateEmail(_emailController.text) == null &&
        validation.validatePassword(_passwordController.text) == null) {
      final authCubit = context.read<AuthCubit>();
      setBusy(true);
      await authCubit.createUser(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      setBusy(false);
    }
  }

  void setBusy(bool value) {
    if (!mounted) return;
    setState(() {
      isBusy = value;
    });
  }

  void setBusyFetching(bool value) {
    if (!mounted) return;
    setState(() {
      isBusyFetching = value;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
