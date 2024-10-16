import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:photo_manager/src/types/entity.dart';
Widget buildStanderdPost(BuildContext context, List<AssetEntity> selectedMedia, TextEditingController _postController, Future<void> Function() _pickMedia, Future<void> Function() _pickLocation) {
  int mediaCount = selectedMedia.length;
  int displayCount = mediaCount > 4 ? 4 : mediaCount;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _postController,
          maxLines: null, // Make the text field expandable as the user types
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            hintText: "How was your exprieance ?",
            border: InputBorder.none,
          ),
        ),
      ),

      // Gallery and Location buttons below the text field
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: _pickMedia,
              icon: const Column(
                children: [
                  Icon(CupertinoIcons.photo),
                  SizedBox(height: 5),
                  Text('Gallery'),
                ],
              ),
            ),
            IconButton(
              onPressed: _pickLocation,
              icon: const Column(
                children: [
                  Icon(CupertinoIcons.location),
                  SizedBox(height: 5),
                  Text('Location'),
                ],
              ),
            ),
          ],
        ),
      ),

      // Display selected media in grid view
      if (selectedMedia.isNotEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: displayCount,
            itemBuilder: (context, index) {
              return FutureBuilder<Uint8List?>(
                future: selectedMedia[index].thumbnailData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0), // Adjust the radius as per your need
                          child: Image.memory(snapshot.data!, fit: BoxFit.cover),
                        ),
                        if (index == 3 && mediaCount > 4) // More items indicator on the 4th item
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0), // Match the border radius for consistency
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                              ),
                              child: Center(
                                child: Text(
                                  '+${mediaCount - 4}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  }
                  return const CircularProgressIndicator();
                },
              );
            },
          ),
        ),
    ],
  );
}
