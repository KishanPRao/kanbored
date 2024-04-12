import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as flmd;
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:markdown/markdown.dart' as md;

class Markdown extends StatefulWidget {
  final String text;
  final Function(String) onChange;
  final Function() onEditStart;

  Markdown(
      {super.key,
      required this.text,
      required this.onChange,
      required this.onEditStart});

  // final TextEditingController controller;
  // final Function? onChange;
  // final int maxLines;

  @override
  State<StatefulWidget> createState() => MarkdownState();
}

class MarkdownState extends EditableState<Markdown> {
  // final int maxLines = 8;
  late TextEditingController controller;
  late Function(String) onChange;
  late Function() onEditStart;
  bool editing = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.text);
    onChange = widget.onChange;
    onEditStart = widget.onEditStart;
  }

  @override
  void endEdit(bool saveChanges) {
    setState(() {
      editing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextSelection currentSelection =
        const TextSelection(baseOffset: 0, extentOffset: 0);
    return Container(
      margin: const EdgeInsets.all(5),
      color: (editing ? "descEditBg" : "descBg").themed(context),
      child: editing
          ? Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
              child: TextField(
                autofocus: true,
                maxLines: null,
                style: const TextStyle(fontSize: 15),
                controller: controller,
                onChanged: (value) => onChange(value),
              ))
          : GestureDetector(
              onTap: () => setState(() {
                    editing = true;
                    onEditStart();
                  }),
              child: flmd.Markdown(
                controller: ScrollController(),
                selectable: true,
                onSelectionChanged: (text, selection, cause) {
                  log("onSelectionChanged: $selection, $text, $cause");
                  log("onSelectionChanged: ${selection.affinity}, ${selection.base}, ${selection.baseOffset}, ${selection.extent}, ${selection.extentOffset}, ${selection.end}, ${selection.start}");
                  currentSelection = selection;
                  // if (cause == SelectionChangedCause.tap) {
                  //
                  // }
                },
                styleSheet: flmd.MarkdownStyleSheet(
                  p: const TextStyle(fontSize: 15),
                ),
                onTapText: () => setState(() {
                  controller.selection = currentSelection;
                  editing = true;
                  onEditStart();
                })
                // onChange(controller.text);
                ,
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
                data: controller.text,
                shrinkWrap: true,
                extensionSet: md.ExtensionSet(
                  md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                  [
                    md.EmojiSyntax(),
                    ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                  ],
                ),
              )),
    );
  }
}
