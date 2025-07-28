import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../Resources/AppColors.dart';
import 'appbar_widget.dart';

class PhotoViewInApp extends StatefulWidget {
  List? galleryItems;
  int? currentIndex;

  PhotoViewInApp({
    super.key,
    required this.galleryItems,
    required this.currentIndex,
  });

  @override
  State<PhotoViewInApp> createState() => _PhotoViewInAppState();
}

class _PhotoViewInAppState extends State<PhotoViewInApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        "Images",
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        context,
      ),
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: CachedNetworkImageProvider(
              widget.galleryItems?[index],
              errorListener: (e) => const Icon(Icons.error),
            ),
            initialScale: PhotoViewComputedScale.contained * 0.9,
            heroAttributes: PhotoViewHeroAttributes(tag: index + 1),
          );
        },
        itemCount: widget.galleryItems?.length,
        loadingBuilder:
            (context, event) => Center(
              child: SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(color: AppColors.orangeColor),
              ),
            ),
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
        ),
        pageController: PageController(initialPage: widget.currentIndex ?? 0),
        onPageChanged: (index) {
          setState(() {
            widget.currentIndex = index;
          });
        },
      ),
    );
  }
}
