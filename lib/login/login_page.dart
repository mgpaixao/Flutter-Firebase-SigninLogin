import 'package:aula4/create_account/create_account_page.dart';
import 'package:aula4/loggedin_home/loggedin_home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    FirebaseAuth.instance.signOut();

    // TODO: implement initState
    super.initState();
  }

  final _key = GlobalKey<FormState>();

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var _autovalidate = false;

  void _login() async {
    if (FirebaseAuth.instance.currentUser == null) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);

        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Login realizado com sucesso'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoggedIn_Home_Page()),
                        );
                      },
                      child: Text('Ok'),
                    )
                  ],
                ));
      } on FirebaseAuthException catch (e) {
        _handleLoginError(e);
      }
    } else {
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Já existe um usuário logado'),
                actions: [
                  TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pop(context);
                    },
                    child: Text('Logout'),
                  )
                ],
              ));
    }
  }

  void _handleLoginError(FirebaseException e) {
    String messageToDisplay;
    switch (e.code) {
      case 'invalid-email':
        messageToDisplay = 'O email é inválido';
        break;
      case 'user-not-found':
        messageToDisplay = 'Usuário não encontrado';
        break;
      case 'wrong-password':
        messageToDisplay = 'A senha está incorreta';
        break;
      case 'user-disabled':
        messageToDisplay = 'Usuário desabilitado';
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
                title: Text('Login falhou'),
                content: Text(messageToDisplay),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      passwordController.clear();
                    },
                    child: Text('Ok'),
                  )
                ]));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateAccountPage()));
          return true;
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: ListView(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 100),
                        const Text("Seja bem vindo",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        const Text("Faça o Login para continuar",
                            style:
                                TextStyle(fontSize: 20, color: Colors.black)),
                        const SizedBox(height: 50),
                        Form(
                            key: _key,
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xffFFFFFF),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: TextFormField(
                                      controller: emailController,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        labelText: 'Email',
                                      ),
                                      onSaved: (value) {
                                        emailController.text = value.toString();
                                      },
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Por favor, preencha o campo';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xffFFFFFF),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: TextFormField(
                                      obscureText: true,
                                      controller: passwordController,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        labelText: 'Password',
                                      ),
                                      onSaved: (value) {
                                        passwordController.text =
                                            value.toString();
                                      },
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Por favor, preencha o campo';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 60,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xff38C24E)),
                                  ),
                                  onPressed: () {
                                    if (_key.currentState!.validate()) {
                                      _key.currentState!.save();
                                      _login();

                                      print("save");
                                    } else {
                                      setState(() {
                                        _autovalidate = true;
                                      });
                                    }
                                  },
                                  child: const Text("Login",
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
                          child: const Text('Sign Up',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.normal)),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateAccountPage())),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
