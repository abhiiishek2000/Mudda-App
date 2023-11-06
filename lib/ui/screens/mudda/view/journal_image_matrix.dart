import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mudda/ui/screens/mudda/view/screen_size.dart';

import '../../../../core/utils/color.dart';
import 'mudda_details_screen.dart';

class JournalImageMatrix extends StatefulWidget {
  const JournalImageMatrix({
    Key? key,
    this.imageArr,
    this.mediaFor,
    required this.basePath
  }) : super(key: key);

  final imageArr;
  final String? mediaFor;
  final String basePath;

  @override
  _JournalImageMatrixState createState() => _JournalImageMatrixState();
}

class _JournalImageMatrixState extends State<JournalImageMatrix> {
  @override
  Widget build(
      BuildContext context,
      ) {
    switch (widget.imageArr.length) {
      case 1:
        {
          if (widget.imageArr[0] == null) {
            return const SizedBox();
          } else if(widget.imageArr[0].file.contains('.mp4'))
          {
            var fileToCompressPath = widget.imageArr[0].file;
            final fileFormat = fileToCompressPath.substring(fileToCompressPath.lastIndexOf('.'));
            fileToCompressPath = fileToCompressPath.replaceAll(fileFormat, '');

            return GestureDetector(
              onTap: (){
                muddaGalleryDialog(
                    context,
                    widget.imageArr,
                    widget.basePath,
                    0
                );
              },
              child: photoContainer(
                true,
                MediaQuery.of(context).size.width,
                Get.height * 0.23,
                "${widget.mediaFor}$fileToCompressPath-lg.png",
                duration: "00: ",
                // mediaFor: widget.imageArr[0]["mediaFor"]
              ),
            );

          }
          else{
            return GestureDetector(
              onTap: (){
                muddaGalleryDialog(
                    context,
                    widget.imageArr,
                    widget.basePath,
                    0
                );
              },
              child: photoContainer(
                false,
                MediaQuery.of(context).size.width,
                Get.height * 0.35,
                "${widget.mediaFor}${widget.imageArr[0].file!}",
                duration: "00: ",
                // mediaFor: widget.imageArr[0]["mediaFor"]
              ),
            );
          }
        }
      case 2:
        {
          String? video1;
          String? video2;
          if(widget.imageArr[0]!=null && widget.imageArr[0].file!.contains('.mp4')){
            var fileToCompressPath = widget.imageArr[0].file;
            final fileFormat = fileToCompressPath.substring(fileToCompressPath.lastIndexOf('.'));
            video1 = "${fileToCompressPath.replaceAll(fileFormat, '')}-lg.png";
          }else if(widget.imageArr[1]!=null && widget.imageArr[1].file!.contains('.mp4')){
            var fileToCompressPath = widget.imageArr[1].file;
            final fileFormat = fileToCompressPath.substring(fileToCompressPath.lastIndexOf('.'));
            video2 = "${fileToCompressPath.replaceAll(fileFormat, '')}-lg.png";
          }

          return SizedBox(
            width: SizeConfig.screenWidth,
            // height: SizeConfig.screenWidth,
            child: Row(
              children: <Widget>[
                widget.imageArr[0] == null
                    ? const SizedBox()
                    : Expanded(
                  child: GestureDetector(
                    onTap: (){
                      muddaGalleryDialog(
                          context,
                          widget.imageArr,
                          widget.basePath,
                          0
                      );
                    },
                    child: photoContainer(
                      video1!=null? true: false,
                      MediaQuery.of(context).size.width,
                      SizeConfig.screenHeight ?? Get.height * 0.17,
                      "${widget.mediaFor}${video1 ?? widget.imageArr[0].file!}",
                    ),
                  ),
                ),
                const SizedBox(width: 3),
                widget.imageArr[1] == null
                    ? const SizedBox()
                    : Expanded(
                  child: GestureDetector(
                    onTap: () {
                      muddaGalleryDialog(
                          context,
                          widget.imageArr,
                          widget.basePath,
                          1
                      );
                    },
                    child: photoContainer(
    video2!=null? true: false,
                      MediaQuery.of(context).size.width,
                      SizeConfig.screenHeight ?? Get.height * 0.17,
                      "${widget.mediaFor}${video2 ??widget.imageArr[1].file!}",
                    ),
                  ),
                ),
              ],
            ),
          );
        }

      // case 3:
      //   {
      //     return SizedBox(
      //       width: SizeConfig.screenWidth,
      //       child: Column(
      //         children: <Widget>[
      //           Row(
      //             children: <Widget>[
      //               widget.imageArr[0] == null
      //                   ? const SizedBox()
      //                   : Expanded(
      //                 child: GestureDetector(
      //                   onTap: (){
      //                     muddaGalleryDialog(
      //                         context,
      //                         widget.imageArr,
      //                         widget.basePath,
      //                         0
      //                     );
      //                   },
      //                   child: photoContainer(
      //                     SizeConfig.screenWidth,
      //                     SizeConfig.screenHeight ?? 100.0,
      //                     "${widget.mediaFor}${widget.imageArr[0].file!}",
      //                   ),
      //                 ),
      //               ),
      //               const SizedBox(width: 2),
      //               widget.imageArr[1] == null
      //                   ? const SizedBox()
      //                   : Expanded(
      //                 child: GestureDetector(
      //                   onTap: (){
      //                     muddaGalleryDialog(
      //                         context,
      //                         widget.imageArr,
      //                         widget.basePath,
      //                         1
      //                     );
      //                   },
      //                   child: photoContainer(
      //                     SizeConfig.screenWidth,
      //                     SizeConfig.screenHeight ?? 100.0,
      //                     "${widget.mediaFor}${widget.imageArr[1].file!}",
      //                   ),
      //                 ),
      //               ),
      //               const SizedBox(width: 2),
      //               widget.imageArr[2] == null
      //                   ? const SizedBox()
      //                   : Expanded(
      //                 child: GestureDetector(
      //                   onTap: (){
      //                     muddaGalleryDialog(
      //                         context,
      //                         widget.imageArr,
      //                         widget.basePath,
      //                         2
      //                     );
      //                   },
      //                   child: photoContainer(
      //                     SizeConfig.screenWidth,
      //                     SizeConfig.screenHeight ?? 100.0,
      //                     "${widget.mediaFor}${widget.imageArr[2].file!}",
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ],
      //       ),
      //     );
      //   }
      // case 4:
      //   {
      //     return SizedBox(
      //       width: SizeConfig.screenWidth,
      //       child: Column(
      //         children: <Widget>[
      //           Row(
      //             children: <Widget>[
      //               widget.imageArr[0] == null
      //                   ? const SizedBox()
      //                   : Expanded(
      //                 child: GestureDetector(
      //                   onTap: (){
      //                     muddaGalleryDialog(
      //                         context,
      //                         widget.imageArr,
      //                         widget.basePath,
      //                         0
      //                     );
      //                   },
      //                   child: photoContainer(
      //                     SizeConfig.screenWidth,
      //                     SizeConfig.screenHeight ?? 100.0,
      //                     "${widget.mediaFor}${widget.imageArr[0].file!}",
      //                   ),
      //                 ),
      //               ),
      //               const SizedBox(width: 2),
      //               widget.imageArr[1] == null
      //                   ? const SizedBox()
      //                   : Expanded(
      //                 child: GestureDetector(
      //                   onTap: (){
      //                     muddaGalleryDialog(
      //                         context,
      //                         widget.imageArr,
      //                         widget.basePath,
      //                         1
      //                     );
      //                   },
      //                   child: photoContainer(
      //                     SizeConfig.screenWidth,
      //                     SizeConfig.screenHeight ?? 100.0,
      //                     "${widget.mediaFor}${widget.imageArr[1].file!}",
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //           const SizedBox(width: 2),
      //           Row(
      //             children: <Widget>[
      //               widget.imageArr[2] == null
      //                   ? const SizedBox()
      //                   : Expanded(
      //                 child: GestureDetector(
      //                   onTap: (){
      //                     muddaGalleryDialog(
      //                         context,
      //                         widget.imageArr,
      //                         widget.basePath,
      //                         2
      //                     );
      //                   },
      //                   child: photoContainer(
      //                     SizeConfig.screenWidth,
      //                     SizeConfig.screenHeight ?? 100.0,
      //                     "${widget.mediaFor}${widget.imageArr[3].file!}",
      //                   ),
      //                 ),
      //               ),
      //               const SizedBox(width: 2),
      //               widget.imageArr[3] == null
      //                   ? const SizedBox()
      //                   : Expanded(
      //                 child: GestureDetector(
      //                   onTap: (){
      //                     muddaGalleryDialog(
      //                         context,
      //                         widget.imageArr,
      //                         widget.basePath,
      //                         3
      //                     );
      //                   },
      //                   child: photoContainer(
      //                     SizeConfig.screenWidth,
      //                     SizeConfig.screenHeight ?? 100.0,
      //                     "${widget.mediaFor}${widget.imageArr[4].file!}",
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ],
      //       ),
      //     );
      //   }
      // case 5:
      //   {
      //     return SizedBox(
      //       width: SizeConfig.screenWidth,
      //       child: Column(
      //         children: <Widget>[
      //           Row(
      //             children: <Widget>[
      //               Expanded(
      //                 child: GestureDetector(
      //                   onTap: (){
      //                     muddaGalleryDialog(
      //                         context,
      //                         widget.imageArr,
      //                         widget.basePath,
      //                         0
      //                     );
      //                   },
      //                   child: photoContainer(
      //                     SizeConfig.screenWidth,
      //                     SizeConfig.screenHeight ?? 100.0,
      //                     "${widget.mediaFor}${widget.imageArr[0].file!}",
      //                   ),
      //                 ),
      //               ),
      //               const SizedBox(width: 2),
      //               Expanded(
      //                 child: GestureDetector(
      //                   onTap: (){
      //                     muddaGalleryDialog(
      //                         context,
      //                         widget.imageArr,
      //                         widget.basePath,
      //                         1
      //                     );
      //                   },
      //                   child: photoContainer(
      //                     SizeConfig.screenWidth,
      //                     SizeConfig.screenHeight ?? 100.0,
      //                     "${widget.mediaFor}${widget.imageArr[1].file!}",
      //                   ),
      //                 ),
      //               ),
      //               const SizedBox(width: 2),
      //               Expanded(
      //                 child: GestureDetector(
      //                   onTap: (){
      //                     muddaGalleryDialog(
      //                         context,
      //                         widget.imageArr,
      //                         widget.basePath,
      //                         2
      //                     );
      //                   },
      //                   child: photoContainer(
      //                     SizeConfig.screenWidth,
      //                     SizeConfig.screenHeight ?? 100.0,
      //                     "${widget.mediaFor}${widget.imageArr[2].file!}",
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //           const SizedBox(width: 2),
      //           Row(
      //             children: <Widget>[
      //               Expanded(
      //                 child: GestureDetector(
      //                   onTap: (){
      //                     muddaGalleryDialog(
      //                         context,
      //                         widget.imageArr,
      //                         widget.basePath,
      //                         3
      //                     );
      //                   },
      //                   child: photoContainer(
      //                     SizeConfig.screenWidth,
      //                     SizeConfig.screenHeight ?? 100.0,
      //                     "${widget.mediaFor}${widget.imageArr[3].file!}",
      //                   ),
      //                 ),
      //               ),
      //               const SizedBox(width: 2),
      //               Expanded(
      //                 child: GestureDetector(
      //                   onTap: (){
      //                     muddaGalleryDialog(
      //                         context,
      //                         widget.imageArr,
      //                         widget.basePath,
      //                         4
      //                     );
      //                   },
      //                   child: photoContainer(
      //                     SizeConfig.screenWidth,
      //                     SizeConfig.screenHeight ?? 100.0,
      //                     "${widget.mediaFor}${widget.imageArr[4].file!}",
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ],
      //       ),
      //     );
      //   }
      // case 6:
      //   {
      //     return SizedBox(
      //       width: SizeConfig.screenWidth,
      //       height: 100,
      //       child: Column(
      //         children: <Widget>[
      //           Row(
      //             children: <Widget>[
      //               Expanded(
      //                 child: GestureDetector(
      //                   onTap: (){
      //                     muddaGalleryDialog(
      //                         context,
      //                         widget.imageArr,
      //                         widget.basePath,
      //                         0
      //                     );
      //                   },
      //                   child: photoContainer(
      //                     SizeConfig.screenWidth,
      //                     SizeConfig.screenHeight ?? 100.0,
      //                     "${widget.mediaFor}${widget.imageArr[0].file!}",
      //                   ),
      //                 ),
      //               ),
      //               const SizedBox(width: 2),
      //               Expanded(
      //                 child: GestureDetector(
      //                   onTap: (){
      //                     muddaGalleryDialog(
      //                         context,
      //                         widget.imageArr,
      //                         widget.basePath,
      //                         1
      //                     );
      //                   },
      //                   child: photoContainer(
      //                     SizeConfig.screenWidth,
      //                     SizeConfig.screenHeight ?? 100.0,
      //                     "${widget.mediaFor}${widget.imageArr[1].file!}",
      //                   ),
      //                 ),
      //               ),
      //               const SizedBox(width: 2),
      //               Expanded(
      //                 child: GestureDetector(
      //                   onTap: (){
      //                     muddaGalleryDialog(
      //                         context,
      //                         widget.imageArr,
      //                         widget.basePath,
      //                         2
      //                     );
      //                   },
      //                   child: photoContainer(
      //                     SizeConfig.screenWidth,
      //                     SizeConfig.screenHeight ?? 100.0,
      //                     "${widget.mediaFor}${widget.imageArr[2].file!}",
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //           const SizedBox(width: 2),
      //           Row(
      //             children: <Widget>[
      //               Expanded(
      //                 child: GestureDetector(
      //                   onTap: (){
      //                     muddaGalleryDialog(
      //                         context,
      //                         widget.imageArr,
      //                         widget.basePath,
      //                         3
      //                     );
      //                   },
      //                   child: photoContainer(
      //                     SizeConfig.screenWidth,
      //                     SizeConfig.screenHeight ?? 100.0,
      //                     "${widget.mediaFor}${widget.imageArr[3].file!}",
      //                   ),
      //                 ),
      //               ),
      //               const SizedBox(width: 2),
      //               Expanded(
      //                 child: GestureDetector(
      //                   onTap: (){
      //                     muddaGalleryDialog(
      //                         context,
      //                         widget.imageArr,
      //                         widget.basePath,
      //                         4
      //                     );
      //                   },
      //                   child: photoContainer(
      //                     SizeConfig.screenWidth,
      //                     SizeConfig.screenHeight ?? 100.0,
      //                     "${widget.mediaFor}${widget.imageArr[4].file!}",
      //                   ),
      //                 ),
      //               ),
      //               const SizedBox(width: 2),
      //               Expanded(
      //                 child: GestureDetector(
      //                   onTap: (){
      //                     muddaGalleryDialog(
      //                         context,
      //                         widget.imageArr,
      //                         widget.basePath,
      //                         5
      //                     );
      //                   },
      //                   child: photoContainer(
      //                     SizeConfig.screenWidth,
      //                     SizeConfig.screenHeight ?? 100.0,
      //                     "${widget.mediaFor}${widget.imageArr[5].file!}",
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ],
      //       ),
      //     );
      //   }
      default:
        {
          return Container(
            height: Get.height * 0.17,
            width: SizeConfig.screenWidth,
            child: Row(
              children: [
                Expanded(
                  child: ListView.separated(
                     padding: const EdgeInsets.only(top: 4),
                      itemCount: widget.imageArr.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context,index){
                        return const SizedBox(width: 4);
                      },
                      itemBuilder: (context,int index){
                       String? video;
                       if( widget.imageArr[index].file.contains('.mp4')){
                         var fileToCompressPath = widget.imageArr[index].file;
                         final fileFormat = fileToCompressPath.substring(fileToCompressPath.lastIndexOf('.'));
                         video = "${fileToCompressPath.replaceAll(fileFormat, '')}-lg.png";
                       }
                      return GestureDetector(
                        onTap: (){
                          muddaGalleryDialog(
                              context,
                              widget.imageArr,
                              widget.basePath,
                              index
                          );
                        },
                        child: photoContainer(
                          video!=null?true: false,
                          SizeConfig.screenWidth,
                          SizeConfig.screenHeight ?? Get.height * 0.17,
                          "${widget.mediaFor}${video ?? widget.imageArr[index].file!}",
                        ),
                      );
                      }),
                )
              ],
            ),
          );
        }
    }
  }

  Widget photoContainer(
  bool isVideo,
      width,
      height,
      url, {
        mediaFor,
        duration,
      }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Stack(
        children: [
          CachedNetworkImage(
            width: width,
            height: height,
            imageUrl: url,
            fit: BoxFit.cover,
            errorWidget: (
                context,
                url,
                error,
                ) =>
                Container(
                  width: width,
                  height: height,
                  color: Colors.blue[100],
                ),
          ),
          if(isVideo)  Positioned(
            top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: white,
            ),
            child: Icon(Icons.play_arrow),
          ),
                ],
              ))
        ],
      ),
    );
  }
}