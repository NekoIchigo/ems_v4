import 'dart:io';

import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/inputs/number_label.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ReasonInput extends StatefulWidget {
  final bool readOnly;
  const ReasonInput({super.key, required this.readOnly});

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
        const NumberLabel(label: "Reason", number: 3),
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 15, 0, 0),
          child: TextFormField(
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "Enter here",
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 15),
          width: size.width * .35,
          child: TextButton(
            onPressed: () async {
              // TODO: Setup file_picker in IOS with Podfile

              FilePickerResult? result = await FilePicker.platform.pickFiles(
                allowMultiple: true,
                // type: FileType.custom,
                // allowedExtensions: ['jpg', 'pdf', 'doc'],
              );
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

              // print(file.name);
              // print(file.bytes);
              // print(file.size);
              // print(file.extension);
              // print(file.path);
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
                const SizedBox(width: 3),
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
