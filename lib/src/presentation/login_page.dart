import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:movies/src/actions/index.dart';
import 'package:movies/src/containers/pending_container.dart';
import 'package:movies/src/models/index.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final FocusNode _passwordNode = FocusNode();

  void _onNext(BuildContext context) {
    print("blaaaa");
    User? user = FirebaseAuth.instance.currentUser;
    print("$user");
    if (!Form.of(context)!.validate()) {
      return;
    }
  print("$user");
    StoreProvider.of<AppState>(context).dispatch(Login.start(
        email: _email.text,
        password: _password.text,
        onResult: (AppAction action) {
          _onResult(action);
        }));
    // print("$user");
  }

  void _onResult(AppAction action) {
    if (action is ErrorAction) {
      final Object error = action.error;
      if (error is FirebaseAuthException) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message ?? "")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("$error")));
      }
    } else if (action is LoginSuccessful) {
      Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: PendingContainer(
            builder: (BuildContext context, Set<String> pending) {
          if (pending.contains(Login.pendingKey)) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
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
                    autofocus: true,
                    decoration: const InputDecoration(hintText: "email"),
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
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: const InputDecoration(hintText: "password"),
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
                      _onNext(context);
                    },
                  ),
                  TextButton(
                      onPressed: () => _onNext(context),
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.blue),
                      )),
                  TextButton(
                      onPressed: () =>
                          {Navigator.pushNamed(context, '/signUp')},
                      child: const Text(
                        "Signup",
                        style: TextStyle(color: Colors.blue),
                      ))
                ],
              ),
            ),
          ));
        }),
      ),
    );
  }
}
