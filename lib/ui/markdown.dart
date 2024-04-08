import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as flmd;
import 'package:markdown/markdown.dart' as md;

class Markdown extends StatefulWidget {
  final String text;

  const Markdown({super.key, required this.text});

  // final TextEditingController controller;
  // final Function? onChange;
  // final int maxLines;

  @override
  State<StatefulWidget> createState() => MarkdownState();
}

class MarkdownState extends State<Markdown> {
  late TextEditingController controller;
  late String text;
  final Function? onChange = null;
  final int maxLines = 8;
  bool editing = false;

  @override
  void initState() {
    super.initState();
    text = widget.text;
    controller = TextEditingController(text: text);
  }

  @override
  Widget build(BuildContext context) {
    TextSelection currentSelection = const TextSelection(baseOffset: 0, extentOffset: 0);
    return editing
        ? TextFormField(
            autofocus: true,
            maxLines: 20,
            style: const TextStyle(fontSize: 15),
            controller: controller,
            onChanged: (string) {
              if (onChange != null) onChange!.call();
            },
          )
        : Scrollbar(
            child: SingleChildScrollView(
              child: flmd.Markdown(
                controller: ScrollController(),
                selectable: true,
                onSelectionChanged: (text, selection, cause) {
                  log("onSelectionChanged: $selection, $text");
                  currentSelection = selection;
                },
                styleSheet: flmd.MarkdownStyleSheet(
                  p: const TextStyle(fontSize: 15),
                ),
                onTapText: () {
                  log("On tap text");
                  setState(() {
                    controller.selection = currentSelection;
                    editing = true;
                  });
                },
                onTapLink: (_, href, __) async {
                  // if (href == null || !await canLaunch(href)) {
                  //   Fluttertoast.showToast(
                  //     msg: "Couldn't open the URL",
                  //     toastLength: Toast.LENGTH_SHORT,
                  //     gravity: ToastGravity.CENTER,
                  //     timeInSecForIosWeb: 1,
                  //     backgroundColor: Colors.red,
                  //     textColor: Colors.white,
                  //     fontSize: 16.0,
                  //   );
                  // } else {
                  //   launch(href);
                  // }
                },
                data: text,
                shrinkWrap: true,
                extensionSet: md.ExtensionSet(
                  md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                  [
                    md.EmojiSyntax(),
                    ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                  ],
                ),
              ),
            ),
          );
  }
}
