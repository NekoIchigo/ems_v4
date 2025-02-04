import 'dart:io';

import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class AnnouncementDialog extends StatefulWidget {
  final List items;
  const AnnouncementDialog({
    super.key,
    required this.items,
  });

  @override
  State<AnnouncementDialog> createState() => _AnnouncementDialogState();
}

class _AnnouncementDialogState extends State<AnnouncementDialog> {
  final DateTimeUtils _dateTimeUtils = DateTimeUtils();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Dialog(
      insetPadding: Device.get().isTablet
          ? const EdgeInsets.symmetric(vertical: 20, horizontal: 100)
          : const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      insetAnimationDuration: const Duration(milliseconds: 100),
      child: Stack(
        children: [
          FlutterCarousel(
            options: FlutterCarouselOptions(
              height: size.height * .75,
              showIndicator: widget.items.length > 1,
              enableInfiniteScroll: widget.items.length > 1,
              slideIndicator: CircularSlideIndicator(),
              autoPlay: widget.items.length > 1,
              autoPlayAnimationDuration: const Duration(seconds: 3),
            ),
            items: widget.items.map((item) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Visibility(
                          visible: item['banner_path'] != null,
                          child: SizedBox(
                            height: 250,
                            width: size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: item['banner_path'] != null
                                  ? File(item['banner_path']).existsSync()
                                      ? Image.file(File(item['banner_path']),
                                          fit: BoxFit.fitWidth)
                                      : Image.asset(
                                          'assets/images/announcement.png',
                                          fit: BoxFit.fitWidth,
                                        )
                                  : Image.asset(
                                      'assets/images/announcement.png',
                                      fit: BoxFit.fitWidth,
                                    ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: item['banner_path'] == null,
                          child: SizedBox(
                            height: 250,
                            width: size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.asset(
                                'assets/images/announcement.png',
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Posted by:",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(item['user']['name']),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Date Posted:",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(_dateTimeUtils
                                    .fromLaravelDateFormat(item['start_date']))
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(
                          item['name'],
                          style: titleStyle,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: lightGray,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: size.height * .26,
                          child: SingleChildScrollView(
                            child: HtmlWidget(
                              item['content'],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }).toList(),
          ),
          Positioned(
            right: 0,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close_rounded),
            ),
          )
        ],
      ),
    );
  }
}
