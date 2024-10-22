import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '../../apis/APIs.dart';
import '../../apis/addPost.dart';
import '../../components/postComponents/groupExplorer.dart';
import '../../components/postComponents/standrdPost.dart';
import '../../themes/colors.dart';
import 'package:path_provider/path_provider.dart';

import 'explore.dart';



class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _travelersCountController = TextEditingController();
  List<Map<String, dynamic>> _savedDrafts = [];

  @override
  void initState() {
    super.initState();
    _requestStoragePermission();
    _loadDrafts(Apis.uid);
  }
  bool _isToggled = false;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedLocation;
  List<AssetEntity>  _selectedMedia = [];
  final ValueNotifier<double> _uploadProgress = ValueNotifier(0.0);
  bool _isUploading = false;
  bool _isDraftSaved = false;

  @override
  void dispose() {
    _postController.dispose();
    _destinationController.dispose();
    _budgetController.dispose();
    _travelersCountController.dispose();
    _uploadProgress.dispose();
    super.dispose();
  }
  void deleteDraftWrapper(Map<String, dynamic> draft) {
    _deleteDraft(draft, Apis.uid);
  }

  void _showDraftListDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Saved Drafts'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _savedDrafts.length,
            itemBuilder: (context, index) {
              final draft = _savedDrafts[index];
              final mediaFiles = draft['mediaFiles'] as List<File>;
              final mediaCount = mediaFiles.length;
              final displayCount = mediaCount > 4 ? 4 : mediaCount;

              return GestureDetector(
                onTap: (){
                  _handleDraftSelection(draft);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(draft['text'] ?? 'No content'),
                      subtitle: Text(draft['location'] ?? 'No location'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () =>  _deleteDraft(draft, Apis.uid),
                      ),
                    ),
                    if (mediaFiles.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 6,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 4,
                          ),
                          itemCount: displayCount,
                          itemBuilder: (context, i) {
                            return FutureBuilder<Uint8List?>(
                              future: mediaFiles[i].readAsBytes(), // Load the file data as Uint8List
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                                  return Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(100.0),
                                        child: Image.memory(snapshot.data!, fit: BoxFit.cover),
                                      ),
                                      if (i == 3 && mediaCount > 4)
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
                    const Divider(), // Add divider between drafts
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  void _handleDraftSelection(Map<String, dynamic> draft) {
    setState(() {
      _postController.text = draft['text'] ?? '';
      _selectedLocation = draft['location'];
      _selectedMedia = draft['mediaPaths']
          .map<File>((path) => File(path as String))
          .toList();
    });
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isUploading) return false;
        return _showSaveDraftDialog();
      },
      child: Scaffold(
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
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileRow(),
                  if (_isToggled)
                    buildCreatePostForm(context, _selectDate, _endDate, _startDate)
                  else
                    buildStandardPost(
                      context,
                      _selectedMedia,
                      _postController,
                      _pickAssets,
                      _pickLocation,
                      _savedDrafts,
                      deleteDraftWrapper,
                      _showDraftListDialog,
                    ),
                ],
              ),
            ),
            if (_isUploading) _buildCenteredProgressIndicator(), // Centered overlay progress indicator
          ],
        ),
      ),
    );
  }
