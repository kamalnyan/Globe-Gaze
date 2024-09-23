import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globegaze/themes/colors.dart';
import '../../locationservices/current location.dart';
import '../../themes/dark_light_switch.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  String _location = "Fetching location...";
  @override
  void initState() {
    super.initState();
    _getLocation();
  }
  void _getLocation() async {
    String location = await getCurrentLocation();
    setState(() {
      _location = location; // Update the UI when location is fetched
    });
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(CupertinoIcons.location,size: 20,color: PrimaryColor,),
                      SizedBox(width: 1,),
                      Text(_location,style: TextStyle(fontSize: 15),),
                    ],
                  ),
                  SizedBox(height: 10,),
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
                    'Popular Destinations',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        DestinationCard(
                          image: 'assets/capadocia.jpg',
                          title: 'Capadocia',
                          location: 'Turkey',
                        ),
                        SizedBox(width: 16),
                        DestinationCard(
                          image: 'assets/snowland.jpg',
                          title: 'Snowland',
                          location: 'Cibadak',
                        ),
                        // Add more cards as needed
                      ],
                    ),
                  ),
                  SizedBox(height: 24),

                  // Stories Section
                  Text(
                    'Stories',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
              ),
            ),// upeer section
            // Feed section
            SizedBox(height: 10),
            // List of feed posts
            PostCard(
              avatar: 'assets/user1.jpg',
              username: 'Jack robo',
              timeAgo: '15 min ago',
              image: 'assets/post_image.jpg',
              likesCount: 31,
              likedUsers: ['assets/user2.jpg', 'assets/user3.jpg', 'assets/user4.jpg'],
              description: "If you've ever grabbed a pack of retrosupply brushes...",
            ),
            SizedBox(height: 16),
            PostCard(
              avatar: 'assets/user2.jpg',
              username: 'Maya Adams',
              timeAgo: '20 min ago',
              image: 'assets/post_image2.jpg',
              likesCount: 45,
              likedUsers: ['assets/user1.jpg', 'assets/user3.jpg', 'assets/user5.jpg'],
              description: "Exploring the beauty of nature...",
            ),
            // Add more PostCards as needed
          ],
        ),
      ),
    );
  }
}

// PostCard widget representing each feed post
class PostCard extends StatelessWidget {
  final String avatar;
  final String username;
  final String timeAgo;
  final String image;
  final int likesCount;
  final List<String> likedUsers;
  final String description;

  const PostCard({
    Key? key,
    required this.avatar,
    required this.username,
    required this.timeAgo,
    required this.image,
    required this.likesCount,
    required this.likedUsers,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header (avatar, username, and time)
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(avatar),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(timeAgo, style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Spacer(),
                IconButton(
                  onPressed: () {  },
                  icon: Icon(Icons.more_vert),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Post image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                image,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 12),

            // Likes and liked users avatars
            Row(
              children: [
                IconButton(
                  onPressed: () {

                  },
                  icon:Icon(Icons.favorite_border, color: Colors.red),
                ),
                SizedBox(width: 8),
                Text('$likesCount likes'),
                SizedBox(width: 8),
                Row(
                  children: likedUsers.map((userAvatar) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: CircleAvatar(
                      radius: 12,
                      backgroundImage: AssetImage(userAvatar),
                    ),
                  )).toList(),
                ),
              ],
            ),
            SizedBox(height: 12),
            // Description
            Text(description, maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
// Reusable widget for destination cards
class DestinationCard extends StatelessWidget {
  final String image;
  final String title;
  final String location;

  const DestinationCard({
    Key? key,
    required this.image,
    required this.title,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              image,
              height: 120,
              width: 200,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            location,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
// Reusable widget for story circles
class StoryCircle extends StatelessWidget {
  final String? image;
  final String userName;
  final bool isAddStory;

  const StoryCircle({
    Key? key,
    this.image,
    required this.userName,
    this.isAddStory = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {

          },
          child: CircleAvatar(
            radius: 32,
            backgroundColor: isAddStory ? Colors.blue : Colors.grey.shade300,
            child: isAddStory
                ? Icon(Icons.add, color: Colors.white, size: 32)
                : ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Image.asset(
                image ?? 'assets/default_user.png',
                height: 64,
                width: 64,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          userName,
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
