import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/utils/constant_string.dart';
import '../../../../core/utils/text_style.dart';

class MessageContainBox extends StatelessWidget {
  final bool isSend;
  final String message;
  final String imgUrl;
  final String userName;
  const MessageContainBox({
    Key? key,
    required this.isSend,
    required this.message,
    required this.imgUrl,
    required this.userName
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: isSend ? MainAxisAlignment.start:MainAxisAlignment.end,
      children: [
        recieveMessage(),
        sendMessage(),

      ],
    );
  }
  Widget sendMessage(){
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(message),
            ),
            // Row(
            //   children: [
            //     const Spacer(),
            //     Text("23.45",
            //         style: size14_M_normal(textColor: colorGrey)),
            //     const SizedBox(
            //       width: 10,
            //     )
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
  Widget recieveMessage(){
    return Row(
      children: [
        imgUrl !="null" ? CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(imgUrl),
        ): CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: Text(
            userName.substring(0, 1)
                .toUpperCase(),
            style: GoogleFonts.nunitoSans(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(message),
                ),
                // Row(
                //   children: [
                //     const Spacer(),
                //     Text("23.45",
                //         style: size14_M_normal(textColor: colorGrey)),
                //     const SizedBox(
                //       width: 10,
                //     )
                //   ],
                // ),
              ],
            ),
          ),
        )
      ],
    );
  }
}