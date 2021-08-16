import 'dart:io';

class Movie {
  String id;
  String name;
  String director;
  File img;
  Movie(
      {required this.id,
      required this.img,
      required this.director,
      required this.name});
}
