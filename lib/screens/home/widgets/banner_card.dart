import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:arank_india/screens/practice/practice_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';




class BannerCard extends StatelessWidget {
  const BannerCard({super.key});

  Color hexToColor(String color) {
    switch (color.toLowerCase()) {
      case "red":
        return Colors.red;

      case "blue":
        return Colors.blue;

      case "green":
        return Colors.green;

      case "yellow":
        return Colors.yellow;

      case "orange":
        return Colors.orange;

      case "purple":
        return Colors.purple;

      case "pink":
        return Colors.pink;

      case "brown":
        return Colors.brown;

      case "grey":
        return Colors.grey;

      case "gray":
        return Colors.grey;

      case "black":
        return Colors.black;

      case "white":
        return Colors.white;

      case "cyan":
        return Colors.cyan;

      case "teal":
        return Colors.teal;

      case "lime":
        return Colors.lime;

      case "indigo":
        return Colors.indigo;

      case "amber":
        return Colors.amber;

      case "deeporange":
        return Colors.deepOrange;

      case "deeppurple":
        return Colors.deepPurple;

      case "lightblue":
        return Colors.lightBlue;

      case "lightgreen":
        return Colors.lightGreen;

      case "bluegrey":
        return Colors.blueGrey;
    }

    color = color.replaceAll("#", "");

    if (color.length == 6) {
      color = "FF$color";
    }

    return Color(int.parse(color, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
        .collection("home_banners")
        .snapshots(),
      builder: (context, snapshot) {

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox();
        }

        final banners = snapshot.data!.docs;

        return CarouselSlider.builder(
          itemCount: banners.length,
          options: CarouselOptions(
            height: 210,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            enlargeCenterPage: true,
            viewportFraction: 1.0,
          ),
          itemBuilder: (context, index, realIndex) {
            final data = banners[index].data() as Map<String, dynamic>;

            return Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    hexToColor(data["backgroundColor"]),
                    hexToColor(data["backgroundColor"]).withOpacity(.75),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data["title"] ?? "",
                    style: TextStyle(
                      color: hexToColor(data["textColor"]),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    data["subtitle"] ?? "",
                    style: TextStyle(
                      color: hexToColor(data["textColor"]).withOpacity(.8),
                      fontSize: 16,
                    ),
                  ),

                  const Spacer(),

                  ElevatedButton(
                    onPressed: () async {
                      final action = data["buttonAction"] ?? "";
                      final url = data["openUrl"] ?? "";

                      switch (action) {
                        case "practice":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PracticeScreen(),
                            ),
                          );
                          break;

                        case "website":
                          if (url.isNotEmpty) {
                            await launchUrl(
                              Uri.parse(url),
                              mode: LaunchMode.externalApplication,
                            );
                          }
                          break;
                      }
                    },
                    child: Text(data["buttonText"] ?? "Start"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}