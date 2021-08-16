import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movietime/database/database.dart';
import 'package:movietime/models/movie.dart';

class MoviesProvider with ChangeNotifier {
  List<Movie> _items = [];

  //copy of my list that all the other classes use
  List<Movie> get items {
    return [..._items];
  }

  Movie findbyid(String id){
    
    return _items.firstWhere((element) => element.id==id);
  }

  void addMovie(String name, String director, File img) {
    final nm = Movie(
        id: DateTime.now().toString(),
        img: img,
        director: director,
        name: name);
    _items.add(nm);
    notifyListeners();
    DatabaseHelper.insert('movies_list', {
      'id': nm.id,
      'name': nm.name,
      'director': nm.director,
      'image': nm.img.path,
    });
  }

  void deleteMovie(String id) {
    int index = _items.indexWhere((element) => element.id == id);
    final m = _items.elementAt(index);
    _items.remove(m);
    notifyListeners();
    DatabaseHelper.delete('movies_list', id);
  }

  void updateMovie(String name, String director, File img, String id) {
    int index = _items.indexWhere((element) => element.id == id);
    _items[index].name = name;
    _items[index].director = director;
    _items[index].img = img;
    notifyListeners();
    DatabaseHelper.update('movies_list', {
      'id': id,
      'name': name,
      'director': director,
      'image': img.path,
    });
  }

  Future<void> fetchAndSet() async {
    final mlist = await DatabaseHelper.getData('movies_list');
    _items = mlist
        .map((e) => Movie(
            id: e['id'],
            img: File(e['image']),
            director: e['director'],
            name: e['name']))
        .toList();
    notifyListeners();
  }


}
