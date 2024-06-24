import 'dart:io';

import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/inputs/number_label.dart';
import 'package:file_picker/file_picker.dart';
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
  });

  final String? error;
  final bool showNumberLabel;
  final bool readOnly;
  final TextEditingController controller;
  final ValueChanged? onChanged;
  final int number;

  @override
  State<ReasonInput> createState() => _ReasonInputState();
}

class _ReasonInputState extends State<ReasonInput> {
  List<File?> files = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        Container(
          padding: const EdgeInsets.only(left: 15),
          width: widget.readOnly ? size.width * .32 : size.width * .45,
          child: TextButton(
            onPressed: () async {
              // TODO: Setup file_picker in IOS with Podfile
              if (!widget.readOnly) {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  allowMultiple: true,
                  // type: FileType.custom,
                  // allowedExtensions: ['jpg', 'pdf', 'doc'],
                );

                // print(file.name);
                // print(file.bytes);
                // print(file.size);
                // print(file.extension);
                // print(file.path);
                if (result != null) {
                  files = result.paths.map((path) => File(path!)).toList();
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                            'You did not select any file or something went bad.'),
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
              }
            },
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
                Text(
                  widget.readOnly ? 'View File' : 'Add attachment',
                  style: const TextStyle(color: primaryBlue),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
