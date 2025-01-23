import 'models/shared_model.dart';

class Constants {
  static String appName = "JURNI";
  static String signUp = "Sign Up";
  static String enterEmail = "Enter your email";
  static String enterPassword = "Enter your password";
  static String next = "NEXT";
  static String logout = "Logout";

  static List<SharedModel> get questions => [
        SharedModel(
          title: goals,
          question: goalsQuestions,
          options: goalsAnswers.map((e) => SharedModel(title: e)).toList(),
        ),
        SharedModel(
          title: preferences,
          question: preferencesQuestions,
          options: preferencesAnswers.map((e) => SharedModel(title: e)).toList(),
        ),
        SharedModel(
          title: activityLevel,
          question: activityLevelQuestions,
          options: activityLevelAnswers.map((e) => SharedModel(title: e)).toList(),
        ),
        SharedModel(
          title: cooking,
          question: cookingQuestions,
          options: cookingAnswers.map((e) => SharedModel(title: e)).toList(),
        ),
        SharedModel(
          title: ageAndWeight,
          question: ageAndWeightQuestions,
          options: ageList.map((e) => SharedModel(title: "$e yrs", value: e)).toList(),
          options2: weightList.map((e) => SharedModel(title: "$e lbs", value: e)).toList(),
        ),
      ];

  // Titles
  static String goals = "Goals";
  static String preferences = "Preferences";
  static String activityLevel = "Activity Level";
  static String cooking = "Cooking?";
  static String ageAndWeight = "Age and Weight";
  static String age = "Age";
  static String weight = "Weight";

  // Questions
  static String goalsQuestions = "What are your primary health goals?";
  static String preferencesQuestions = "Do you have any dietary preferences or restrictions?";
  static String activityLevelQuestions = "What is your current activity level?";
  static String cookingQuestions = "How often do you typically cook at home?";
  static String ageAndWeightQuestions = "What is your age and current weight?";

  // Answers List
  static List<String> goalsAnswers = ['Weight Loss', 'Muscle Gain', 'Maintaining Balanced Diet'];
  static List<String> preferencesAnswers = ['Vegetarian', 'Vegan', 'Gluten-free', 'Allergies'];
  static List<String> activityLevelAnswers = ['Sedentary', 'Lightly Active', 'Very Active'];
  static List<String> cookingAnswers = ['Rarely', 'Sometimes', 'Always'];
  static List<int> ageList = List.generate(70 - 17 + 1, (index) => 17 + index);
  static List<int> weightList = List.generate(700 - 50 + 1, (index) => 50 + index);

  // Routes
  static String rootPage = "/";
  static String onBoardingPage = "onBoarding";
  static String currentLevel = "currentLevel";
  static String profile = "profile";

  // Routes
  static String isLoggedIn = "isLoggedIn";
  static String firebaseUser = "firebaseUser";

  static String keyUsers = "users";
}
