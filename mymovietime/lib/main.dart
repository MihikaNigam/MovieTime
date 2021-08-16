import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mymovietime/authentication/google_login_provider.dart';
import 'package:mymovietime/providers/movies_provider.dart';

import 'package:mymovietime/screens/add_movie_screen.dart';
import 'package:mymovietime/screens/edit_movie_screen.dart';
import 'package:mymovietime/screens/home_screen.dart';
import 'package:mymovietime/screens/loading_screen.dart';
import 'package:mymovietime/utils/app_color.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'authentication/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MoviesProvider(),
        ),
      ],
      child: Consumer<GoogleSignInProvider>(
        builder: (context, auth, _) => MaterialApp(
          title: 'My Movie Lists',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Merriweather',
            accentColor: AppColor.peach,
            dividerColor: AppColor.grey,
            hintColor: AppColor.peach,
            primarySwatch: AppColor.kPrimaryColor,
          ),
          routes: {
            AddMoviesScreen.routeName: (ctx) => AddMoviesScreen(),
            UpdateMoviesScreen.routeName: (ctx) => UpdateMoviesScreen()
          },
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, ss) {
              print(ss.connectionState);
              if (ss.connectionState == ConnectionState.waiting ) {
                return LoadingScreen();
              } else if (ss.hasError) {
                return Center(
                  child: Text(
                    'Something went wrong..',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else if (ss.hasData) {
                return HomeScreen();
              } else {
                return LoginScreen();
              }
            },
          ),
        ),
      ),
    );
  }
}
