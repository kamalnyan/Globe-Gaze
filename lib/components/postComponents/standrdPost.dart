import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:photo_manager/src/types/entity.dart';
Widget buildStandardPost(
    BuildContext context,
    List<AssetEntity> selectedMedia,
    TextEditingController _postController,
    Function _pickMedia,
    Function _pickLocation,
    List<Map<String, dynamic>> savedDrafts,
    Function(Map<String, dynamic>) deleteDraft, void Function() showDraftListDialog,
    ) {
  int mediaCount = selectedMedia.length;
  int displayCount = mediaCount > 4 ? 4 : mediaCount;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _postController,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            hintText: "How was your experience?",
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
              onPressed: () => _pickMedia(),
              icon: const Column(
                children: [
                  Icon(CupertinoIcons.photo),
                  SizedBox(height: 5),
                  Text('Gallery'),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _pickLocation(),
              icon: const Column(
                children: [
                  Icon(CupertinoIcons.location),
                  SizedBox(height: 5),
                  Text('Location'),
                ],
              ),
            ),
            IconButton(
              onPressed: () => showDraftListDialog(),
              icon: const Column(
                children: [
                  Icon(CupertinoIcons.collections),
                  SizedBox(height: 5),
                  Text('Saved drafts'),
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
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.memory(snapshot.data!, fit: BoxFit.cover),
                        ),
                        if (index == 3 && mediaCount > 4)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              decoration: const BoxDecoration(
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
                  return const CupertinoActivityIndicator(radius: 15.0);
                },
              );
            },
          ),
        ),
    ],
  );
}