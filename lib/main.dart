import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movietime/authentication/google_login_provider.dart';
import 'package:movietime/providers/movies_provider.dart';

import 'package:movietime/screens/add_movie_screen.dart';
import 'package:movietime/screens/edit_movie_screen.dart';
import 'package:movietime/screens/home_screen.dart';
import 'package:movietime/screens/loading_screen.dart';
import 'package:movietime/utils/app_color.dart';
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
          home: auth.isSigningin
              ? LoadingScreen()
              : StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (ctx, ss) {
                    if (ss.hasData) {
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
/*
ChangeNotifierProvider(
      create: (BuildContext context) => GoogleSignInProvider(),
      child: MaterialApp(
        title: 'My Movie Lists',
        theme: ThemeData(
          fontFamily: 'Merriweather',
          primarySwatch: AppColor.kPrimaryColor,
        ),
        routes: {
          AddMoviesScreen.routeName: (ctx) => AddMoviesScreen(),
          UpdateMoviesScreen.routeName: (ctx) => UpdateMoviesScreen()
        },
        //darkTheme: ThemeData.dark(),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, ss) {
            final p = Provider.of<GoogleSignInProvider>(context).isSigningin;
            if (p) {
              return CircularProgressIndicator();
            } else if (ss.hasData) {
              return HomeScreen();
            } else {
              return LoginScreen();
            }
          },
        ),
      ),
    );*/

