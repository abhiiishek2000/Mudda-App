import 'package:flutter/material.dart';
import 'package:mudda/model/PostForMuddaModel.dart';
import 'package:mudda/ui/screens/mudda/view/journal_image_matrix.dart';

class MuddaVideo extends StatefulWidget {

  final double width;
  final String basePath;
  final List<Gallery> list;

  const MuddaVideo({
    Key? key,
    required this.list,
    required this.basePath,
    required this.width,
  }) : super(key: key);

  @override
  State<MuddaVideo> createState() => _MuddaVideoState();
}

class _MuddaVideoState extends State<MuddaVideo> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // CarouselSlider(
        //   options: CarouselOptions(
        //     height: widget.height,
        //     enableInfiniteScroll: false,
        //     onPageChanged: (int, CarouselPageChangedReason) {
        //       selectedIndex = int;
        //       setState(() {});
        //     },
        //     viewportFraction: 1.0,
        //     enlargeCenterPage: false,
        //     // autoPlay: false,
        //   ),
        //   items: List.generate(
        //     widget.list.length,
        //     (index) => GestureDetector(
        //       onTap: () {
        //         muddaGalleryDialog(
        //             context, widget.list, widget.basePath, index);
        //       },
        //       child: Container(
        //         decoration: BoxDecoration(
        //             color: colorAppBackground,
        //             borderRadius: BorderRadius.only(
        //                 topLeft: Radius.circular(ScreenUtil().setSp(8)),
        //                 bottomLeft: Radius.circular(ScreenUtil().setSp(8)))),
        //         child: Stack(
        //           alignment: Alignment.center,
        //           children: [
        //             Container(
        //               width: widget.width,
        //               height: widget.height,
        //               decoration: BoxDecoration(
        //                   color: colorAppBackground,
        //                   borderRadius: BorderRadius.only(
        //                       topLeft: Radius.circular(ScreenUtil().setSp(8)),
        //                       bottomLeft:
        //                           Radius.circular(ScreenUtil().setSp(8)))),
        //               child: CachedNetworkImage(
        //                 imageUrl:
        //                     "${widget.basePath}${widget.list.elementAt(index).file!}",
        //                 fit: BoxFit.cover,
        //               ),
        //             )
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // ),

        widget.list.isEmpty
            ? const SizedBox()
            : JournalImageMatrix(
          imageArr: widget.list,
          mediaFor: widget.basePath,
          basePath: widget.basePath,
        ),
        // Positioned(
        //   bottom: 5,
        //   left: 50,
        //   right: 50,
        //   child: SingleChildScrollView(
        //     scrollDirection: Axis.horizontal,
        //     child: Row(
        //       children: List.generate(
        //         widget.list.length,
        //             (index) => Padding(
        //           padding: const EdgeInsets.only(right: 10),
        //           child: selectedIndex != index
        //               ? Container(
        //             height: 5,
        //             width: 20,
        //             decoration: const BoxDecoration(
        //               color: Colors.white,
        //               borderRadius: BorderRadius.all(
        //                 Radius.circular(20),
        //               ),
        //             ),
        //           )
        //               : Container(
        //             height: 5,
        //             width: 20,
        //             decoration: const BoxDecoration(
        //               color: Colors.white,
        //               borderRadius: BorderRadius.all(
        //                 Radius.circular(20),
        //               ),
        //             ),
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Center(
        //                   child: Container(
        //                     height: 3,
        //                     width: 18,
        //                     decoration: const BoxDecoration(
        //                       color: Colors.amber,
        //                       borderRadius: BorderRadius.all(
        //                         Radius.circular(20),
        //                       ),
        //                     ),
        //                   ),
        //                 )
        //               ],
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}