import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class API {
  String baseUrl;

  API({this.baseUrl = 'http://localhost:3000/'});

  Map<String, String> getHeaders(String? token) {
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };

    if (token != null) headers['Authorization'] = 'Bearer ' + token;

    return headers;
  }

  Future<dynamic> login(username, password) async {
    var body = json.encode({'username': username, 'password': password});
    var response = await http.post(Uri.parse(baseUrl + "login"),
        body: body, headers: getHeaders(null));

    return jsonDecode(response.body);
  }

  Future<dynamic> signup(username, password) async {
    print(username);
    print(password);
    var body = json.encode({'username': username, 'password': password});
    var response = await http.post(Uri.parse(baseUrl + "register"),
        body: body, headers: getHeaders(null));

    return jsonDecode(response.body);
  }

  Future<void> saveToken(
      String token, String? username, String? name, String? role, String? id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("token", token);
    pref.setBool("is_login", true);
    if (username != null) pref.setString("username", username);
    if (name != null) pref.setString("name", name);
    if (role != null) pref.setString("role", role);
    if (id != null) pref.setString("id", id);
  }

  Future<void> logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("auth_key");
    pref.remove("is_login");
    pref.remove("username");
    pref.remove("name");

    pref.remove("token");
    pref.remove("role");
    pref.remove("token");
    pref.remove("name");
    pref.remove("id");
  }

  Future<bool> isUserLogged() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("token") != null;
  }

  Future getUserDetail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return {
      'token': pref.getString("token"),
      'role': pref.getString("role"),
      'isLogged': pref.getString("token") != null,
      'name': pref.getString("name") != null,
      'id': pref.getString("id") 
    };
  }

  Future<dynamic> addNews(String title, String article, fullPhoto, String userID) async {
    var uri = Uri.parse(baseUrl + "news/addNewsImg");
    var request = http.MultipartRequest('POST', uri)
      ..fields['title'] = title
      ..fields['article'] = article
       ..fields['userId'] = userID
      ..files.add(new http.MultipartFile.fromBytes('photoimage', fullPhoto,
          filename: 'filename.jpeg',
          contentType: new MediaType('image', 'jpeg')));
      //..headers.addAll(getHeaders(token));
    var resp = await request.send();
    var response = jsonDecode(await resp.stream.bytesToString());
    return response;
  }

  Future<dynamic> getPendingNews() async {
    var response = await http.get(Uri.parse(baseUrl + "news/fetchPending"),
        headers: getHeaders(null));
    return jsonDecode(response.body);
  }

  Future<dynamic> authorizeNews(int newsID) async {
    if (newsID < 1) return;
    var response = await http.post(
        Uri.parse('${baseUrl}news/authorize/${newsID.toString()}'),
        headers: getHeaders(null));
    return jsonDecode(response.body);
  }
}
