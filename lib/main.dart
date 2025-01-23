import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jurni_test/cubits/auth/auth_cubit.dart';
import 'package:jurni_test/cubits/user_data/user_data_cubit.dart';
import 'package:jurni_test/data/constants.dart';
import 'package:jurni_test/router.dart';
import 'package:jurni_test/utils/pref_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.value(PrefUtils().initializeSharedPreference());
  await Firebase.initializeApp();

  runApp(const JurniApp());
}

class JurniApp extends StatelessWidget {
  const JurniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => AuthCubit()),
        BlocProvider<UserDataCubit>(create: (_) => UserDataCubit()),
      ],
      child: MaterialApp.router(
        title: Constants.appName,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: AppRoutes.router,
      ),
    );
  }
}
