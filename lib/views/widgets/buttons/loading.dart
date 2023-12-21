import 'package:ems_v4/global/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      // child: Lottie.asset("assets/lottie/loading.json", width: 100),
      child: LoadingAnimationWidget.inkDrop(color: primaryBlue, size: 50),
    );
  }
}
