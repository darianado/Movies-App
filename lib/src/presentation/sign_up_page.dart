import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:movies/src/actions/index.dart';
import 'package:movies/src/models/index.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode _usernameNode = FocusNode();

  void _onNext(BuildContext context) {
    if (!Form.of(context)!.validate()) {
      return;
    }

    final CreateUser action =
        CreateUser(email: _email.text, username: _username.text, password: _password.text, onResult: _onResult);

    StoreProvider.of<AppState>(context).dispatch(action);

    Navigator.pop(context);
  }

  void _onResult(AppAction action) {
    if (action is ErrorAction) {
      final Object error = action.error;
      if (error is FirebaseAuthException) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message ?? '')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD4D1E6),
      body: Form(
        child: Builder(
          builder: (BuildContext context) {
            return SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/movie_logo.png',
                        height: 100,
                        width: 100,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          border: InputBorder.none,
                          focusedBorder: UnderlineInputBorder(),
                          icon: Icon(Icons.email, color: Color(0xFF231123)),
                        ),
                        autofocus: true,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter something';
                          } else if (!value.contains('@')) {
                            return 'Not a valid email';
                          }
                          return null;
                        },
                        onFieldSubmitted: (String value) {
                          FocusScope.of(context).requestFocus(_passwordNode);
                        },
                      ),
                      TextFormField(
                        controller: _password,
                        focusNode: _passwordNode,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: 'Password',
                          border: InputBorder.none,
                          focusedBorder: UnderlineInputBorder(),
                          icon: Icon(Icons.lock, color: Color(0xFF231123)),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter something';
                          } else if (value.length < 6) {
                            return 'Too short';
                          }
                          return null;
                        },
                        onFieldSubmitted: (String value) {
                          FocusScope.of(context).requestFocus(_usernameNode);
                        },
                      ),
                      TextFormField(
                        controller: _username,
                        focusNode: _usernameNode,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          hintText: 'Username',
                          border: InputBorder.none,
                          focusedBorder: UnderlineInputBorder(),
                          icon: Icon(Icons.person, color: Color(0xFF231123)),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter something';
                          }
                          return null;
                        },
                        onFieldSubmitted: (String value) {
                          _onNext(context);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(const Color(0xFF231123)),
                          minimumSize: MaterialStateProperty.all(const Size(200, 40)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        onPressed: () => _onNext(context),
                        child: const Text(
                          'SignUp',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(const Color(0xFF82204A)),
                          minimumSize: MaterialStateProperty.all(const Size(200, 40)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        // ignore: always_specify_types
                        onPressed: () => {Navigator.pop(context)},
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
