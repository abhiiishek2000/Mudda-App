import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../screens/home_screen/controller/mudda_fire_news_controller.dart';

class FlipCardWidget extends StatefulWidget {
  final Widget frontWidget;
  final Widget backWidget;
  final int index;

  const FlipCardWidget(
      {Key? key, required this.backWidget, required this.frontWidget,required this.index})
      : super(key: key);

  @override
  State<FlipCardWidget> createState() => _FlipCardWidgetState();
}

class _FlipCardWidgetState extends State<FlipCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  double dragPosition = 0;
  bool isFront = true;
  final muddaNewsController = Get.put(MuddaNewsController());

  setWidgetSide() {
    if (dragPosition <= 90 || dragPosition >= 270) {
      isFront = true;
    } else {
      isFront = false;
    }
  }

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    controller.addListener(() {
      setState(() {
        dragPosition = animation.value;
        setWidgetSide();
      });
    });

    super.initState();
  }
  @override
  void dispose() {
    dragPosition =0.0;
    isFront = true;
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double angle = dragPosition / 180 * pi;
    // if (isFront) angle += anglePlus;
    final transform = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateY(angle);
    return GestureDetector(
      onHorizontalDragUpdate: (details) => setState(() {
        dragPosition -= details.delta.dx;
        dragPosition %= 360;
        setWidgetSide();
        muddaNewsController.currentMuddaIndex.value =  widget.index;
      }),
      onHorizontalDragEnd: (details) {
        double end = isFront ? (dragPosition > 180 ? 360 : 0) : 180;
        animation = Tween<double>(
          begin: dragPosition,
          end: end,
        ).animate(controller);
        controller.forward(from: 0);
      },
      child: Transform(
        transform: transform,
        alignment: Alignment.center,
        child:  isFront
            ? widget.frontWidget
            : Transform(
            transform: Matrix4.identity()..rotateY(pi),
            alignment: Alignment.center,
            child: widget.backWidget),
      ),
    );
  }
}