import 'package:flutter/material.dart';

class FullImageScreen extends StatelessWidget {
  final List images;

  const FullImageScreen({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView.builder(
        itemCount: images.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    //fit: BoxFit.cover,
                    image: NetworkImage(images[index]),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left:MediaQuery.of(context).size.width * 0.475 ,
                child: Text(
                  '${index+1}/${images.length}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
