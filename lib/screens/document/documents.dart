import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:srujan/services/auth/models/document_model.dart';
import 'package:srujan/services/auth/models/error_model.dart';
import 'package:srujan/services/auth/repositery/auth_repositery.dart';
import 'package:srujan/services/auth/repositery/document_repositery.dart';
import 'package:srujan/services/auth/repositery/socket_repositery.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  final String id;

  const DocumentScreen({Key? key, required this.id}) : super(key: key);

  @override
  _DocumentScreenState createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  TextEditingController titleController = TextEditingController(text: 'Untitled');
  quill.QuillController? _controller;
  ErrorModel? errorModel;
  SocketRepository socketRepository = SocketRepository();

  void updateTitle(WidgetRef ref, String title) {
    ref.read(documentRepositoryProvider).updateTitle(
          token: ref.read(userProvider)!.token,
          id: widget.id,
          title: title,
        );
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print(widget.id);
    socketRepository.joinRoom(widget.id);
    fetchDocumentData();
    print(_controller);
    socketRepository.changeListener((data) {
      _controller!.compose(
        quill.Delta.fromJson(data['delta']),
        _controller?.selection ?? const TextSelection.collapsed(offset: 0),
        quill.ChangeSource.REMOTE,
      );
    });

    Timer.periodic(const Duration(seconds: 2), (timer) {
      socketRepository.autoSave(<String, dynamic>{
        'delta': _controller?.document.toDelta(),
        'room': widget.id,
      });
    });
  }

  void fetchDocumentData() async {
    errorModel = await ref.read(documentRepositoryProvider).getDocumentById(
          ref.read(userProvider)!.token,
          widget.id,
        );

    if (errorModel!.data != null) {
      titleController.text = (errorModel!.data as DocumentModel).title;
      _controller = quill.QuillController(
        document: errorModel!.data.content.isEmpty
            ? quill.Document()
            : quill.Document.fromDelta(
                quill.Delta.fromJson(errorModel!.data.content),
              ),
        selection: const TextSelection.collapsed(offset: 0),
      );
      setState(() {});
    }

    _controller?.document.changes.listen((event) {
      if (event.source == quill.ChangeSource.LOCAL) {
        Map<String, dynamic> map = {
          'delta': event.change,
          'room': widget.id,
        };
        socketRepository.typing(map);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Routemaster.of(context).replace('/');
                },
                child: const Icon(Icons.file_copy),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: TextField(
                  controller: titleController,
                  onSubmitted: (value) => updateTitle(ref, value),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Untitled',
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) => SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: 'https://srujan.vercel.app/document/${widget.id}' ?? '')).then(
                                      (value) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard'))));
                                },
                                leading: const Icon(Icons.copy),
                                title: const Text('Copy link'),
                              ),
                            ],
                          ),
                        ));
              },
              icon: const Icon(Icons.menu),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 16),
            quill.QuillToolbar.basic(controller: _controller!),
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: quill.QuillEditor.basic(
                      controller: _controller!,
                      readOnly: false, // true for view only mode
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
