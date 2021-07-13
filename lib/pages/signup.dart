import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'login.dart';

import '../service/api.dart' as API;

void main() {
  runApp(MaterialApp(
    home: SignUp(),
  ));
}

class SignUp extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  String? errorMessage;

  final _api = API.API();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
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
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Text(
                'Please fill the below form continue',
                style: TextStyle(
                    color: Colors.blue,
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
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Full Name',
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
                child: Text('Sign Up'),
                onPressed: () async {
                  setState(() {
                    errorMessage = null;
                  });

                  var res = await _api.signup(
                      usernameController.text, passwordController.text);

                  if (res['status'] == 'error') {
                    setState(() {
                      errorMessage = res['message'];
                    });
                  } else {
                    // await _api.saveToken(res['token'], res['username'],
                    //  res['name'], res['role']);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));

                    Navigator.pushNamed(context, '/login');
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
                        text: "Already have an account? ",
                        children: <TextSpan>[
                          TextSpan(
                              text: "Log in",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                              recognizer: new TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
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
