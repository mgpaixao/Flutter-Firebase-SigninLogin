import 'package:aula4/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'create_account_form.dart';

class CreateAccountPage extends StatefulWidget {
  CreateAccountPage({Key? key}) : super(key: key);

  @override
  State<CreateAccountPage> createState() => CreateAccountPageState();
}

class CreateAccountPageState extends State<CreateAccountPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SplashPage()));
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    const Text("Seja bem vindo",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    const Text("Let's get you started",
                        style: TextStyle(fontSize: 20, color: Colors.black)),
                    const SizedBox(height: 50),
                    CreateAccountForm(),
                    const SizedBox(height: 58),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
