import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:srujan/services/auth/models/user_modal.dart' as models;

final authRepositoryProvider = Provider((ref) => AuthRepository(googleSignIn: GoogleSignIn(), client: http.Client()));

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final http.Client _client;

  AuthRepository({required GoogleSignIn googleSignIn, required http.Client client})
      : _googleSignIn = googleSignIn,
        _client = client;

  void signInWithGoogle(BuildContext context) async {
    final baseUrl = dotenv.env['BASE_URL'];
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final  userData = models.User(
          name: googleUser.displayName!,
          email: googleUser.email,
          profilePicture: googleUser.photoUrl!,
          token: "",
          uid: "",
        );
        final res = await _client.post(Uri.parse('$baseUrl/v1/auth/signup'), body: userData.toJson(), headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
        switch (res.statusCode) {
          case 200:

            break;
          case 400:
            print('User Already Exists');
            break;
          default:
            print('Something Went Wrong');
        }
      }


    } catch (error) {
      print(error);
    }
  }
}
