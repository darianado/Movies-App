import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:movies/src/models/index.dart';
import 'package:movies/src/actions/index.dart';

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
  }

  void _onResult(AppAction action) {
    if (action is ErrorAction) {
      final Object error = action.error;
      if (error is FirebaseAuthException) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message ?? "")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$error")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Builder(builder: (BuildContext context) {
          return SafeArea(
              child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(hintText: "email"),
                    autofocus: true,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return " pls enter smthing";
                      } else if (!value.contains('@')) {
                        return "not valid email";
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
                    decoration: const InputDecoration(hintText: "password"),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return " pls enter smthing";
                      } else if (value.length < 6) {
                        return "short";
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
                    decoration: const InputDecoration(hintText: "username"),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return " pls enter smthing";
                      }
                      return null;
                    },
                    onFieldSubmitted: (String value) {
                      _onNext(context);
                    },
                  ),
                  TextButton(
                      onPressed: () => _onNext(context),
                      child: const Text(
                        "Signup",
                        style: TextStyle(color: Colors.blue),
                      )),
                  TextButton(
                      onPressed: () => {Navigator.pop(context)},
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.blue),
                      ))
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
