import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'signup.dart';

import '../service/api.dart' as API;

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}

class LoginPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? errorMessage;

  final _api = API.API();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey.shade100,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Please login to continue...',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  )),
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
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  //forgot password screen
                },
                textColor: Colors.blue,
                child: Text('Forgot Password?'),
              ),
              Container(
                  height: 35,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: MaterialButton(
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: Text('Login'),
                    onPressed: () async {
                      setState(() {
                        errorMessage = null;
                      });

                      var res = await _api.login(
                          usernameController.text, passwordController.text);

                      if (res['status'] == 'error') {
                        setState(() {
                          errorMessage = res['message'];
                        });
                      } else {
                        print(res);
                        await _api.saveToken(res['token'], res['username'],
                            res['name'], res['role'], res['id'].toString());
                        Navigator.pushNamed(context, '/');
                      }
                    },
                  )),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.all(25),
                        child: Container(
                          child: Text.rich(TextSpan(
                            text: "Dont't have an account? ",
                            children: <TextSpan>[
                              TextSpan(
                                  text: "Sign up",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SignUp()),
                                      );
                                    }),
                            ],
                          )),
                        ))
                  ],
                ),
              )
            ]));
  }
}
