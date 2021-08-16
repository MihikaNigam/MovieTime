import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movietime/providers/movies_provider.dart';
import 'package:movietime/screens/edit_movie_screen.dart';
import 'package:movietime/utils/app_color.dart';
import 'package:provider/provider.dart';

class MovieTile extends StatelessWidget {
  final String id;
  final String name;
  final String director;
  final File img;

  const MovieTile({
    Key? key,
    required this.id,
    required this.name,
    required this.director,
    required this.img,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Card(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: id,
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    height: h * 0.083,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: img.path == ''
                        ? Image.asset('assets/images/default-movie.png')
                        : Image.file(img),
                  ),
                ),
                SizedBox(width: w * 0.1),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: h * 0.022,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: h * 0.01),
                    Text(
                      'by $director',
                      style: TextStyle(color: Colors.grey, fontSize: h * 0.015),
                    )
                  ],
                ),
                Spacer(),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, UpdateMoviesScreen.routeName,
                            arguments: id);
                      },
                      child: const Icon(
                        Icons.edit,
                        color: AppColor.peach,
                        size: 20.0,
                      ),
                    ),
                    SizedBox(height: h * 0.01),
                    GestureDetector(
                      onTap: () {
                        showAlertDialog(name, context);
                      },
                      child: const Icon(
                        Icons.delete,
                        color: AppColor.peach,
                        size: 22.0,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Divider(thickness: 1)
      ],
    );
  }

  showAlertDialog(String name, BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        return Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Continue",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        Provider.of<MoviesProvider>(context, listen: false).deleteMovie(id);
      },
    );
    var alert = AlertDialog(
      title: Text("Delete Movie"),
      content: Text(
        "Are you sure you want to permanently remove $name from the movie list?",
        overflow: TextOverflow.visible,
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
        builder: (BuildContext context) {
          return alert;
        },
        context: context);
  }
}
