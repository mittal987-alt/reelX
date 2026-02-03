import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/search_controller.dart';
import '../../model/user.dart';
import 'profilr_screen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final SearchControllerX controller =
  Get.put(SearchControllerX());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Search username...",
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
          onChanged: controller.searchUser,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: controller.clearHistory,
          )
        ],
      ),

      body: Obx(() {
        List<MyUser> list = controller.searchResults.isNotEmpty
            ? controller.searchResults
            : controller.history;

        if (list.isEmpty) {
          return const Center(
            child: Text("No recent searches",
                style: TextStyle(color: Colors.white54)),
          );
        }

        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            MyUser user = list[index];

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.profilePic),
              ),
              title: Text(
                user.username,
                style: const TextStyle(color: Colors.white),
              ),

              onTap: () {
                controller.saveHistory(user);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfileScreen(user: user),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}
