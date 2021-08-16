import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movietime/providers/movies_provider.dart';
import 'package:movietime/utils/app_color.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:provider/provider.dart';

class UpdateMoviesScreen extends StatefulWidget {
  static const routeName = '/update-movie-screen';
  const UpdateMoviesScreen({Key? key}) : super(key: key);

  @override
  _UpdateMoviesScreenState createState() => _UpdateMoviesScreenState();
}

class _UpdateMoviesScreenState extends State<UpdateMoviesScreen> {
  String id = "";
  String initialname = "";
  String initialdirector = "";
  File initialimg = File('');
  final key = GlobalKey<FormState>();
  //File pickedimg = File('');
  dynamic storedimg;
  bool image_selected = false;
  void _selectedImage(File p) {
    initialimg = p;
  }

  imagepicker(ImageSource s) async {
    final _picker = ImagePicker();
    try {
      final image = await _picker.pickImage(
        source: s,
      );
      setState(() {
        storedimg = File(image!.path);
      });
      final appdir = await syspath.getApplicationDocumentsDirectory();
      final filename = path.basename(image!.path);
      final savedimg = File(image.path).copy('${appdir.path}/$filename');
      //pickedimg = await savedimg;
      _selectedImage(await savedimg);
    } catch (e) {
      print(e);
    }
  }

  void _onsaved() async {
    if (key.currentState!.validate()) {
      key.currentState!.save();
      Provider.of<MoviesProvider>(context, listen: false)
          .updateMovie(initialname, initialdirector, initialimg, id);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    id = ModalRoute.of(context)!.settings.arguments.toString();
    final selectedmov = Provider.of<MoviesProvider>(context).findbyid(id);
    initialname = selectedmov.name;
    initialdirector = selectedmov.director;
    initialimg = File('${selectedmov.img.path}');

    return Scaffold(
      backgroundColor: AppColor.black,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Update your Movie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Theme(
          data: ThemeData(
            primarySwatch: AppColor.kPc,
            fontFamily: 'Merriweather',
            accentColor: AppColor.peach,
            dividerColor: AppColor.grey,
            hintColor: Colors.white,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Form(
                    key: key,
                    child: Column(
                      children: [
                        //ImageInput(onselectimg: _selectedImage),
                        Column(
                          children: [
                            Hero(
                              tag: id,
                              child: Container(
                                height: h * 0.4,
                                width: w * 0.6,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.grey),
                                ),
                                child: storedimg != null
                                    ? Image.file(
                                        storedimg,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      )
                                    : initialimg.path == ''
                                        ? Image.asset(
                                            'assets/images/default-movie.png')
                                        : Image.file(
                                            initialimg,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          ),
                                alignment: Alignment.center,
                              ),
                            ),
                            SizedBox(height: h * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(10.0))),
                                    ),
                                    onPressed: () =>
                                        imagepicker(ImageSource.gallery),
                                    child: Text('Open gallery')),
                                TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(10.0))),
                                    ),
                                    onPressed: () =>
                                        imagepicker(ImageSource.camera),
                                    child: Text('Open Camera')),
                              ],
                            ),
                            SizedBox(height: h * 0.09),
                          ],
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: 'Movie Title',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          //controller: _titleController,
                          initialValue: initialname,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please fill this';
                            }
                            return null;
                          },
                          onSaved: (val) {
                            initialname = val!;
                          },
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: 'Director\'s Name',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          //controller: _directorController,
                          initialValue: initialdirector,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please fill this';
                            }
                            return null;
                          },
                          onSaved: (val) {
                            initialdirector = val!;
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      elevation: 10),
                  onPressed: _onsaved,
                  child: Text('Update Movie'))
            ],
          ),
        ),
      ),
    );
  }
}
