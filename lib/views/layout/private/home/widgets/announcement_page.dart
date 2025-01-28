import 'dart:io';

import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/announcement_controller.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({super.key});

  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  final AnnouncementController _announcementController =
      Get.find<AnnouncementController>();
  final DateTimeUtils _dateTimeUtils = DateTimeUtils();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: FlutterCarousel(
            options: FlutterCarouselOptions(
              height: size.height * .75,
              showIndicator:
                  _announcementController.postedAnnouncements.length > 1,
              enableInfiniteScroll:
                  _announcementController.postedAnnouncements.length > 1,
              slideIndicator: CircularSlideIndicator(),
              autoPlay: _announcementController.postedAnnouncements.length > 1,
              autoPlayAnimationDuration: const Duration(seconds: 3),
            ),
            items: _announcementController.postedAnnouncements.map((item) {
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
                            Text(item['user']['name']),
                            Text(_dateTimeUtils
                                .fromLaravelDateFormat(item['start_date']))
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(
                          item['name'],
                          style: titleStyle,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 200,
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
    );
  }
}
