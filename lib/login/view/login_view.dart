import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit_login/login/service/login_service.dart';
import 'package:flutter_cubit_login/login/view/login_detail_view.dart';
import 'package:flutter_cubit_login/login/viewmodel/login_cubit.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  final String baseUrl = "https://reqres.in/api";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => LoginCubit(
              formKey,
              emailController,
              passwordController,
              service: LoginService(Dio(BaseOptions(baseUrl: baseUrl))),
            ),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginComplate) {
              state.navigate(context);
            }
          },
          builder: (context, state) {
            return buildScaffold(context, state);
          },
        ));
  }

  Scaffold buildScaffold(BuildContext context, LoginState state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cubit Login"),
        leading: Visibility(
          visible: context.watch<LoginCubit>().isLoading,
          child: const CircularProgressIndicator(),
        ),
      ),
      body: Form(
        key: formKey,
        autovalidateMode: autovalidatemode(state),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          buildTextFormFieldEmail(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          buildTextFormFieldPassword(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          buildElevatedButtonLogin(context)
        ]),
      ),
    );
  }

  Widget buildElevatedButtonLogin(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is LoginComplate) {
          return const Card(child: Icon(Icons.check));
        }

        return ElevatedButton(
          onPressed: context.watch<LoginCubit>().isLoading
              ? null
              : () {
                  context.read<LoginCubit>().postUserModel();
                },
          child: const Text("Save"),
        );
      },
    );
  }

  TextFormField buildTextFormFieldPassword() {
    return TextFormField(
      controller: passwordController,
      validator: (value) => (value ?? "").length > 5 ? null : "5 ten kucuk",
      decoration: const InputDecoration(
          border: OutlineInputBorder(), labelText: "Password"),
    );
  }

  TextFormField buildTextFormFieldEmail() {
    return TextFormField(
      controller: emailController,
      validator: (value) => (value ?? "").length > 6 ? null : "6 dan kucuk",
      decoration: const InputDecoration(
          border: OutlineInputBorder(), labelText: "Email"),
    );
  }

  autovalidatemode(LoginState state) {
    state is LoginValidateState
        ? (state.isValidateFail
            ? AutovalidateMode.always
            : AutovalidateMode.disabled)
        : AutovalidateMode.disabled;
  }
}

extension LoginComplateExtension on LoginComplate {
  void navigate(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginDetailView(model: model),
        ));
  }
}
