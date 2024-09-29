import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tweet_app/src/features/tweet/store/home_store.dart';
import 'package:tweet_app/src/features/tweet/submodules/feed/feed_module.dart';
import 'package:tweet_app/src/features/tweet/submodules/search/search_module.dart';
import 'package:tweet_app/src/features/tweet/ui/components/custom_drawer.dart';
import '../../submodules/chat/chat_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeStore homeStore;

  @override
  void initState() {
    homeStore = Modular.get<HomeStore>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 30,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0), // Khoảng cách từ lề vào
            child: InkWell(
              onTap: () {
                // Điều hướng hoặc hiển thị cửa sổ trạng thái nhỏ tùy thuộc vào nhu cầu của bạn
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CustomDrawer()),
                );
              },
              child: const Row(
                children: [
                  Icon(
                    Icons.home,
                    color: Colors.white, // Màu sắc của icon
                    size: 30, // Kích thước của icon
                  ),
                  SizedBox(width: 8), // Khoảng cách giữa icon và nút
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          Modular.to.pushNamed('/tweet/addTweet/');
        },
        child: const Icon(Icons.add),
      ),
      body: Observer(
        builder: (_) => PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: homeStore.pageViewController,
          children: [
            FeedModule(),
            SearchModule(),
            chatlist(),
          ],
        ),
      ),
      bottomNavigationBar: Observer(
        builder: (_) => BottomNavigationBar(
          currentIndex: homeStore.currentPage,
          onTap: (index) {
            homeStore.changeCurrentPage(index);
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'Chat',),
          ],
        ),
      ),
    );
  }
}
