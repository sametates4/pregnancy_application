import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pregnancy_application/service/provider/user_type_model/user_type_model.dart';
import 'package:pregnancy_application/views/auth_view/auth_view.dart';
import 'package:pregnancy_application/views/home_view/home_view.dart';
import 'package:provider/provider.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserTypeModel()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          useMaterial3: true,
          scaffoldBackgroundColor: const Color.fromRGBO(250, 228, 218, 1),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromRGBO(250, 228, 218, 1),
            elevation: 0
          )
        ),
        home: FirebaseAuth.instance.currentUser != null ? const HomeView() : const AuthView()
      ),
    );
  }
}