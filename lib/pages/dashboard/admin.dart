import '../../Models/Article.dart';
import '../../service/api.dart' as API;

import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
var BASE_URL = 'http://localhost:3000/';

void main() {
  runApp(MaterialApp(
    home: Admin(),
  ));
}

class Admin extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Admin> {
  TextEditingController newsTitleController = TextEditingController();
  String? errorMessage;
  List pending = [];

  final _api = API.API();

  @override
  initState() {
    super.initState();
    fetchNews();
  }

  Future fetchNews() async {
    var response = await _api.getPendingNews();
    if (response['status'] == 'success') {
      var data = response['data'];
      setState(() {
        pending = data.map((item) => Article.fromJson(item)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending article'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [for (var item in pending) customList(item, context)],
        ),
      ),
    );
  }
}

Widget customList(Article article, BuildContext context) {
  // InkWell(
  //     onTap: () {
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => HomePage()));
  //     },
  //     child: '');
  return Container(
    margin: EdgeInsets.all(12.0),
    padding: EdgeInsets.all(8.0),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3.0,
          ),
        ]),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        article.urlToImage != ''
            ? Container(
                height: 200.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(article.urlToImage ?? ''),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(12.0),
                ))
            : Container(
                height: 200.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/gd.jpeg'), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(12.0),
                )),
        SizedBox(height: 8.0),
        if (article.author != '')
          Container(
            padding: EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Text(
              'By: ${article.author}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        SizedBox(height: 8.0),
        Text(
          article.title ?? '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        Container(
          padding: EdgeInsets.all(6.0),
          // decoration: BoxDecoration(
          //   color: Colors.red,
          //   borderRadius: BorderRadius.circular(30.0),
          // ),
          child: Row(
            children: [
              InkWell(
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text("Authorize",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        )),
                  ),
                  onTap: () async {
                    final _api = API.API();
                    print(article.id);
                    await _api.authorizeNews(article.id ?? 0);

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Admin()));
                  }),
            ],
          ),
        ),
      ],
    ),
  );
}
