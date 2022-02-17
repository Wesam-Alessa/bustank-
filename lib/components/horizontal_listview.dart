
import 'package:bustank/categories_screens/agriculture_designs_screen.dart';
import 'package:bustank/categories_screens/agriculture_workers_screen.dart';
import 'package:bustank/categories_screens/farm_tools_screen.dart';
import 'package:bustank/categories_screens/garden_tools_screen.dart';
import 'package:bustank/categories_screens/insecticide_screen.dart';
import 'package:bustank/categories_screens/land_for_rent_screen.dart';
import 'package:bustank/categories_screens/seed_screen.dart';
import 'package:bustank/categories_screens/trees_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HorizontalList extends StatelessWidget {
  const HorizontalList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const <Widget>[
          Category(
            imageCaption: 'Seeds',
            imageLocation: 'image/categoriesLogo/seeds.jpg',
            nameScreen: SeedsScreen(),
          ),
          Category(
            imageCaption: 'Trees',
            imageLocation: 'image/categoriesLogo/trees.jpg',
            nameScreen:TreesScreen(),
          ),
          Category(
            imageCaption: 'Farm Tools',
            imageLocation: 'image/categoriesLogo/farm tools.jpg',
            nameScreen:FarmToolsScreen(),
          ),
          Category(
            imageCaption: 'Garden Tools',
            imageLocation: 'image/categoriesLogo/garden_tools.jpg',
            nameScreen:GardenToolsScreen(),
          ),
          Category(
            imageCaption: 'Land for Rent',
            imageLocation: 'image/categoriesLogo/land.jpg',
            nameScreen:LandForRentScreen(),
          ),
          Category(
            imageCaption: 'Insecticide',
            imageLocation: 'image/categoriesLogo/insecticide.png',
              nameScreen:InsecticideScreen(),
          ),
          Category(
            imageCaption: 'Agriculture Designs',
            imageLocation: 'image/categoriesLogo/agriculture-designs.jpg',
              nameScreen:AgricultureDesignsScreen(),
          ),
          Category(
            imageCaption: 'Agriculture Workers',
            imageLocation: 'image/categoriesLogo/workers.jpg',
            nameScreen:AgricultureWorkersScreen(),
          ),
        ],
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String imageLocation;
  final String imageCaption;
  final Widget nameScreen;
  const Category({Key? key, required this.imageLocation, required this.imageCaption,required this.nameScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => nameScreen));
        },
        child: SizedBox(
          width: 118.0,
          child: ListTile(
            title: Image.asset(
              imageLocation,
              height: 60.0,
              width: 100.0,
            ),
            subtitle: Container(
              alignment: Alignment.topCenter,
              child: Text(
                imageCaption,
                style:const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
