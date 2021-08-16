import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movietime/authentication/google_login_provider.dart';
import 'package:movietime/providers/movies_provider.dart';
import 'package:movietime/screens/add_movie_screen.dart';
import 'package:movietime/utils/app_color.dart';
import 'package:movietime/widgets/movietile.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final user = FirebaseAuth.instance.currentUser;

    return Container(
      color: Colors.transparent,
      child: SafeArea(
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            centerTitle: true,
            title: Text(
              'MY MOVIE LIST',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            elevation: 0,
            shadowColor: AppColor.grey,
          ),
          floatingActionButton: FloatingActionButton(
            elevation: 20,
            backgroundColor: AppColor.peach.withOpacity(0.8),
            child: Icon(
              Icons.add,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(AddMoviesScreen.routeName);
            },
          ),
          drawer: Drawer(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 80),
              color: AppColor.grey,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: AppColor.black,
                    backgroundImage: NetworkImage('${user!.photoURL}'),
                  ),
                  SizedBox(height: h * 0.04),
                  Container(
                    child: Text(
                      '${user.displayName}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: h * 0.02),
                  Container(
                    child: Text('${user.email}',
                        style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(height: h * 0.04),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(AppColor.peach)),
                      onPressed: () {
                        Provider.of<GoogleSignInProvider>(context,
                                listen: false)
                            .logout();
                      },
                      child: Text('Log out'))
                ],
              ),
            ),
          ),
          body: FutureBuilder(
            future: Provider.of<MoviesProvider>(context, listen: false)
                .fetchAndSet(),
            builder: (ctx, ss) => ss.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : Consumer<MoviesProvider>(
                    builder: (ctx, moviesdata, ch) {
                      if (moviesdata.items.length <= 0) {
                        return Center(
                            child: Text(
                          'Nothing to Display yet !',
                          style: TextStyle(color: Colors.white),
                        ));
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Scrollbar(
                            thickness: 1.5,
                            child: ListView.builder(
                              itemCount: moviesdata.items.length,
                              itemBuilder: (context, i) {
                                return MovieTile(
                                  id: moviesdata.items[i].id,
                                  director: moviesdata.items[i].director,
                                  name: moviesdata.items[i].name,
                                  img: moviesdata.items[i].img,
                                );
                              },
                            ),
                          ),
                        );
                      }
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
