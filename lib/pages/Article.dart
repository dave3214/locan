import 'package:flutter/material.dart';
import './../Models/Article.dart';

class ArticlePage extends StatelessWidget {
  final Article? article;

  ArticlePage({this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article?.title ?? ''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
                fit: FlexFit.loose,
                flex: 8,
                child: article?.urlToImage != ''
                    ? Container(
                        height: 600.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  new NetworkImage(article?.urlToImage ?? ''),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      )
                    : Container(
                        height: 600.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(article?.urlToImage ?? ''),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      )),
            SizedBox(
              height: 8.0,
            ),
            if (article?.author != '')
              Container(
                padding: EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Text(
                  'By: ${article?.author}',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            SizedBox(
              height: 8.0,
            ),
            Flexible(
                flex: 5,
                fit: FlexFit.tight,
                child: ListView(
                  children: [
                    Text(
                      article?.description ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
