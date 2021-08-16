import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mymovietime/providers/movies_provider.dart';
import 'package:mymovietime/utils/app_color.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;

class AddMoviesScreen extends StatefulWidget {
  static const routeName = '/add-movie-screen';
  const AddMoviesScreen({Key? key}) : super(key: key);

  @override
  _AddMoviesScreenState createState() => _AddMoviesScreenState();
}

class _AddMoviesScreenState extends State<AddMoviesScreen> {
  final _titleController = TextEditingController();
  final _directorController = TextEditingController();
  final key = GlobalKey<FormState>();
  File pickedimg = File('');
  dynamic storedimg;
  void _selectedImage(File p) {
    pickedimg = p;
  }

  @override
  void dispose() {
    _titleController.clear();
    _directorController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
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
        title: Text('Add a New Movie'),
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
                        Column(
                          children: [
                            Container(
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
                                  : Text(
                                      'No Image Taken',
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                              alignment: Alignment.center,
                            ),
                            SizedBox(height: h * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                    child: Text('Open Gallery')),
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: 'Movie Title',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            controller: _titleController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please fill this';
                              }
                              return null;
                            }),
                        TextFormField(
                            style: TextStyle(color: Colors.white),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: 'Director\'s Name',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            controller: _directorController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please fill this';
                              }
                              return null;
                            })
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
                  child: Text('Add Movie'))
            ],
          ),
        ),
      ),
    );
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
      _selectedImage(await savedimg);
    } catch (e) {
      print(e);
    }
  }

  void _onsaved() async {
    if (pickedimg.path == '') {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Image field cannot be empty')));
    }
    if (key.currentState!.validate() && pickedimg.path != '') {
      Provider.of<MoviesProvider>(context, listen: false)
          .addMovie(_titleController.text, _directorController.text, pickedimg);
      Navigator.of(context).pop();
    }
  }
}
