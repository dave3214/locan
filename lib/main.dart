import 'dart:convert';

import 'package:flutter/material.dart';
import './Models/Article.dart';
import './pages/Article.dart';
import './pages/ArtileC.dart';
import 'pages/login.dart';
import 'pages/signup.dart';
import 'pages/addnews.dart';
import 'pages/dashboard/admin.dart';
import 'package:http/http.dart' as http;
// import 'pages/Article.dart';
import './service/api.dart' as API;

// ignore: non_constant_identifier_names
var BASE_URL = 'http://localhost:3000/';

void main() async {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => HomePage(),
      '/login': (context) => LoginPage(),
      '/signup': (context) => SignUp(),
      '/addnews': (context) => Addnews(),
      // '/viewnews': (context) => Viewnews(),
      '/admin': (context) => Admin()
    },
  ));
}

class HomePage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<HomePage> {
  List news = <Article>[];
  Article? latestNews;
  bool isLogged = false;
  bool isAdmin = false;

  final _api = API.API();

  @override
  initState() {
    super.initState();

    fetchNews();

    userDetails();
  }

  Future fetchNews() async {
    var response = await http.get(Uri.parse(BASE_URL + "news/fetchNews"));
    var jsonData = jsonDecode(response.body);
    setState(() {
      latestNews = Article.fromJson(jsonData['data'][0]);
      news = (jsonData['data']).sublist(1);
    });
  }

  Future userDetails() async {
    dynamic user = await _api.getUserDetail();
    print(user);
    print(user['role'] == 'admin');
    setState(() {
      isLogged = user['isLogged'];
      isAdmin = user['role'] == 'admin';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: Container(
                margin: EdgeInsets.only(top: 36),
                color: Colors.amber[400],
                alignment: Alignment.center,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.home),
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/');
                      },
                    ),
                    Spacer(),
                    Row(
                      children: [
                        if (isLogged && isAdmin)
                          Container(
                              child: IconButton(
                            icon: Icon(Icons.admin_panel_settings),
                            tooltip: 'Moderate News',
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Admin()),
                              );
                            },
                          )),
                        Container(
                            child: IconButton(
                          icon: Icon(Icons.login_outlined),
                          onPressed: () async {
                            if (!await _api.isUserLogged()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            } else {
                              await _api.logout();
                              setState(() {
                                isLogged = false;
                                isAdmin = false;
                              });
                              Navigator.popAndPushNamed(context, '/');
                            }
                          },
                        ))
                      ],
                    ),
                  ],
                ),
                height: 40.0),
          ),
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ArticlePage(article: latestNews)));
              },
              child: Container(
                margin: EdgeInsets.all(6.0),
                padding: EdgeInsets.all(1.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
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
                    Container(
                        height: 200.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(latestNews?.urlToImage ?? ''),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(2.0),
                        )),
                    SizedBox(height: 8.0),
                    if (latestNews != null)
                      Container(
                        padding: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Text(
                          latestNews?.author ?? '',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    SizedBox(height: 8.0),
                    Text(
                      latestNews?.title ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    )
                  ],
                ),
              )),
          Flexible(
            flex: 4,
            fit: FlexFit.tight,
            child: ListView(children: [
              for (var item in news)
                customListTile(Article.fromJson(item), context)
            ]),
          )
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (await _api.isUserLogged()) {
              Navigator.pushNamed(context, '/addnews');
            } else {
              Navigator.pushNamed(context, '/login');
            }
          },
          tooltip: 'Add news',
          child: const Icon(Icons.add),
        ));
  }
}