// Save draft
  Future<bool> _saveDraft(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final appDir = await getApplicationDocumentsDirectory();
    List<String> mediaPaths = [];
    for (var media in _selectedMedia) {
      final mediaFile = await media.file;
      if (mediaFile != null) {
        final fileName = media.id + '.jpg'; // Using media ID as the filename
        final filePath = '${appDir.path}/$fileName';
        await mediaFile.copy(filePath);
        mediaPaths.add(filePath); // Store the path
      }
    }

    Map<String, dynamic> draft = {
      'uid': uid, // Add uid to identify user-specific drafts
      'text': _postController.text.trim(),
      'mediaPaths': mediaPaths,
      'location': _selectedLocation,
    };

    setState(() {
      _isDraftSaved = true;
      _savedDrafts.add(draft);
      _postController.clear();
      _selectedMedia.clear();
      _selectedLocation = null;
    });

    List<String> drafts = _savedDrafts.map((d) => json.encode(d)).toList();
    bool success = await prefs.setStringList('savedDrafts', drafts);
    return success;
  }
  Future<void> _loadDrafts(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? drafts = prefs.getStringList('savedDrafts');

    if (drafts != null) {
      setState(() {
        _savedDrafts = drafts.map((d) {
          final draft = json.decode(d) as Map<String, dynamic>;
          // Filter drafts by uid
          if (draft['uid'] != uid) return null;

          // Convert paths to File objects to use in the UI
          draft['mediaFiles'] = (draft['mediaPaths'] as List<dynamic>)
              .map((path) => File(path as String))
              .toList();

          return draft;
        }).whereType<Map<String, dynamic>>().toList(); // Remove null values
      });
    }
  }
  Future<void> _deleteDraft(Map<String, dynamic> draft, String uid) async {
    final prefs = await SharedPreferences.getInstance();

    // Check if the draft belongs to the current user
    if (draft['uid'] != uid) return;

    // Delete image files associated with the draft
    for (var path in draft['mediaPaths']) {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    }

    setState(() {
      _savedDrafts.remove(draft);
    });

    List<String> drafts = _savedDrafts.map((d) => json.encode(d)).toList();
    await prefs.setStringList('savedDrafts', drafts);
  }
  Future<bool> _showSaveDraftDialog() async {
    if (_postController.text.isEmpty && _selectedMedia.isEmpty) return true;
    bool saveAsDraft = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Draft'),
        content: const Text('Do you want to save this post as a draft?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Discard'),
          ),
          TextButton(
            onPressed: () async {
              bool saved = await _saveDraft(Apis.uid); // Await and check the save result
              Navigator.pop(context, saved);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ) ?? false;

    if (!saveAsDraft) {
      setState(() => _isDraftSaved = false);
    }
    return saveAsDraft;
  }

  Widget _buildProfileRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                placeholder: (context, url) => const Center(child: CupertinoActivityIndicator()),
                errorWidget: (context, url, error) => Image.asset('assets/png_jpeg_images/user.png'),
              ),
            ),
          ),
          Column(
            children: [
              CupertinoSwitch(
                value: _isToggled,
                onChanged: (bool value) {
                  setState(() => _isToggled = value);
                },
              ),
              const Text(
                'Group Explorer',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              )
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildCenteredProgressIndicator() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black54, // Semi-transparent background covering full screen
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ValueListenableBuilder<double>(
            valueListenable: _uploadProgress,
            builder: (context, progress, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      value: progress,
                      color: CupertinoColors.activeBlue, // Cupertino-style color
                      backgroundColor: Colors.white70,
                      strokeWidth: 3.0, // Adjust thickness for Cupertino look
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${(progress * 100).toStringAsFixed(0)}%", // Show progress percentage
                    style: const TextStyle(color: Colors.white,fontSize: 18.0),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
  Future<void> _handlePost() async {
    setState(() => _isUploading = true);
    _uploadProgress.value = 0.0;
    List<Map<String, dynamic>> compressedMedia = await _compressMedia();
    String postText = _postController.text.trim();
    await addPost.uploadPostToFirebase(
      postText,
      compressedMedia,
      _selectedLocation,
      onProgress: (progress) {
        _uploadProgress.value = progress;
      },
    );
    setState(() => _isUploading = false);
    _showSuccessDialog();
  }
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Post Successful'),
        content: const Text('Your post has been uploaded successfully!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => Explore()),(Route<dynamic> route) => false),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  Future<List<Map<String, dynamic>>> _compressMedia() async {
    List<Map<String, dynamic>> mediaFiles = [];
    for (var media in _selectedMedia) {
      if (media.type == AssetType.image) {
        Uint8List? imageData = await media.originBytes;
        if (imageData != null) {
          Uint8List compressedImage = await _compressImage(imageData, 1024 * 1024);
          mediaFiles.add({'type': 'image', 'data': compressedImage});
        }
      }
    }
    return mediaFiles;
  }
  Future<Uint8List> _compressImage(Uint8List imageData, int maxSize) async {
    img.Image? image = img.decodeImage(imageData);
    if (image == null) return imageData;
    img.Image resizedImage = img.copyResize(image, width: 1024);
    return Uint8List.fromList(img.encodeJpg(resizedImage, quality: 80));
  }
  Future<List<AssetEntity>?> _pickAssets() async {
    try {
      final List<AssetEntity>? result = await AssetPicker.pickAssets(
        context,
        pickerConfig: const AssetPickerConfig(
          requestType: RequestType.image, // Only images allowed
          maxAssets: 5,
        ),
      );
      if (result != null) {
        setState(() {
          _selectedMedia = result;
        });
      }
      return result;
    } catch (e) {
      print("Error picking media: $e");
      return null;
    }
  }
  Future<void> _pickLocation() async {
    await Permission.location.request();
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _selectedLocation = '${position.latitude}, ${position.longitude}';
    });
  }
  Future<void> _requestStoragePermission() async {
    await Permission.storage.request();
  }
  Future<void> _selectDate(BuildContext context, bool isStart) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStart) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }
}
