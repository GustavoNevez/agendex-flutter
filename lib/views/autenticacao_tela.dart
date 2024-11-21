import 'package:agendex_flutter/services/authenticator_service.dart';
import 'package:agendex_flutter/services/snack_bar.dart';
import 'package:agendex_flutter/services/text_form_field.dart';
import 'package:flutter/material.dart';

class AutenticacaoTela extends StatefulWidget {
  const AutenticacaoTela({super.key});

  @override
  State<AutenticacaoTela> createState() => _AutenticacaoTelaState();
}

class _AutenticacaoTelaState extends State<AutenticacaoTela> {
  bool userToLogin = true;
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  final AuthenticatorService _authenticatorService = AuthenticatorService();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    "assets/agendex.png",
                    height: 128,
                  ),
                  const Text(
                    "Seu tempo, sem filas!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 50),
                  TextFormField(
                    controller: _emailController,
                    decoration: getAuthenticationInputDecoration("Email"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email obrigatório!';
                      } else if (!emailRegex.hasMatch(value)) {
                        return 'Email inválido!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    decoration:
                        getAuthenticationInputDecoration("Senha").copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_passwordVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório!';
                      }
                      return null;
                    },
                  ),
                  Visibility(
                    visible: !userToLogin,
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _confirmController,
                          decoration: getAuthenticationInputDecoration(
                                  "Confirmar Senha")
                              .copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _confirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _confirmPasswordVisible =
                                      !_confirmPasswordVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !_confirmPasswordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo obrigatório!';
                            } else if (value != _passwordController.text) {
                              return 'As senhas não coincidem!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          decoration: getAuthenticationInputDecoration("Nome"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo obrigatório!';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String email = _emailController.text;
                        String password = _passwordController.text;
                        String name = _nameController.text;
                        if (userToLogin) {
                          _authenticatorService
                              .loginUsers(email: email, password: password)
                              .then((String? erro) {
                            if (erro != null) {
                              showSnackBar(context: context, text: erro);
                            }
                          });
                        } else {
                          _authenticatorService
                              .registerUser(
                                  name: name, email: email, password: password)
                              .then((String? erro) {
                            if (erro != null) {
                              showSnackBar(context: context, text: erro);
                            } else {
                              showSnackBar(
                                context: context,
                                text: "Usuário registrado com sucesso!",
                                isError: false,
                              );
                            }
                          });
                        }
                      }
                    },
                    child: Text(userToLogin ? "Entrar" : "Cadastrar"),
                  ),
                  const Divider(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        userToLogin = !userToLogin;
                      });
                    },
                    child: Text(
                      userToLogin
                          ? "Ainda não tem uma conta? Cadastre-se!"
                          : "Já tem uma conta? Entre!",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  if (userToLogin)
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            TextEditingController resetEmailController =
                                TextEditingController();
                            return AlertDialog(
                              title: Text("Redefinir Senha"),
                              content: Container(
                                height: 160,
                                child: Column(
                                  children: [
                                    Text(
                                      "Insira o seu email para enviar o link de redefinição de senha:",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: resetEmailController,
                                      decoration:
                                          getAuthenticationInputDecoration(
                                              "Email"),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Email obrigatório!';
                                        } else if (!emailRegex
                                            .hasMatch(value)) {
                                          return 'Email inválido!';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Cancelar"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    String email = resetEmailController.text;
                                    if (email.isEmpty ||
                                        !emailRegex.hasMatch(email)) {
                                      showSnackBar(
                                          context: context,
                                          text: "Email inválido!");
                                    } else {
                                      _authenticatorService
                                          .resetPassword(email)
                                          .then((String? erro) {
                                        Navigator.of(context).pop();
                                        if (erro != null) {
                                          showSnackBar(
                                              context: context, text: erro);
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text("Email Enviado"),
                                                content: Text(
                                                    "Enviaremos um e-mail para redefinição de senha, Verifique seu E-mail!"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text("Fechar"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      });
                                    }
                                  },
                                  child: Text("Redefinir Senha"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        "Esqueceu sua senha?",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
