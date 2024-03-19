import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:fabyatra/utils/constant/dimensions.dart';
import 'package:fabyatra/utils/services/global.dart';

class Images extends StatefulWidget {
  const Images({super.key, required this.imageMap});

  final Map imageMap;

  @override
  _ImagesState createState() => _ImagesState();
}

class _ImagesState extends State<Images> {
  DatabaseReference ref =
  FirebaseDatabase.instance.ref().child("${GlobalVariable.appType}/project-backend").child("vehicle");

  List busData = [];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    double widthP = Dimensions.myWidthThis(context);
    double heightP = Dimensions.myHeightThis(context);
    double heightF = Dimensions.myHeightFThis(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Image Gallery'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 60),
        height: 508.0*heightF, // Adjust the height according to your design
        child: Column(
          children: [
            CarouselSlider(
              items: [
                for (Map value  in widget.imageMap.values)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ZoomableImage(
                            imageProvider: NetworkImage(value["url"]),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 411.42 * widthP,
                      height: 870.57 * heightP,
                      margin: EdgeInsets.only(right: 20.0 * widthP),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: NetworkImage(value["url"]),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
              ],
              options: CarouselOptions(
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                height: 500.0 * heightF,
                enlargeCenterPage: true,
                autoPlay: false,
                aspectRatio: 16 / 2,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 200),
                viewportFraction: 0.9,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i <  widget.imageMap.length; i++)
                  Row(
                    children: [
                      Container(
                        height: 8 * heightF,
                        width: 10 * widthP,
                        decoration: BoxDecoration(
                          color: currentIndex == i
                              ? const Color(0xff7d2aff)
                              : Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              spreadRadius: .5,
                              blurRadius: 1,
                              offset: Offset(2, 2),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 5 * widthP,
                      )
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ZoomableImage extends StatelessWidget {
  final ImageProvider imageProvider;

  const ZoomableImage({required this.imageProvider});

  @override
  Widget build(BuildContext context) {
    double widthP = Dimensions.myWidthThis(context);
    double heightP = Dimensions.myHeightThis(context);
    double heightF = Dimensions.myHeightFThis(context);
    return Scaffold(
      body: Center(
        child: PhotoView(
          imageProvider: imageProvider,
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
          backgroundDecoration: BoxDecoration(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
