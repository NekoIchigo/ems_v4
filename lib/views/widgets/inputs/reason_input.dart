import 'dart:convert';
import 'dart:io';

import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/inputs/number_label.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ReasonInput extends StatefulWidget {
  const ReasonInput({
    super.key,
    this.readOnly = false,
    this.showNumberLabel = true,
    this.number = 3,
    required this.controller,
    this.error,
    this.onChanged,
    required this.onSelectFile,
    required this.attachments,
  });

  final String? error;
  final bool showNumberLabel;
  final bool readOnly;
  final TextEditingController controller;
  final ValueChanged? onChanged;
  final int number;
  final Function(dynamic) onSelectFile;
  final List attachments;

  @override
  State<ReasonInput> createState() => _ReasonInputState();
}

class _ReasonInputState extends State<ReasonInput> {
  List<Map> files = [];

  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible: widget.showNumberLabel,
          child: NumberLabel(
            label: "Reason",
            number: widget.number,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 15, 0, 0),
          child: TextFormField(
            maxLines: 3,
            controller: widget.controller,
            style: defaultStyle,
            readOnly: widget.readOnly,
            onChanged: widget.onChanged,
            decoration: const InputDecoration(
              hintText: "Enter here",
              hintStyle: defaultStyle,
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: gray,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: gray,
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.error != null,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
            child: Text(widget.error ?? "", style: errorStyle),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
          child: LimitedBox(
            maxHeight: 50,
            child: ListView.builder(
              itemCount: widget.attachments.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return Text(widget.attachments[index]);
              },
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 15),
          width: widget.readOnly ? size.width * .32 : size.width * .45,
          child: TextButton(
            onPressed: () async {
              bool hasError = false;
              if (!widget.readOnly) {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  allowMultiple: true,
                  type: FileType.custom,
                  allowedExtensions: ['jpg', 'pdf', 'jpeg', 'png'],
                );

                if (result != null) {
                  // files = result.paths.map((path) => File(path!)).toList();

                  if (result.files.length > 2) {
                    showMessage('You must select 2 files only.');
                    hasError = true;
                  }
                  for (PlatformFile file in result.files) {
                    if (file.size > 3000000) {
                      showMessage('File must not exceed 3MB');
                      hasError = true;
                    }
                  }
                  if (!hasError) {
                    for (PlatformFile file in result.files) {
                      if (file.path != null) {
                        final actualFile = File(file.path!);
                        List<int> bytes = await actualFile.readAsBytes();
                        files.add({
                          "file_name": file.name,
                          "base_64": base64Encode(bytes),
                        });
                      }
                    }
                    widget.onSelectFile(files);
                  }
                } else {
                  showMessage(
                      'You did not select any file or something went bad.');
                }
              }
            },
            child: Visibility(
              visible: !widget.readOnly && widget.attachments.isEmpty,
              child: Row(
                children: [
                  Icon(
                    widget.readOnly
                        ? Icons.attach_file
                        : Icons.add_circle_outline,
                    size: 20,
                    color: primaryBlue,
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'Add attachment',
                    style: TextStyle(color: primaryBlue),
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: !widget.readOnly && widget.attachments.isEmpty,
          child: const Padding(
            padding: EdgeInsets.fromLTRB(25, 0, 0, 15),
            child: Text(
              "Upload up to 2 files (png, jpg, jpeg, pdf | 3 mb maximum size)",
              style: TextStyle(fontSize: 12, color: gray),
            ),
          ),
        ),
      ],
    );
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: size.height - 130,
          right: 20,
          left: 20,
        ),
      ),
    );
  }
}
