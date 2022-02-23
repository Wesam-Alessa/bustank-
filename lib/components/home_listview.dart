
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

class HomeList extends StatelessWidget {
  const HomeList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding:const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
        scrollDirection: Axis.vertical,

      children: const <Widget>[
        Category(
          imageCaption: 'Seeds',
          imageLocation:'https://images.unsplash.com/photo-1472141521881-95d0e87e2e39?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjB8fHNlZWRzfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60',
          //'image/categoriesLogo/seeds.jpg',
          nameScreen: SeedsScreen(),
        ),
        Category(
          imageCaption: 'Trees',
          imageLocation:'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZikMjDEqVLCZVCJF_UVDIsLTEACBJZr-Ynw&usqp=CAU',
          //'image/categoriesLogo/trees.jpg',
          nameScreen:TreesScreen(),
        ),
        Category(
          imageCaption: 'Farm Tools',
          imageLocation: 'https://media.istockphoto.com/photos/working-garden-tool-picture-id152119207?k=20&m=152119207&s=612x612&w=0&h=SQSQ60w2gS4y_PdBv6MoPl8JHKBTdaURYrtLAS4lsOs=',
          //'image/categoriesLogo/farm tools.jpg',
          nameScreen:FarmToolsScreen(),
        ),
        Category(
          imageCaption: 'Garden Tools',
          imageLocation: 'https://cdn.shopify.com/s/files/1/0052/9910/9923/collections/1111111111111111111111111111111111111111111111_e83f1a83-9ee4-4ac6-aef2-c18cea175b61_1400x.jpg?v=1628327230',
          //'image/categoriesLogo/garden_tools.jpg',
          nameScreen:GardenToolsScreen(),
        ),
        Category(
          imageCaption: 'Land for Rent',
          imageLocation:'https://media.istockphoto.com/photos/aerial-view-of-green-field-position-point-and-boundary-line-to-show-picture-id1288691917?b=1&k=20&m=1288691917&s=170667a&w=0&h=c-AR8ioLNL6qtGd2iIkJA01Dc6Y4mMPdoWiuya1OL3E=',
          //'image/categoriesLogo/land.jpg',
          nameScreen:LandForRentScreen(),
        ),
        Category(
          imageCaption: 'Insecticide',
          imageLocation: 'https://media.istockphoto.com/photos/application-of-watersoluble-fertilizers-pesticides-or-herbicides-in-picture-id1329309807?b=1&k=20&m=1329309807&s=170667a&w=0&h=q4BwSxDSbQV5okLQMzlmjt6dmniP6pkUE9BqgdjrJJQ=',
          //'image/categoriesLogo/insecticide.png',
          nameScreen:InsecticideScreen(),
        ),
        Category(
          imageCaption: 'Designs',
          imageLocation: 'https://media.istockphoto.com/photos/new-turf-grass-installation-picture-id954030664?k=20&m=954030664&s=612x612&w=0&h=ss4gYpzxd6_dAYXz2jAVaOTmhAN3_tDYvMKs27gjQ50=',
          //'image/categoriesLogo/agriculture-designs.jpg',
            nameScreen:AgricultureDesignsScreen(),
        ),
        Category(
          imageCaption: 'Workers',
          imageLocation: 'https://media.istockphoto.com/photos/autumn-harvest-picture-id1097842636?k=20&m=1097842636&s=612x612&w=0&h=lKiBCqJtVJnAuILIs8y3-cZlAzYCdb_W0gAQON5PO74=',
          //'image/categoriesLogo/workers.jpg',
          nameScreen:AgricultureWorkersScreen(),
        ),
      ],
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
    return
      GestureDetector(
        onTap: (){
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => nameScreen));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius:const BorderRadius.all(Radius.circular(10)),
            image: DecorationImage(
              image:  NetworkImage(
                imageLocation,
              ),
              fit: BoxFit.fill
            )
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              imageCaption,
              style:const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                //backgroundColor: Colors.grey[100]
              ),
            ),
          ),
        ),
      );
  }
}
