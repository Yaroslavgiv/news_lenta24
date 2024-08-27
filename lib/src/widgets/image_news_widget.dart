import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageNewsWidget extends StatelessWidget {
  final String urlImage;
  final double height;
  final double width;
  final double borderRadius;

  const ImageNewsWidget({
    Key? key,
    required this.urlImage,
    this.height = 50,
    this.width = 80,
    this.borderRadius = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: CachedNetworkImage(
          imageUrl: urlImage,
          height: height,
          width: width,
          alignment: Alignment.center,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            height: height,
            width: width,
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            height: height,
            width: width,
            color: Colors.grey[200],
            child: Image.asset(
              'assets/no_image.png',
              fit: BoxFit.cover,
            ),
          ),
          fadeInDuration: const Duration(milliseconds: 500),
          fadeOutDuration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }
}
