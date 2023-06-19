import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:srujan/screens/document/documents.dart';
import 'package:srujan/screens/gpt/gpt_home.dart';
import 'package:srujan/services/auth/models/document_model.dart';
import 'package:srujan/services/auth/repositery/auth_repositery.dart';
import 'package:srujan/services/auth/repositery/document_repositery.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void signOut(WidgetRef ref) {
    ref.read(authRepositoryProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  void createDocument(BuildContext context, WidgetRef ref) async {
    String token = ref.read(userProvider)!.token;
    final navigator = Routemaster.of(context);
    final snackbar = ScaffoldMessenger.of(context);

    final errorModel = await ref.read(documentRepositoryProvider).createDocument(token);

    if (errorModel.data != null) {
      final document = errorModel.data as DocumentModel;
      navigator.push('/document/${document.id}');
    } else {
      snackbar.showSnackBar(
        SnackBar(
          content: Text(errorModel.error!),
        ),
      );
    }
  }

  void deleteDocument(BuildContext context, WidgetRef ref, String documentId) async {
    String token = ref.read(userProvider)!.token;
    final snackbar = ScaffoldMessenger.of(context);

    try {
      await ref.read(documentRepositoryProvider).deleteDocument(token, documentId);
      snackbar.showSnackBar(
        const SnackBar(
          content: Text('Document deleted successfully'),
        ),
      );
    } catch (e) {
      snackbar.showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  void navigateToDocument(BuildContext context, String documentId) {
    Routemaster.of(context).push('/document/$documentId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Your Documents'),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => ListView(
                        shrinkWrap: true,
                        children: [
                          ListTile(
                              leading: const Icon(Icons.camera_alt_rounded),
                              title: const Text('Try our new AI feature'),
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GptHome()))),
                          ListTile(
                            leading: const Icon(Icons.document_scanner_rounded),
                            title: const Text('Create a new document'),
                            onTap: () => createDocument(context, ref),
                          ),
                          ListTile(leading: const Icon(Icons.logout), title: const Text('Sign Out'), onTap: () => signOut(ref)),
                        ],
                      ));
            },
            icon: const Icon(Icons.menu_book),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(documentRepositoryProvider).getDocuments(ref.read(userProvider)!.token);
        },
        child: FutureBuilder(
          future: ref.watch(documentRepositoryProvider).getDocuments(
                ref.watch(userProvider)!.token,
              ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError || snapshot.data == null) {
              return const Text('Error loading documents');
            }

            List<DocumentModel> documents = snapshot.data!.data;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    DocumentModel document = documents[index];
                    return InkWell(
                      onLongPress: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => BottomSheet(
                                  onClosing: () {},
                                  builder: (context) => Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.delete),
                                        title: const Text('Delete'),
                                        onTap: () {
                                          deleteDocument(context, ref, document.id);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ));
                      },
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DocumentScreen(
                                    id: document.id,
                                  ))),
                      child: Card(
                        child: Center(
                          child: Text(
                            document.title,
                          ),
                        ),
                      ),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 300,
                  )),
            );
          },
        ),
      ),
    );
  }
}
