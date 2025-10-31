import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tribun_app/models/news_articles.dart';
import 'package:tribun_app/utils/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsDetailScreen extends StatefulWidget {
  const NewsDetailScreen({super.key});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final NewsArticles article = Get.arguments as NewsArticles;
  bool _isLiked = false; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (article.urlToImage != null)
                    CachedNetworkImage(
                      imageUrl: article.urlToImage!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.divider,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.divider,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/Noimage.png', 
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Oops! This image failed to load 😕',
                              style: TextStyle(
                                color: AppColors.textHint,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  // Fallback image container
                  else
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.grey.shade800, Colors.grey.shade900],
                        ),
                      ),
                      child: Icon(
                        Icons.newspaper_outlined,
                        size: 80,
                        color: Colors.white54,
                      ),
                    ),
                  // Subtle overlay for better text readability
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.4),
                        ],
                        stops: const [0.0, 0.7],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              
              Container(
  margin: const EdgeInsets.only(right: 8),
  child: GestureDetector(
    onTap: () {
      setState(() {
        _isLiked = !_isLiked;
      });
      Get.snackbar(
        '❤️ Heart It!',
        _isLiked ? 'Added to favorites! 🚀' : 'Removed from favorites. 😔',
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _isLiked ? Colors.redAccent.withOpacity(0.2) : Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: _isLiked ? Colors.redAccent.withOpacity(0.3) : Colors.transparent,
            blurRadius: _isLiked ? 16 : 0,
            spreadRadius: _isLiked ? 2 : 0,
          ),
        ],
      ),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 300),
        tween: Tween(begin: 1.0, end: _isLiked ? 1.2 : 1.0),
        builder: (context, scale, child) => Transform.scale(
          scale: scale,
          child: Icon(
            _isLiked ? Icons.favorite : Icons.favorite_border,
            color: _isLiked ? Colors.red : Colors.redAccent,
            size: 28,
          ),
        ),
      ),
    ),
  ),
),
              IconButton(
                icon: const Icon(Icons.share_outlined, color: Colors.white),
                onPressed: () => _shareArticle(),
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                color: const Color(0xFF1A1A1A),
                onSelected: (value) {
                  switch (value) {
                    case 'copy_link':
                      _copyLink();
                      break;
                    case 'open_browser':
                      _openInBrowser();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'copy_link',
                    child: Row(
                      children: const [
                        Icon(Icons.link_sharp, color: Colors.grey),
                        SizedBox(width: 12),
                        Text(
                          'Copy Link',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'open_browser',
                    child: Row(
                      children: const [
                        Icon(Icons.open_in_browser, color: Colors.grey),
                        SizedBox(width: 12),
                        Text(
                          'Open in Browser',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0A0A0A),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (article.source?.name != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blueAccent.withOpacity(0.2),
                                  Colors.purpleAccent.withOpacity(0.2),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.blueAccent.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              article.source!.name!,
                              style: const TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                        if (article.publishedAt != null) ...[
                          Text(
                            timeago.format(
                              DateTime.parse(article.publishedAt!),
                            ),
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Title - bolder and with subtle glow
                    if (article.title != null) ...[
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          article.title!,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 2),
                                blurRadius: 4,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    if (article.description != null) ...[
                      Text(
                        article.description!,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 17,
                          height: 1.6,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                    const SizedBox(height: 28),
                    // Content section 
                    if (article.content != null) ...[
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Content💡',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        article.content!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          height: 1.7,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],

                    if (article.url != null) ...[
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _openInBrowser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: Colors.blueAccent.withOpacity(0.5),
                              ),
                            ),
                            shadowColor: Colors.blueAccent.withOpacity(0.3),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.arrow_forward, size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                'Read Full Article',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _shareArticle() {
    if (article.url != null) {
      Share.share(
        '${article.title ?? 'Check out this news'}\n\n${article.url!}',
        subject: article.title,
      );
    }
  }

  void _copyLink() {
    if (article.url != null) {
      Clipboard.setData(ClipboardData(text: article.url!));
      Get.snackbar(
        'Success',
        'Link copied to clipboard!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void _openInBrowser() async {
    if (article.url != null) {
      final Uri url = Uri.parse(article.url!);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          "Couldn't open the link",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
}
