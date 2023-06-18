import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:srujan/services/auth/models/document_model.dart';
import 'package:srujan/services/auth/models/error_model.dart' as models;
import 'package:srujan/services/auth/repositery/auth_repositery.dart';
import 'package:srujan/services/auth/repositery/document_repositery.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void signOut(WidgetRef ref) {
    ref.read(authRepositoryProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  void createDocument(BuildContext context, WidgetRef ref) async {
    String token = ref.read(userProvider)!.token;
    final navigation = Routemaster.of(context);

    final errorModel = await ref.read(documentRepositoryProvider).createDocument(token);
    if (errorModel.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorModel.error!),
        ),
      );
    } else {
      navigation.push('/document/${errorModel.data!.id}');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            IconButton(
              onPressed: () {
                createDocument(context, ref);
              },
              icon: const Icon(Icons.add),
            ),
            IconButton(
              onPressed: () {
                signOut(ref);
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: FutureBuilder<models.ErrorModel>(
            future: ref.watch(documentRepositoryProvider).getDocuments(ref.watch(userProvider)!.token),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator.adaptive());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }
              return ListView.builder(
                itemBuilder: (context, index) {
                  DocumentModel document = snapshot.data!.data[index];
                  return ListTile(
                    title: Text(document.title),
                    subtitle: Text(document.createdAt.toString() ?? ''),
                    onTap: () {
                      Routemaster.of(context).push('/document/${document.id}');
                    },
                  );
                },
                itemCount: snapshot.data!.data.length,
              );
            }));
  }
}
