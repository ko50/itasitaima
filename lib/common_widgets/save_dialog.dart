import 'package:flutter/material.dart';

class SaveDialog extends StatelessWidget {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  static Future<String> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => SaveDialog(),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text("致した記録を保存します"),
        titleTextStyle: TextStyle(fontSize: 23),
        content: Container(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "記録を保存します\n"
                "コメントを入力してください",
              ),
              Flexible(
                child: _CommentForm(
                  formkey: _formkey,
                  controller: _controller,
                ),
              ),
            ],
          ),
        ),
        contentTextStyle: TextStyle(fontSize: 15),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("やめる"),
          ),
          FlatButton(
            onPressed: () {
              if (_formkey.currentState.validate())
                Navigator.pop(context, _controller.text);
            },
            child: Text("保存"),
          ),
        ],
      );
}

class _CommentForm extends StatefulWidget {
  final GlobalKey<FormState> formkey;
  final TextEditingController controller;

  _CommentForm({
    this.formkey,
    this.controller,
  });

  @override
  __CommentFormState createState() => __CommentFormState();
}

class __CommentFormState extends State<_CommentForm> {
  final InputBorder _errorBorder = OutlineInputBorder(
    borderSide: BorderSide(width: 2.0, color: Colors.red),
    borderRadius: BorderRadius.circular(8.0),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Form(
        key: widget.formkey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
          controller: widget.controller,
          validator: (s) {
            if (s.isEmpty || s.trim().isEmpty) return "何か入力してくださいカス";
            if (s.length > 100) return "長すぎ、100文字以内で";
            return null;
          },
          decoration: InputDecoration(
            hintText: "コメントを入力",
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 2.0, color: Colors.grey[600]),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2.0, color: Colors.grey[400]),
              borderRadius: BorderRadius.circular(8.0),
            ),
            errorBorder: _errorBorder,
            focusedErrorBorder: _errorBorder,
            errorStyle: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
