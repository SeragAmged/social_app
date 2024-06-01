import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login/cubit/states.dart';
import 'package:social_app/shared/components/functions.dart';


class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());
  static LoginCubit get(context) => BlocProvider.of(context);

  IconData passwordSuffix = Icons.visibility_outlined;
  bool isPassword = true;
  void changePasswordViability() {
    isPassword = !isPassword;
    passwordSuffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(LoginViabilityChangeState());
  }

  void userLogin({required String email, required String password}) {
    {
      emit(LoginLoadingState());
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      ).then((value) {
        uIdSaveLocal(value.user!.uid);
        emit(LoginSuccessState());
      }).catchError((error, stackTrace) {
        emit(LoginErrorState(error: error.toString()));
        debugPrint(error.toString());
      });
    }
  }
}
