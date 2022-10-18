

import 'package:abzeno/Helper/app_link.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class DetailImageAttRequest extends StatefulWidget {
  final String ImgFile;
  const DetailImageAttRequest(this.ImgFile);
  @override
  _DetailImageAttRequest createState() => new _DetailImageAttRequest(
      getImgFile: this.ImgFile);
}



class _DetailImageAttRequest extends State<DetailImageAttRequest> {
  String getImgFile;
  _DetailImageAttRequest({required this.getImgFile});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
              tag: 'imagehero',
              child:
              PhotoView(
                imageProvider: NetworkImage(applink+"mobile/image/"+widget.ImgFile),
              )
          ),
        ),
        onTap: () {
         // Navigator.pop(context);
        },
      ),
    );
  }
}