import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/register/cubit/states.dart';
import 'package:social_app/shared/components/functions.dart';
import 'package:social_app/shared/network/remote/firebase_constants.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());
  static RegisterCubit get(context) => BlocProvider.of(context);

  IconData passwordSuffix = Icons.visibility_outlined;
  bool isPassword = true;
  changePasswordViability() {
    isPassword = !isPassword;
    passwordSuffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(RegisterViabilityChangeState());
  }

  void userRegister({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    emit(RegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      uIdSaveLocal(value.user!.uid);
      userCreate(
        email: email,
        name: name,
        phone: phone,
        uId: value.user!.uid,
      );
    }).catchError((error) {
      RegExp regex = RegExp(r'\[^\/]+\\/[^\/]+\] (.+)');
      Match? match = regex.firstMatch(error.toString());

      if (match != null) {
        String capturedErrorMessage = match.group(1)!;
        log(capturedErrorMessage);
        emit(RegisterErrorState(error: capturedErrorMessage.toString()));
      } else {
        log("Error message not found.");
        log(error.toString());
        emit(RegisterErrorState(error: error.toString()));
      }
    });
  }

  void userCreate({
    required String email,
    required String name,
    required String phone,
    required String uId,
  }) {
    UserModel model = UserModel(
      uId: uId,
      name: name,
      email: email,
      phone: phone,
      banner:
          "https://image.freepik.com/free-photo/horizontal-shot-smiling-curly-haired-woman-indicates-free-space-demonstrates-place-your-advertisement-attracts-attention-sale-wears-green-turtleneck-isolated-vibrant-pink-wall_273609-42770.jpg",
      bio: "Write your bio ...",
      image:
          "https://image.freepik.com/free-photo/skeptical-woman-has-unsure-questioned-expression-points-fingers-sideways_273609-40770.jpg",
      isEmailVerified: false,
    );
    FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(uId)
        .set(model.toMap())
        .then((value) => emit(UserCreateSuccessState()))
        .catchError((error) {
      debugPrint(error.toString());
      emit(UserCreateErrorState(error: error.toString()));
    });
  }
}
