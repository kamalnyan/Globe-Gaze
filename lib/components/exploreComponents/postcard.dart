import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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