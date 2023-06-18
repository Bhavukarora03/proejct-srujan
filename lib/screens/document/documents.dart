import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srujan/components/button.dart';
import 'package:srujan/services/auth/repositery/auth_repositery.dart';
import 'package:srujan/services/auth/repositery/document_repositery.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  final String id;

  const DocumentScreen({Key? key, required this.id}) : super(key: key);

  @override
  ConsumerState createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  TextEditingController _titlecontroller = TextEditingController(text: 'Untitled');
  final quill.QuillController _controller = quill.QuillController.basic();

  void updateTitle(WidgetRef ref, String title) async {
    ref.read(documentRepositoryProvider).updateTitle(token: ref.read(userProvider)!.token, id: widget.id, title: title);
  }

  @override
  void dispose() {
    _titlecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Icon(Icons.file_copy),
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
                onPressed: () {},
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
              quill.QuillToolbar.basic(controller: _controller),
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: quill.QuillEditor.basic(
                        controller: _controller,
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
