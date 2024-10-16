import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:image/image.dart' as img;
import 'package:video_compress/video_compress.dart';
import '../../apis/APIs.dart';
import '../../apis/addPost.dart';
import '../../components/postComponents/groupExplorer.dart';
import '../../components/postComponents/standrdPost.dart';
import '../../themes/colors.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}
class _AddPageState extends State<AddPage> {
  List<AssetEntity> selectedMedia = [];
  AssetEntity? firstMedia;
  String? _selectedLocation;
  TextEditingController _postController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  bool _isToggled = false;

  @override
  void initState() {
    super.initState();
    addPost.requestPermissions();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          TextButton(
            onPressed: _handlePost,
            child: const Text(
              'Post',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: PrimaryColor,
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 45,
                    height: 45,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        imageUrl: Apis.me.image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                        const Center(child: CupertinoActivityIndicator()),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/png_jpeg_images/user.png'),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      CupertinoSwitch(
                        value: _isToggled,
                        onChanged: (bool value) {
                          setState(() {
                            _isToggled = value;
                          });
                        },
                      ),
                      const Text(
                        'Group Explorer',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ],
              ),
            ),
            // Show form or standard post based on toggle
            if (_isToggled) buildCreatePostForm(context,selectDate,endDate,startDate) else buildStanderdPost(context,selectedMedia,_postController,_pickMedia,_pickLocation),
          ],
        ),
      ),
    );
  }
  Future<void> _pickMedia() async {

    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: const AssetPickerConfig(
        maxAssets: 10, // Maximum number of media (photos/videos) to select
        requestType: RequestType.common,
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        selectedMedia = result;
        firstMedia = result.first;
      });
    }
  }

  Future<void> _pickLocation() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const LocationPickerBottomSheet();
      },
    );

    if (result != null) {
      setState(() {
        _selectedLocation = result;
      });
    }
  }

  Future<void> _handlePost() async {
    List<Map<String, dynamic>> compressedMedia = await _compressMedia();
    String postText = _postController.text.trim();

    await addPost.uploadPostToFirebase(
        postText, compressedMedia, _selectedLocation);

    Navigator.pushNamedAndRemoveUntil(context, '/explore', (route) => false);
  }

  Future<List<Map<String, dynamic>>> _compressMedia() async {
    List<Map<String, dynamic>> mediaFiles = [];

    for (var media in selectedMedia) {
      if (media.type == AssetType.image) {
        Uint8List? imageData = await media.originBytes;
        if (imageData != null) {
          Uint8List compressedImage =
          await _compressImage(imageData, 1024 * 1024);
          mediaFiles.add({'type': 'image', 'data': compressedImage});
        }
      } else if (media.type == AssetType.video) {
        final file = await media.file;
        if (file != null) {
          final MediaInfo? compressedVideo =
          await VideoCompress.compressVideo(file.path,
              quality: VideoQuality.MediumQuality, includeAudio: true);
          if (compressedVideo != null &&
              compressedVideo.filesize! <= 3 * 1024 * 1024) {
            mediaFiles.add({'type': 'video', 'file': compressedVideo.file});
          } else {
            print('Compressed video is larger than 3MB');
          }
        }
      }
    }

    return mediaFiles;
  }
  Future<void> selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }
  Future<Uint8List> _compressImage(Uint8List imageData, int maxSize) async {
    img.Image? image = img.decodeImage(imageData);
    if (image == null) return imageData;

    img.Image resizedImage = img.copyResize(image, width: 1024);
    return Uint8List.fromList(img.encodeJpg(resizedImage, quality: 80));
  }
}

class LocationPickerBottomSheet extends StatelessWidget {
  const LocationPickerBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Center(
        child: Column(
          children: [
            const Text('Pick a location'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, 'Selected Location');
              },
              child: const Text('Select'),
            ),
          ],
        ),
      ),
    );
  }
}
