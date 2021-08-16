import 'package:flutter/material.dart';
import 'package:mymovietime/utils/app_color.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(50),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              child: Image.asset('assets/images/popcorn.jpg'),
            ),
            SizedBox(height: 20),
            LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColor.peach))
          ],
        ),
      ),
    );
  }
}
