import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:srujan/services/auth/models/document_model.dart' as models;
import 'package:srujan/services/auth/models/error_model.dart' as models;

final documentRepositoryProvider = Provider((ref) => DocumentRepository(
      client: http.Client(),
    ));

class DocumentRepository {
  final http.Client _client;

  DocumentRepository({required http.Client client}) : _client = client;

  Future<models.ErrorModel> createDocument(String token) async {
    final baseUrl = dotenv.env['BASE_URL'];
    models.ErrorModel error = models.ErrorModel(
      error: 'Some unexpected error occurred.',
      data: null,
    );
    try {
      var res = await _client.post(
        Uri.parse('$baseUrl/v1/document/create'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: jsonEncode({
          'createdAt': DateTime.now().millisecondsSinceEpoch,
        }),
      );
      switch (res.statusCode) {
        case 200:
          error = models.ErrorModel(
            error: null,
            data: models.DocumentModel.fromJson(res.body),
          );
          break;
        default:
          error = models.ErrorModel(
            error: res.body,
            data: null,
          );
          break;
      }
    } catch (e) {
      error = models.ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }

  Future<models.ErrorModel> getDocuments(String token) async {
    final baseUrl = dotenv.env['BASE_URL'];
    models.ErrorModel error = models.ErrorModel(
      error: 'Some unexpected error occurred.',
      data: null,
    );
    try {
      var res = await _client.get(
        Uri.parse('$baseUrl/v1/document/me'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );
      switch (res.statusCode) {
        case 200:
          List<models.DocumentModel> documents = [];

          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            documents.add(models.DocumentModel.fromJson(jsonEncode(jsonDecode(res.body)[i])));
          }
          error = models.ErrorModel(
            error: null,
            data: documents,
          );
          break;
        default:
          error = models.ErrorModel(
            error: res.body,
            data: null,
          );
          break;
      }
    } catch (e) {
      error = models.ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }

  void updateTitle({
    required String token,
    required String id,
    required String title,
  }) async {
    final host = dotenv.env['BASE_URL'];
    await _client.post(
      Uri.parse('$host/v1/document/title'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      },
      body: jsonEncode({
        'title': title,
        'id': id,
      }),
    );
  }

  Future<models.ErrorModel> getDocumentById({required String token, required String id}) async {
    final host = dotenv.env['BASE_URL'];
    models.ErrorModel error = models.ErrorModel(
      error: 'Some unexpected error occurred.',
      data: null,
    );
    try {
      var res = await _client.get(
        Uri.parse('$host/v1/document/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );
      switch (res.statusCode) {
        case 200:
          error = models.ErrorModel(
            error: null,
            data: models.DocumentModel.fromJson(res.body),
          );
          break;
        default:
          throw 'This Document does not exist, please create a new one.';
      }
    } catch (e) {
      error = models.ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }
}
