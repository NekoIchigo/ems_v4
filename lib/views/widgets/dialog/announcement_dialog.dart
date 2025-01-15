import 'package:ems_v4/global/constants.dart';
import 'package:flutter/widgets.dart';
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
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Dialog(
      insetPadding: Device.get().isTablet
          ? const EdgeInsets.symmetric(vertical: 20, horizontal: 100)
          : const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      insetAnimationDuration: const Duration(milliseconds: 100),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: FlutterCarousel(
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
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 25),
                          Visibility(
                            visible: item['banner_path'] != null,
                            child: Container(
                              height: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.amber,
                              ),
                              child: Text(item['banner_path'].toString()),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${item['user_id']}"),
                              Text("${item['start_date']}")
                            ],
                          ),
                          Text(
                            item['name'],
                            style: titleStyle,
                          ),
                          HtmlWidget(item['content']),
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
              icon: Icon(Icons.close_rounded),
            ),
          )
        ],
      ),
    );
  }
}
