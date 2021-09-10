import 'dart:convert';

import 'package:weezli/commons/weezly_colors.dart';
import 'package:weezli/commons/weezly_icon_icons.dart';
import 'package:weezli/service/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _storage = FlutterSecureStorage();
  final double _separator = 20;
  final identifierController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final identifierField = TextFormField(
      controller: identifierController,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: WeezlyColors.blue3,
          ),
        ),
        labelText: "Adresse Email",
        labelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Veuillez renseigner votre identifiant";
        }
        return null;
      },
    );
    final passwordField = TextFormField(
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: WeezlyColors.blue3,
            ),
          ),
          labelText: "Mot de passe",
          labelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          )),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Veuillez renseigner votre mot de passe";
        }
        return null;
      },
    );
    final _formKey = GlobalKey<FormState>();
    final authForm = Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Connectez-vous",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: WeezlyColors.primary,
              ),
            ),
            identifierField,
            SizedBox(
              height: _separator,
            ),
            passwordField,
            SizedBox(
              height: _separator,
            ),
            SizedBox(
              width: double.infinity,
              child: RawMaterialButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final Response response = await login(
                      identifierController.text,
                      passwordController.text,
                    );
                    if (response.statusCode == 200) {
                      final SnackBar snackBar = SnackBar(
                        content: Text("Connexion réussi"),
                      );
                      final data = jsonDecode(response.body);
                      await _storage.write(key: 'jwt', value: data["token"]);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.pushNamed(context, '/');
                    } else {
                      final SnackBar snackBar = SnackBar(
                        content: Text(
                          "L'identifiant ou le mot de passe ne sont pas valide",
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }
                },
                child: const Text("JE ME CONNECTE"),
                fillColor: WeezlyColors.blue2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.5),
                ),
                padding: EdgeInsets.all(15),
                textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: WeezlyColors.white,
                ),
              ),
            ),
            SizedBox(
              height: _separator,
            ),
            SizedBox(
              width: double.infinity,
              child: RawMaterialButton(
                onPressed: null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(
                        WeezlyIcon.facebook_official,
                        size: 20,
                      ),
                    ),
                    const Text(
                      "Se connecter avec facebook",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: WeezlyColors.white,
                      ),
                    ),
                  ],
                ),
                fillColor: WeezlyColors.facebook,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.5),
                ),
                padding: EdgeInsets.all(15),
                textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: WeezlyColors.white,
                ),
              ),
            ),
            SizedBox(
              height: _separator,
            ),
            const Text(
              "Mot de passe oublié?",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: WeezlyColors.blue4,
              ),
            ),
            SizedBox(
              height: _separator,
            ),
            const Text(
              "Pas encore de compte?",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: WeezlyColors.primary,
              ),
            ),
            SizedBox(
              height: _separator,
            ),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    width: 1,
                    color: WeezlyColors.blue2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.5),
                  ),
                ),
                onPressed: null,
                child: const Text(
                  "INSCRIVEZ-VOUS",
                  style: TextStyle(
                    color: WeezlyColors.blue2,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Connexion"),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                authForm,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
