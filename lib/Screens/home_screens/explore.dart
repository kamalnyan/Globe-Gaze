import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globegaze/themes/colors.dart';
import '../../apis/datamodel.dart';
import '../../components/exploreComponents/postcard.dart';
import '../../components/exploreComponents/storycircles.dart';
import '../../components/exploreComponents/suggestion.dart';
import '../../locationservices/current location.dart';
import '../../themes/dark_light_switch.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});
  @override
  State<Explore> createState() => _ExploreState();
}
class _ExploreState extends State<Explore> {
  List<dynamic> places = []; // List to hold the places data
  bool isLoading = false;
  String _location = "Fetching location...";
  late PageController _pageController;
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    _getLocation();
    fetchPlaces();
    _pageController = PageController(viewportFraction: 0.8); // Adjust viewportFraction as needed
    Timer.periodic(Duration(seconds: 10), (Timer timer) {
      if (_currentPage < places.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
      );
    });
  }

  void _getLocation() async {
    String location = await getCurrentLocation();
    setState(() {
      _location = location;
    });
  }

  Future<void> fetchPlaces() async {
    setState(() {
      isLoading = true;
    });

    try {
      double lonMin = 77.0;
      double latMin = 31.0;
      double lonMax = 77.2;
      double latMax = 31.2;

      // Fetch places and update state
      List<dynamic> fetchedPlaces =
          await PlaceService().fetchPlaces(lonMin, latMin, lonMax, latMax);
      setState(() {
        places = fetchedPlaces;
      });
    } catch (e) {
      print('Error fetching places: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(CupertinoIcons.location,
                              size: 20, color: PrimaryColor),
                          SizedBox(width: 8),
                          Text(_location, style: TextStyle(fontSize: 15)),
                        ],
                      ),
                      SizedBox(height: 10),
                      // Search bar
                      SizedBox(
                        height: 45,
                        child: CupertinoSearchTextField(
                          enableIMEPersonalizedLearning: true,
                          style: TextStyle(
                            color: LightDark(isDarkMode),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Popular Destinations
                      Text(
                        'Suggestions',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
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

                      if (name.isNotEmpty &&
                          latitude != null &&
                          longitude != null &&
                          rate > 0 &&
                          categories.isNotEmpty) {
                        return FutureBuilder<Map<String, String>>(
                          future: actualLocation(latitude, longitude),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return SizedBox.shrink();
                            } else if (snapshot.hasData) {
                              Map<String, String> locationDetails =
                                  snapshot.data!;
                              return DestinationCard(
                                name: name,
                                localty: locationDetails['locality'] ??
                                    'Unknown locality',
                                Country: locationDetails['country'] ??
                                    'Unknown country',
                                rate: rate,
                                categories: categories,
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          },
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                ),
                SizedBox(height: 24),

                // Stories Section
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    'Stories',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [

                      StoryCircle(
                        isAddStory: true,
                        userName: "Add Story",
                      ),
                      SizedBox(width: 16),
                      StoryCircle(
                        image: 'assets/user1.jpg',
                        userName: "Alice",
                      ),
                      SizedBox(width: 16),
                      StoryCircle(
                        image: 'assets/user2.jpg',
                        userName: "Bob",
                      ),
                      SizedBox(width: 16),
                      StoryCircle(
                        image: 'assets/user3.jpg',
                        userName: "Charlie",
                      ),
                      SizedBox(width: 16),
                      StoryCircle(
                        image: 'assets/user4.jpg',
                        userName: "Diana",
                      ),
                      // Add more users as needed
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Feed',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ), // upper section
            SizedBox(height: 10),

            // Feed section
            PostCard(
              avatar: 'assets/user1.jpg',
              username: 'Jack robo',
              timeAgo: '15 min ago',
              image: 'assets/post_image.jpg',
              likesCount: 31,
              likedUsers: [
                'assets/user2.jpg',
                'assets/user3.jpg',
                'assets/user4.jpg'
              ],
              description:
                  "If you've ever grabbed a pack of retrosupply brushes...",
            ),
            SizedBox(height: 16),
            PostCard(
              avatar: 'assets/user2.jpg',
              username: 'Maya Adams',
              timeAgo: '20 min ago',
              image: 'assets/post_image2.jpg',
              likesCount: 45,
              likedUsers: [
                'assets/user1.jpg',
                'assets/user3.jpg',
                'assets/user5.jpg'
              ],
              description: "Exploring the beauty of nature...",
            ),
          ],
        ),
      ),
    );
  }
}