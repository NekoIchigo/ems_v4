import 'dart:io';

import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/announcement_controller.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

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
        FlutterCarousel(
          options: FlutterCarouselOptions(
            height: size.height * .80,
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
                  width: size.width,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  margin: const EdgeInsets.only(right: 10.0),
                  child: SingleChildScrollView(
                    padding: EdgeInsetsDirectional.zero,
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        Visibility(
                          visible: item['banner_path'] != null,
                          child: SizedBox(
                            height: 250,
                            width: size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
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
                              borderRadius: BorderRadius.circular(10.0),
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
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  item['user']['name'],
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Date Posted:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  _dateTimeUtils.fromLaravelDateFormat(
                                      item['start_date']),
                                  style: const TextStyle(fontSize: 12),
                                )
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
                            color: lightGray200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: HtmlWidget(
                            item['content'],
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        Positioned(
          right: 5,
          child: IconButton(
            onPressed: () {
              context.go('/in_out');
            },
            icon: const Icon(Icons.close_rounded),
          ),
        )
      ],
    );
  }
}
