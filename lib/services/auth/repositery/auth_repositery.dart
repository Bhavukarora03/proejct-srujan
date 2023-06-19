import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:srujan/services/auth/models/error_model.dart' as models;
import 'package:srujan/services/auth/models/user_modal.dart' as models;
import 'package:srujan/services/auth/repositery/local_storage_repositery.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
      googleSignIn: GoogleSignIn(),
      client: http.Client(),
      localStorageRepository: LocalStorageRepository(),
    ));

final userProvider = StateProvider<models.User?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final http.Client _client;
  final LocalStorageRepository _localStorageRepository;
  final Logger _logger = Logger();

  AuthRepository({
    required GoogleSignIn googleSignIn,
    required http.Client client,
    required LocalStorageRepository localStorageRepository,
  })  : _googleSignIn = googleSignIn,
        _client = client,
        _localStorageRepository = localStorageRepository;

  Future<models.ErrorModel> signInWithGoogle() async {
    final baseUrl = dotenv.env['BASE_URL'];
    models.ErrorModel error = models.ErrorModel(
      error: 'Some unexpected error occurred.',
      data: null,
    );
    try {
      final googleUser = kIsWeb ? await _googleSignIn.signInSilently() : await _googleSignIn.signIn();
      if (googleUser != null) {
        print(googleUser);
        final userData = models.User(
          name: googleUser.displayName!,
          email: googleUser.email,
          profilePic: googleUser.photoUrl ?? "",
          token: "",
          uid: "",
        );
        final res = await _client.post(
          Uri.parse('$baseUrl/v1/auth/signup'),
          body: userData.toJson(),
          headers: {
            'Content-Type': 'application/json',
          },
        );
        print(res.body);
        print(res.statusCode);

        switch (res.statusCode) {
          case 200:
            print('User Created');
            final newUser = userData.copyWith(
              uid: jsonDecode(res.body)['user']['_id'],
              token: jsonDecode(res.body)['token'],
            );
            error = models.ErrorModel(error: null, data: newUser);
            _localStorageRepository.setToken(newUser.token);
            break;
        }
      }
    } catch (e) {
      error = models.ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }

  Future<models.ErrorModel> getUserData() async {
    final baseUrl = dotenv.env['BASE_URL'];
    models.ErrorModel error = models.ErrorModel(
      error: 'Some unexpected error occurred.',
      data: null,
    );
    try {
      String? token = await _localStorageRepository.getToken();
      if (token != null) {
        var res = await _client.get(
          Uri.parse('$baseUrl/'),
          headers: {
            'Content-Type': 'application/json',
            'x-auth-token': token,
          },
        );

        switch (res.statusCode) {
          case 200:
            final newUser = models.User.fromJson(
              jsonEncode(
                jsonDecode(res.body)['user'],
              ),
            ).copyWith(token: token);
            error = models.ErrorModel(error: null, data: newUser);
            _localStorageRepository.setToken(newUser.token);
            break;
          case 400:
            _logger.d('User Already Exists');
            break;
          case 500:
            _logger.d('Something Went Wrong');
            break;
          default:
        }
      }
    } catch (e) {
      _logger.d(e.toString());
      error = models.ErrorModel(
        error: e.toString(),
        data: null,
      );
    }

    return error;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _localStorageRepository.removeToken();
  }
}
