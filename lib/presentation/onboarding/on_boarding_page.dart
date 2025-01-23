import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jurni_test/cubits/auth/auth_cubit.dart';
import 'package:jurni_test/cubits/user_data/user_data_cubit.dart';
import 'package:jurni_test/data/constants.dart';
import 'package:jurni_test/data/models/shared_model.dart';
import 'package:jurni_test/utils/theme_helper.dart';
import 'package:jurni_test/widgets/custom_loader_button.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  int selectedAge = -1;
  int selectedWeight = -1;

  int currentIndex = 0;

  bool isBusy = false;

  final controller = PageController();

  final list = Constants.questions.toList();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserDataCubit, UserDataState>(
      listener: (context, state) {
        if (state is UserDataFailed) {
          setBusy(false);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
          return;
        }
        if (state is UserDataSuccess) {
          setBusy(false);
          context.pushReplacement("/${Constants.profile}", extra: state.userData);
          return;
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: appTheme.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _topBar(),
                  Expanded(child: _bottomView()),
                  _submitButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Widget which gives the functionality for back tracking and the
  /// Current page loader value.
  Widget _topBar() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: appTheme.mediumGrey,
          ),
          child: GestureDetector(
            onTap: _logout,
            child: const Center(
              child: Icon(Icons.arrow_back),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: SizedBox(
            height: 50,
            child: Center(
              child: LinearProgressBar(
                maxSteps: 5,
                progressType: LinearProgressBar.progressTypeLinear,
                currentStep: currentIndex + 1,
                progressColor: appTheme.primaryBlack,
                backgroundColor: appTheme.lightGrey,
                borderRadius: BorderRadius.circular(2),
                minHeight: 3,
              ),
            ),
          ),
        ),
        const SizedBox(height: 30, width: 70),
      ],
    );
  }

  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: CustomLoadingButton(
        onPressed: _onNextButtonClick,
        title: Constants.next,
        borderRadius: 25,
        context: context,
        isBusy: isBusy,
      ),
    );
  }

  /// Widget which shows the current page data on the based of the
  /// current page level.
  /// Manages multiple page within single Widget.
  Widget _bottomView() {
    return PageView.builder(
      controller: controller,
      itemCount: list.length,
      onPageChanged: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      itemBuilder: (_, index) {
        final item = list[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              item.title!,
              style: TextStyle(
                color: appTheme.primaryBlack,
                fontSize: AppFontSizes.headingBigFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              item.question!,
              style: TextStyle(
                color: appTheme.primaryBlack,
                fontSize: AppFontSizes.headingFontSize,
              ),
            ),
            const SizedBox(height: 25),
            item.title != Constants.ageAndWeight
                ? Flexible(child: _selectionTypeListWidget(index))
                : Flexible(child: _ageAndWeightPicker(item)),
          ],
        );
      },
    );
  }

  /// Widget used commonly for all the selection types.
  Widget _selectionTypeListWidget(int parentIndex) {
    final options = list[parentIndex].options!;

    return ListView.builder(
      itemCount: options.length,
      itemBuilder: (context, index) {
        final item = options[index];
        return GestureDetector(
          key: ValueKey(item),
          onTap: () {
            setState(() {
              for (var e in options) {
                e.isSelected = item.title == e.title;
              }
              list[parentIndex].options = options;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                color: item.isSelected ? appTheme.primaryBlack : appTheme.lightGrey,
                borderRadius: BorderRadius.circular(15)),
            child: Center(
              child: Text(
                item.title!,
                style: TextStyle(
                  color: item.isSelected ? appTheme.white : appTheme.primaryBlack,
                  fontSize: AppFontSizes.subHeadingFontSize,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Widget which gives the entire picker view for Age and Weight
  Widget _ageAndWeightPicker(SharedModel item) {
    return Row(
      children: [
        _singleCupertinoWidget(Constants.age, item.options!, (index) {
          selectedAge = item.options![index].value!;
        }),
        const SizedBox(width: 15),
        _singleCupertinoWidget(Constants.weight, item.options2!, (index) {
          selectedWeight = item.options2![index].value!;
        }),
      ],
    );
  }

  /// Single Common widget for a picker view, used for both Age
  /// and Weight commonly
  Widget _singleCupertinoWidget(
      String title, List<SharedModel> dataList, ValueChanged<int> onSelectedItemChanged) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: appTheme.primaryBlack,
              fontSize: AppFontSizes.subHeadingFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: CupertinoPicker(
              magnification: 1.2,
              useMagnifier: true,
              itemExtent: 32.0,
              onSelectedItemChanged: onSelectedItemChanged,
              scrollController: FixedExtentScrollController(initialItem: 12),
              children: dataList
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        item.title!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: appTheme.primaryBlack,
                          fontSize: AppFontSizes.subHeadingFontSize,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }


  /// List of different functions for the click events, setter-getter
  void setBusy(bool value) {
    if (!mounted) return;
    setState(() {
      isBusy = value;
    });
  }

  void _onNextButtonClick() async {
    if (currentIndex == 4 && selectedAge != -1 && selectedWeight != -1) {
      /// Save data on firebase

      final provider = context.read<UserDataCubit>();

      final goal =
          list.firstWhere((e) => e.title == Constants.goals).options!.firstWhere((e) => e.isSelected);
      final preferences =
          list.firstWhere((e) => e.title == Constants.preferences).options!.firstWhere((e) => e.isSelected);
      final activityLevel =
          list.firstWhere((e) => e.title == Constants.activityLevel).options!.firstWhere((e) => e.isSelected);
      final cooking =
          list.firstWhere((e) => e.title == Constants.cooking).options!.firstWhere((e) => e.isSelected);

      setBusy(true);

      await provider.updateUserDataOnFirebase(
        age: selectedAge,
        weight: selectedWeight,
        goals: goal.title,
        preferences: preferences.title,
        activityLevel: activityLevel.title,
        cooking: cooking.title,
      );

      setBusy(false);
    } else {
      final currentQuestion = list[currentIndex];

      final selected = currentQuestion.options!.firstWhereOrNull((e) => e.isSelected);

      if (selected != null) {
        controller.nextPage(duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
      }
    }
  }

  void _logout() {
    if (currentIndex == 0) {
      final provider = context.read<AuthCubit>();
      provider.logout();
      context.pop();
    } else {
      controller.previousPage(duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
