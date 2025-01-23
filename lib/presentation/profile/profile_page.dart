import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:jurni_test/cubits/auth/auth_cubit.dart';
import 'package:jurni_test/data/constants.dart';
import 'package:jurni_test/data/models/user_data_model.dart';
import 'package:jurni_test/utils/pref_utils.dart';
import 'package:jurni_test/utils/size_utils.dart';
import 'package:jurni_test/utils/theme_helper.dart';
import 'package:jurni_test/widgets/custom_loader_button.dart';

class ProfilePage extends StatefulWidget {
  final UserData? userData;

  const ProfilePage({super.key, this.userData});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserData? userData;

  bool isBusy = false;
  final list = Constants.questions.toList();

  @override
  void initState() {
    super.initState();
    initValues();
  }

  void setBusy(bool value) {
    if (!mounted) return;
    setState(() {
      isBusy = value;
    });
  }

  void initValues() async {
    userData = widget.userData;

    /// If some how user is null get from the local shared preferences
    if (userData == null) {
      final userString = PrefUtils().getString(Constants.firebaseUser);
      if (userString.isNotEmpty) {
        userData = UserData.fromJson(jsonDecode(userString));
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.white,
      body: Builder(
        builder: (context) {
          if (isBusy) {
            return SpinKitThreeBounce(
              size: 40.fSize,
              color: appTheme.darkGrey,
            );
          }

          if (userData == null) {
            return const Center(
              child: Text("No user found."),
            );
          }

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 25),
                        Text(
                          "Congratulations!",
                          style: TextStyle(
                            color: appTheme.primaryBlack,
                            fontSize: AppFontSizes.headingh1FontSize,
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: list.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (_, index) {
                            final item = list[index];

                            String? value;

                            switch (index) {
                              case 0:
                                value = userData?.goals;
                                break;
                              case 1:
                                value = userData?.preferences;
                                break;
                              case 2:
                                value = userData?.activityLevel;
                                break;
                              case 3:
                                value = userData?.cooking;
                                break;
                              case 4:
                                value = "${userData?.age} yrs, ${userData?.weight} lbs";
                                break;
                            }

                            return _bottomView(
                              title: item.title!,
                              question: item.question!,
                              answer: "$value",
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16).copyWith(top: 8, bottom: 8),
                  child: BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return CustomLoadingButton(
                        onPressed: _logout,
                        title: Constants.logout,
                        context: context,
                        isBusy: isBusy,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _bottomView({
    required String question,
    String? answer,
    required String title,
    int? weight,
    int? age,
    bool showAnswerRow = true,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: appTheme.lightGrey, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: appTheme.primaryBlack,
              fontSize: AppFontSizes.headingh1FontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            question,
            style: TextStyle(
              color: appTheme.darkGrey,
              fontSize: AppFontSizes.headingFontSize,
            ),
          ),
          const SizedBox(height: 10),
          showAnswerRow
              ? _answerWidget(answer: answer ?? '')
              : Row(
                  children: [
                    Expanded(
                      child: _answerWidget(answer: age.toString()),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _answerWidget(
                        answer: weight.toString(),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _answerWidget({required String answer}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: appTheme.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: appTheme.mediumGrey,
        ),
      ),
      child: Center(
        child: Text(
          answer,
          style: TextStyle(
            color: appTheme.primaryBlack,
            fontSize: AppFontSizes.subHeadingFontSize,
          ),
        ),
      ),
    );
  }

  void _logout() async {
    final provider = context.read<AuthCubit>();
    await provider.logout();
    while (context.canPop()) {
      context.pop();
    }
    context.push("/");
  }
}
