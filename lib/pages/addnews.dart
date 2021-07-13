import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../service/api.dart' as API;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MaterialApp(
    home: Addnews(),
  ));
}

class Addnews extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Addnews> {
  TextEditingController title = TextEditingController();
  TextEditingController article = TextEditingController();
  String? errorMessage;
  Image? _image;
  dynamic pickedFilePath;

  final _api = API.API();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add news'),
      ),
      body: Center(
          child: Container(
        child: Column(children: <Widget>[
          if (errorMessage != null && errorMessage != '')
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.red),
                child: Text(
                  errorMessage ?? '',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                )),
          Flexible(
              child: Container(
                  margin: EdgeInsets.all(15),
                  child: TextField(
                      controller: title,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'title of the news',
                      )))),
          Flexible(
              child: Container(
                  margin: EdgeInsets.all(15),
                  child: _image ?? Image.asset("saveimage.jpeg"))),
          Container(
              width: 400,
              child: TextButton(
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.redAccent,
                ),
                onPressed: () async {
                  final _picker = ImagePicker();

                  final PickedFile? pickedFile =
                      await _picker.getImage(source: ImageSource.camera);

                  print(pickedFile);

                  Image imagePath;

                  if (kIsWeb) {
                    imagePath = Image.network(pickedFile!.path);
                  } else {
                    imagePath = AssetImage(pickedFile!.path) as Image;
                  }

                  setState(() {
                    _image = imagePath;
                    pickedFilePath = pickedFile;
                  });
                },
              )),
          Flexible(
              child: Container(
                  margin: EdgeInsets.all(25),
                  child: TextField(
                      minLines: 10,
                      maxLines: 15,
                      controller: article,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'add artcle',
                      )),
                  height: 500)),
          Flexible(
              child: Container(
                  margin: EdgeInsets.all(5),
                  child: MaterialButton(
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: Text('Add news'),
                    onPressed: () async {
                      var user = await _api.getUserDetail();
                      var userID = user['id'];
                      print(user);
                      var res = await _api.addNews(title.text, article.text,
                          await pickedFilePath.readAsBytes(), userID);

                      if (res['status'] == 'error') {
                        setState(() {
                          errorMessage = res['message'];
                        });
                      } else {
                        setState(() {
                          errorMessage = "News added!";
                        });
                      }
                    },
                  ),
                  height: 50))
        ]),
      )),
    );
  }
}
