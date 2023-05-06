import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(googleSignIn: GoogleSignIn()));

class AuthRepository {
  final GoogleSignIn _googleSignIn;

  AuthRepository({required GoogleSignIn googleSignIn}) : _googleSignIn = googleSignIn;

  void signInWithGoogle(BuildContext context) async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser != null)
        {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Container()
            ),
          );
          if (kDebugMode) {
            print(googleUser);
          }
        }
    } catch (error) {
      print(error);
    }
  }
}
