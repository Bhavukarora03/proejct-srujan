import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:srujan/components/button.dart';
import 'package:srujan/services/auth/models/error_model.dart' as models;
import 'package:srujan/services/auth/repositery/auth_repositery.dart';
import 'package:srujan/services/auth/repositery/document_repositery.dart';
import 'package:srujan/services/auth/repositery/socket_repositery.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  final String id;

  const DocumentScreen({Key? key, required this.id}) : super(key: key);

  @override
  ConsumerState createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  final TextEditingController _titlecontroller = TextEditingController(text: 'Untitled');
  quill.QuillController? _controller;
  models.ErrorModel? errorModelData;
  SocketRepository socketRepository = SocketRepository();

  void updateTitle(WidgetRef ref, String title) async {
    ref.read(documentRepositoryProvider).updateTitle(token: ref.read(userProvider)!.token, id: widget.id, title: title);
  }

  @override
  void dispose() {
    _titlecontroller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    socketRepository.joinRoom(widget.id);
    fetchDocumentData();
    socketRepository.changeListener((data) {
      _controller?.compose(
        quill.Delta.fromJson(data['delta']),
        _controller?.selection ?? const TextSelection.collapsed(offset: 0),
        quill.ChangeSource.REMOTE,
      );
    });
    Timer.periodic(const Duration(seconds: 2), (timer) {
      socketRepository.autoSave(<String, dynamic>{
        'delta': _controller!.document.toDelta(),
        'room': widget.id,
      });
    });
    super.initState();
  }

  void fetchDocumentData() async {
    errorModelData = await ref.read(documentRepositoryProvider).getDocumentById(token: ref.read(userProvider)!.token, id: widget.id);
    if (errorModelData!.data != null) {
      _titlecontroller.text = errorModelData!.data!.title!;
      _controller = quill.QuillController(
        document: errorModelData!.data.content.isEmpty
            ? quill.Document()
            : quill.Document.fromDelta(
                quill.Delta.fromJson(errorModelData!.data.content),
              ),
        selection: const TextSelection.collapsed(offset: 0),
      );

      setState(() {});
    }
    _controller!.document.changes.listen((event) {
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
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              GestureDetector(
                  onTap: () {
                    Routemaster.of(context).replace('/');
                  },
                  child: const Icon(Icons.file_copy)),
              const SizedBox(width: 8),
              TextField(
                controller: _titlecontroller,
                onSubmitted: (value) => updateTitle(ref, value),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Untitled',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Button(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: 'https://srujan.vercel.app/document/${widget.id}' ?? ''))
                      .then((value) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard'))));
                },
                variant: 'text',
                label: 'Share',
                icon: const Icon(Icons.share),
              ),
            )
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
              )
            ],
          ),
        ));
  }
}
