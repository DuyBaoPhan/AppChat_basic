

import 'package:flutter/material.dart';

import '../../submodules/chat/chat_screen.dart';
class ProfileBanner extends StatelessWidget {
  final Image imageBanner;
  final Image imageAvatar;
  final String identifier;
  final int followingQuantity; // số người mà người dùng theo dõi
  final int followersQuantity;  // số người đã theo dõi hồ sơ này
  final bool isFollowing;
  final VoidCallback followButtonFunction;
  const ProfileBanner({
    Key? key,
    required this.imageBanner,
    required this.imageAvatar,
    required this.identifier,
    required this.followingQuantity,
    required this.followersQuantity,
    required this.isFollowing,
    required this.followButtonFunction,
  }) : super(key: key);

  final int coverHeight = 250;  // vị trí Avatar được đặt
  final int radiusAvatar = 75;  // bán kính vòng tròn của Avatar

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: radiusAvatar.toDouble()),
              width: MediaQuery.sizeOf(context).width,
              height: coverHeight.toDouble(),
              child: imageBanner,
            ),
            Positioned(
              top: (coverHeight - radiusAvatar).toDouble(),
              child: CircleAvatar(
                radius: radiusAvatar.toDouble(),
                child: ClipOval(child: imageAvatar),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
         identifier,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  followersQuantity.toString(),
                  style: const TextStyle(fontSize: 20),
                ),
                const Text(
                  'Followers',
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  followingQuantity.toString(),
                  style: const TextStyle(fontSize: 20),
                ),
                const Text(
                  'Following',
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,  // căn chỉnh các widget con theo chiều ngang với khoảng cách bằng nhau
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: isFollowing
                      ? MaterialStateProperty.all(Colors.grey[300])
                      : MaterialStateProperty.all(Colors.lightBlue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(  // nút được bo tròn 18.0
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                onPressed: followButtonFunction,
                child: isFollowing
                    ? const Text(
                  'Following',
                  style: TextStyle(
                      color: Colors.black, fontSize: 20),
                )
                    : const Text(
                  'Follow',
                  style: TextStyle(
                      color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.red.withOpacity(0.5); // Màu khi nút được nhấn
                      } else if (states.contains(MaterialState.disabled)) {
                        return Colors.indigo.withOpacity(0.5); // Màu khi nút bị vô hiệu hóa
                      }
                      return Colors.lightBlue; // Màu mặc định khi không nhấn
                    },
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                onPressed: () {
                  // TODO: Implement chat button functionality
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(id: identifier),
                    ),
                  );
                },
                child: const Icon(
                  Icons.chat,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
        const Divider(
          thickness: 2.5,
        ),
      ],
    );
  }
}


