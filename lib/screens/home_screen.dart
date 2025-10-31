import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tribun_app/controllers/news_controller.dart';
import 'package:tribun_app/routes/app_pages.dart';
import 'package:tribun_app/widgets/category_chip.dart';
import 'package:tribun_app/widgets/loading_shimmer.dart';
import 'package:tribun_app/widgets/news_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Daftar halaman yang akan di-switch
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _buildHomePage(),
      const Center(
        child: Text(
          'Bookmark Screen',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      const Center(
        child: Text(
          'Profile Screen',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    ];
  }

  // 🏠 Halaman utama
  Widget _buildHomePage() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/earena non bg.png',
                  width: 130,
                  height: 130,
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded,
                      color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // 🔹 Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF10182B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  const Icon(Icons.search, color: Colors.white70),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          Get.find<NewsController>().searchNews(value);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 🔹 Category Chips
          SizedBox(
            height: 52,
            child: Obx(() {
              final controller = Get.find<NewsController>();
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: controller.categories.map((category) {
                    final isSelected =
                        controller.selectedCategory == category;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.only(right: 16),
                      child: CategoryChip(
                        label: category.capitalize ?? category,
                        isSelected: isSelected,
                        onTap: () => controller.selectCategory(category),
                      ),
                    );
                  }).toList(),
                ),
              );
            }),
          ),

          const SizedBox(height: 6),

          // 🔹 Coming Soon Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Coming Soon 🔥',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text('See all', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),

          SizedBox(
            height: 180,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildComingSoonCard(
                    imageUrl: 'assets/images/COD7.png',
                    title: 'Call of Duty Black Ops 7',
                    date: 'November 14, 2025',
                    url: 'https://gamerant.com/db/video-game/call-of-duty-black-ops-7/',
                  ),
                  _buildComingSoonCard(
                    imageUrl: 'assets/images/SLO.png',
                    title: 'Solo Leveling: ARISE OVERDRIVE',
                    date: 'November 17, 2025',
                    url: 'https://gamerant.com/db/video-game/solo-leveling-arise-overdrive/',
                  ),
                  _buildComingSoonCard(
                    imageUrl: 'assets/images/DPVR.png',
                    title: 'Marvel Deadpool VR',
                    date: 'November 18, 2025',
                    url: 'https://gamerant.com/db/video-game/marvels-deadpool-vr/',
                  ),
                  _buildComingSoonCard(
                    imageUrl: 'assets/images/PTH#.png',
                    title: 'Pathologic 3',
                    date: 'January 9, 2026',
                    url: 'https://gamerant.com/db/video-game/pathologic-3/',
                  ),
                  _buildComingSoonCard(
                    imageUrl: 'assets/images/RE9.png',
                    title: 'Resident Evil Requiem',
                    date: 'February 27, 2026',
                    url: 'https://gamerant.com/db/video-game/resident-evil-requiem/',
                  ),
                  
                  _buildComingSoonCard(
                    imageUrl: 'assets/images/BF.png',
                    title: 'BLACKFROST: The Long Dark 2',
                    date: '2026',
                    url: 'https://gamerant.com/db/video-game/blackfrost-the-long-dark-2/',
                  ),
                  _buildComingSoonCard(
                    imageUrl: 'assets/images/AVT.png',
                    title: 'Avatar Legends: The Fighting Game',
                    date: '2026',
                    url: 'https://gamerant.com/db/video-game/avatar-legends-the-fighting-game/',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 🔹 News Section
          Expanded(
            child: Obx(() {
              final controller = Get.find<NewsController>();
              if (controller.isLoading) return const MinimalLoadingIndicator();
              if (controller.error.isNotEmpty) return _buildErrorWidget();
              if (controller.articles.isEmpty) return _buildEmptyWidget();

              return RefreshIndicator(
                onRefresh: controller.refreshNews,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.articles.length,
                  itemBuilder: (context, index) {
                    final article = controller.articles[index];
                    return NewsCard(
                      articles: article,
                      onTap: () => Get.toNamed(
                        Routes.NEWS_DETAIL,
                        arguments: article,
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildComingSoonCard({
    required String imageUrl,
    required String title,
    required String date,
    required String url,
  }) {
    return GestureDetector(
      onTap: () async {
        final Uri link = Uri.parse(url);
        if (await canLaunchUrl(link)) {
          await launchUrl(link, mode: LaunchMode.externalApplication);
        } else {
          Get.snackbar(
            'Error',
            'Could not open the website',
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF0F1A3D), Color(0xFF14244A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imageUrl,
                height: 110,
                width: double.infinity,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade800,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.image_not_supported,
                          color: Colors.white54, size: 50),
                      SizedBox(height: 6),
                      Text(
                        'Image not supported',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    date,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/news not av.png', width: 100, height: 100),
            const SizedBox(height: 16),
            const Text(
              'The newsroom is taking a nap 😴',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'They’ll wake up with fresh stories soon!',
              style: TextStyle(color: Colors.white54),
            ),
          ],
        ),
      );

  Widget _buildErrorWidget() => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/non internet.png', 
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),

          const SizedBox(height: 16),
          const Text(
            'Oops! Looks like we hit a snag',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'No worries—just reconnect and retry!',
            style: TextStyle(color: Colors.white54),
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () => Get.find<NewsController>().refreshNews(),
            child: const Text(
              'Retry',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1124),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0A1124),
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.white70,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            activeIcon: Icon(Icons.bookmark),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
