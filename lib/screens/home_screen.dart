// A brand new for make a screen using get state management
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tribun_app/controllers/news_controller.dart';
import 'package:tribun_app/routes/app_pages.dart';
import 'package:tribun_app/utils/app_colors.dart';
import 'package:tribun_app/widgets/category_chip.dart';
import 'package:tribun_app/widgets/loading_shimmer.dart';
import 'package:tribun_app/widgets/news_card.dart';

class HomeScreen extends GetView<NewsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold( // yg memanggil kelas scaffold hanya SCREEN.
      appBar: AppBar(
        title: Text('News App'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          )
        ],
      ),
      body: Column(
        children: [
          // categories
          Container(
            height: 60,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: controller.categories.length, //controller = utk memproses request
              itemBuilder: (context, index) {
                final category = controller.categories[index];
                 return Obx(() => CategoryChip( //observable dari get x => utk memberitahu UI ketika ada perubahan
                  // ?? = untuk set default
                  label: category.capitalize ?? category,
                  // == category : menyamakan isinya dengan category
                  isSelected: controller.selectedCategory == category,
                  onTap: () => controller.selectCategory(category),
                ));
              }, 
            ),
          ),
          // news list
          Expanded( // utk membuat widget memenuhi ruang kosong, jadi akan full screen
            child: Obx(() {
              if (controller.isLoading) {
                return LoadingShimmer();
              }

              if (controller.error.isNotEmpty) {
                return _buildErrorWidget();
              }

              if (controller.articles.isEmpty) {
                return _buildEmptyWidget();

              }

          return RefreshIndicator(
              onRefresh: controller.refreshNews,
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: controller.articles.length,
                itemBuilder: (context, index) {
                  final article = controller.articles[index];
                  return NewsCard(
                    articles: article,
                    onTap: () => Get.toNamed(
                      Routes.NEWS_DETAIL,

                      //argument berfungsi utk bernavigasi kehalaman lain
                      arguments: article
                    ),
                  );
                },
              ),
            );
            }) 
          )
        ],
      ),
   );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.newspaper,
            size: 64,
            color: AppColors.textHint,
          ),
          SizedBox(height: 16),
          Text(
            'No news available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please try again later',
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please check your internet connection',
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: controller.refreshNews,
            child: Text('Retry'),
          )
        ],
      ),
    );
  }


  void _showSearchDialog(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Search News'),
        content: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Please type a news..',
            border: OutlineInputBorder()
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              controller.searchNews(value);
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (searchController.text.isNotEmpty) {
                controller.searchNews(searchController.text);
                Navigator.of( context).pop();
              }
            },
            child: Text('Search'),
          )
        ],
      )
    );
  }
}