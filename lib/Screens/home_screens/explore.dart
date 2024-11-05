import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globegaze/themes/colors.dart';
import 'package:shimmer/shimmer.dart';
import '../../apis/addPost.dart';
import '../../apis/datamodel.dart';
import '../../components/exploreComponents/postcard.dart';
import '../../components/exploreComponents/suggestion.dart';
import '../../components/postComponents/locationBottomSheet.dart';
import '../../locationservices/locationForSUGGESATION.dart';
import '../../themes/dark_light_switch.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);
  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  List<dynamic> places = [];
  bool isLoading = true;
  String _location = "Fetching location...";
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _pageTimer;

  @override
  void initState() {
    super.initState();
    fetchPlaces();
    _pageController = PageController(viewportFraction: 0.8);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageTimer = Timer.periodic(const Duration(seconds: 10), (Timer timer) {
        if (_currentPage < places.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        if (places.isNotEmpty) {
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
          );
        }
      });
    });
  }

  Future<void> _getLocation() async {
    Map<String, String>? location = await fetchLocation();
    if (mounted) {
      setState(() {
        if (location != null) {
          _location = "${location['locality']}, ${location['country']}";
        } else {
          _location = "Location not available";
        }
      });
    }
  }
  Future<void> fetchPlaces() async {
    setState(() => isLoading = true);
    Map<String, double>? currentloc = await getLocationBounds();
    try {
      double? lonMin = currentloc?['lonMin'];
      double? latMin = currentloc?['latMin'];
      double? lonMax = currentloc?['lonMax'];
      double? latMax = currentloc?['latMax'];
      List<dynamic> fetchedPlaces =
      await PlaceService().fetchPlaces(lonMin!, latMin!, lonMax!, latMax!);
      if (mounted) {
        setState(() {
          places = fetchedPlaces;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
      print('Error fetching places: $e');
    } finally {
      _getLocation();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pageTimer?.cancel();
    super.dispose();
  }

  Widget buildShimmerPost() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 10),
            Container(
              width: 150,
              height: 20,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 5),
            Container(
              width: 100,
              height: 20,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
  Widget buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 290,
        height: 110,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 100,
                  height: 20,
                  color: Colors.grey[300],
                ),
                Row(
                  children: List.generate(5, (index) {
                    return Container(
                      width: 15,
                      height: 15,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      color: Colors.grey[300],
                    );
                  }),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 60,
                  height: 20,
                  color: Colors.grey[300],
                ),
                Container(
                  width: 60,
                  height: 20,
                  color: Colors.grey[300],
                ),
              ],
            ),
            Container(
              width: 120,
              height: 20,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
  Widget buildPlaceCards() {
    return places.isNotEmpty
        ? SizedBox(
      height: 210,
      child: PageView.builder(
        controller: _pageController,
        itemCount: places.length,
        itemBuilder: (context, index) {
          var place = places[index];
          String name = place['properties']['name'] ?? 'Unknown';
          double longitude = place['geometry']['coordinates'][0];
          double latitude = place['geometry']['coordinates'][1];
          int rate = place['properties']['rate'] ?? 0;
          String categories = place['properties']['kinds'] ?? '';
          if (name.isNotEmpty && latitude != null && longitude != null && rate > 0 && categories.isNotEmpty) {
            return FutureBuilder<Map<String, String>?>(
              future: getLocationDetails(latitude, longitude),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return buildShimmerCard();
                } else if (snapshot.hasError) {
                  return const SizedBox.shrink();
                } else if (snapshot.hasData) {
                  Map<String, String> locationDetails = snapshot.data!;
                  return DestinationCard(
                    name: name,
                    localty: locationDetails['locality'] ?? 'Unknown locality',
                    Country: locationDetails['country'] ?? 'Unknown country',
                    rate: rate,
                    categories: categories,
                    latitude: latitude,
                    longitude: longitude,
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    )
        : const Center(child: Text('No places to show'));
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: darkLight(isDarkMode),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(CupertinoIcons.location, size: 20, color: PrimaryColor),
                          const SizedBox(width: 8),
                          Text(_location, style: const TextStyle(fontSize: 15)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 45,
                        child: CupertinoSearchTextField(
                          enableIMEPersonalizedLearning: true,
                          style: TextStyle(color: LightDark(isDarkMode)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text('Suggestions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                isLoading ? buildShimmerCard() : buildPlaceCards(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Posts', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: addPost.fetchCommanPosts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return buildShimmerPost();
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No posts available'));
                }
                final posts = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final postData = posts[index];
                    return FutureBuilder<Widget>(
                      future: PostCard(context, postData),
                      builder: (context, postSnapshot) {
                        if (postSnapshot.connectionState == ConnectionState.waiting) {
                          return buildShimmerPost();
                        }
                        if (postSnapshot.hasError) {
                          return const Center(child: Text('Error loading post'));
                        }
                        return postSnapshot.data ?? const SizedBox.shrink();
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
