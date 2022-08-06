import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _nameController = TextEditingController();

  final _passController = TextEditingController();

  final _addressController = TextEditingController();

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("Criar conta"),
          centerTitle: true,
          actions: [],
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoading)
              return Center(
                child: CircularProgressIndicator(),
              );
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  TextFormField(
                    decoration: InputDecoration(hintText: "Nome Completo"),
                    controller: _nameController,
                    validator: (nome) {
                      if (nome!.isEmpty) {
                        return 'Nome inválido';
                      }
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: "E-mail"),
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: (email) {
                      if (email == null || email.isEmpty) {
                        return 'Por favor, digite seu e-mail';
                      } else if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(_emailController.text)) {
                        return 'Por favor, digite um e-mail correto';
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(hintText: "Senha"),
                    obscureText: true,
                    controller: _passController,
                    validator: (senha) {
                      if (senha!.isEmpty || senha.length < 6)
                        return "Senha Inválida";
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(hintText: "Endereço"),
                    controller: _addressController,
                    validator: (endereco) {
                      if (endereco!.isEmpty) return "Endereço Inválido";
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Map<String, dynamic> userData = {
                            "name": _nameController.text,
                            "email": _emailController.text,
                            "address": _addressController.text
                          };
                          print(userData);
                          model.signUp(
                              userData: userData,
                              pass: _passController.text,
                              onSuccess: _onSuccess,
                              onFail: _onFail);
                        }
                      },
                      child: Text(
                        "Criar conta",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }

  void _onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Usuário criado com sucesso!"),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
    });
  }

  void _onFail() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Falha ao logar usuário!"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
