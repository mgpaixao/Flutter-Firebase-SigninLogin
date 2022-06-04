import 'package:aula4/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../shared/genericForm.dart';

class CreateAccountForm extends StatefulWidget {
  CreateAccountForm({Key? key}) : super(key: key);

  @override
  State<CreateAccountForm> createState() => _CreateAccountFormState();
}

class _CreateAccountFormState extends State<CreateAccountForm> {
  bool loading = false;

  void _handleSignUpError(FirebaseAuthException e) {
    String messageToDisplay;
    switch (e.code) {
      case 'email-already-in-use':
        messageToDisplay = 'O email já está em uso';
        break;
      case 'invalid-email':
        messageToDisplay = 'O email é inválido';
        break;
      case 'weak-password':
        messageToDisplay = 'A senha é muito fraca';
        break;
      case 'wrong-password':
        messageToDisplay = 'A senha está incorreta';
        break;
      case 'operation-not-allowed':
        messageToDisplay = 'Operação não permitida';
        break;
      default:
        messageToDisplay = 'Erro desconhecido';
        break;
    }

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('Sign up falhou'),
                content: Text(messageToDisplay),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _confirmedPasswordController.clear();
                      _passwordController.clear();
                      _emailController.clear();
                    },
                    child: Text('Ok'),
                  )
                ]));
  }

  Future _signUp() async {
    setState(() {
      loading = true;
    });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _confirmedPasswordController.text,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_emailController.text)
          .set({
        'email': _emailController.text,
        'password': _confirmedPasswordController.text,
        'name': _nameController.text,
      });

      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Sucesso'),
                content: Text('Usuário criado com sucesso'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Realizar Login'),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                  )
                ],
              ));
    } on FirebaseAuthException catch (e) {
      _handleSignUpError(e);
      setState(() {
        loading = false;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmedPasswordController = TextEditingController();

  String? _requiredValidator(String? text) {
    if (text == null || text.trim().isEmpty) {
      return 'Por favor, preencha o campo';
    }
    return null;
  }

  String? _passwordValidator(String? password) {
    if (password == null || password.trim().isEmpty) {
      return 'Por favor, preencha o campo';
    }

    if (password != _passwordController.text) {
      return 'As senhas não conferem';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          CustomTextFormField(
            controller: _nameController,
            label: 'Nome',
            obscureText: false,
            validator: _requiredValidator,
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            controller: _emailController,
            label: 'Email',
            obscureText: false,
            validator: _requiredValidator,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
              controller: _passwordController,
              label: 'Senha',
              obscureText: true,
              validator: _requiredValidator),
          const SizedBox(height: 20),
          CustomTextFormField(
              controller: _confirmedPasswordController,
              label: 'Confirmar Senha',
              obscureText: true,
              validator: _passwordValidator),
          const SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xff38C24E)),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _signUp();
                      } else {}
                    },
                    child: const Text("Sign in",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          InkWell(
            child: const Text('Login',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage())),
          )
        ],
      ),
    );
  }
}
