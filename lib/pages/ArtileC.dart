import 'package:flutter/material.dart';
import '../Models/Article.dart';

import 'Article.dart';

Widget customListTile(Article article, BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ArticlePage(article: article)));
    },
    child: Container(
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
                  height: 400.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(article.urlToImage ?? ''),
                        fit: BoxFit.fill),
                    borderRadius: BorderRadius.circular(12.0),
                  ))
              : Container(
                  height: 400.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/gd.jpeg'), fit: BoxFit.fill),
                    borderRadius: BorderRadius.circular(20.0),
                  )),
          SizedBox(height: 10.0),
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
          )
        ],
      ),
    ),
  );
}
