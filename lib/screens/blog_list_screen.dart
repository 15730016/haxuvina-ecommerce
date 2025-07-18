import 'package:haxuvina/custom/device_info.dart';
import 'package:haxuvina/helpers/shimmer_helper.dart';
import 'package:haxuvina/my_theme.dart';
import 'package:haxuvina/providers/blog_provider.dart';
import 'package:haxuvina/screens/blog_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:haxuvina/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class BlogListScreen extends StatefulWidget {
  const BlogListScreen({super.key});

  @override
  State<BlogListScreen> createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  bool _showSearchBar = false;
  TextEditingController _searchController = TextEditingController();

  Future<void>? _fetchBlogsFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_fetchBlogsFuture == null) {
      _fetchBlogsFuture = Provider.of<BlogProvider>(context, listen: false).fetchBlogs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBlogList(context),
      backgroundColor: MyTheme.mainColor,
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      scrolledUnderElevation: 0.0,
      backgroundColor: MyTheme.mainColor,
      title: buildAppBarTitle(context),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  Widget buildAppBarTitle(BuildContext context) {
    return AnimatedCrossFade(
        firstChild: buildAppBarTitleOption(context),
        secondChild: buildAppBarSearchOption(context),
        firstCurve: Curves.fastOutSlowIn,
        secondCurve: Curves.fastOutSlowIn,
        crossFadeState: _showSearchBar
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: Duration(milliseconds: 500));
  }

  Widget buildAppBarTitleOption(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          // SỬA LỖI: Thay thế bằng BackButton tiêu chuẩn để đảm bảo tính ổn định
          BackButton(color: MyTheme.dark_font_grey),
          Container(
            padding: EdgeInsets.only(left: 10),
            width: DeviceInfo(context).width! / 2,
            child: Text(
              AppLocalizations.of(context)!.all_blogs_ucf,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: MyTheme.dark_font_grey),
            ),
          ),
          Spacer(),
          SizedBox(
              width: 24,
              height: 24,
              child: IconButton(
                  splashRadius: 20,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    _showSearchBar = true;
                    setState(() {});
                  },
                  icon: Image.asset('assets/search.png')))
        ],
      ),
    );
  }

  Container buildAppBarSearchOption(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18),
      width: DeviceInfo(context).width,
      height: 40,
      child: TextField(
        controller: _searchController,
        onTap: () {},
        onChanged: (txt) {
          // Thêm logic tìm kiếm ở đây nếu cần
        },
        onSubmitted: (txt) {
          // Thêm logic tìm kiếm ở đây nếu cần
        },
        autofocus: true, // Tự động focus khi thanh tìm kiếm hiện ra
        decoration: InputDecoration(
          hintText: "Tìm kiếm bài viết..."
          ,
          hintStyle: TextStyle(fontSize: 14.0, color: MyTheme.font_grey),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.light_grey, width: 1.0),
              borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.accent_color, width: 1.0),
              borderRadius: BorderRadius.circular(8)),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
          suffixIcon: IconButton(
            onPressed: () {
              _showSearchBar = false;
              setState(() {});
            },
            icon: Icon(
              Icons.close,
              color: MyTheme.grey_153,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBlogList(BuildContext context) {
    return FutureBuilder(
        future: _fetchBlogsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ShimmerHelper()
                .buildListShimmer(item_count: 5, item_height: 250.0);
          }

          if (snapshot.hasError) {
            return Center(child: Text("Đã có lỗi xảy ra. Vui lòng thử lại."));
          }

          return Consumer<BlogProvider>(
            builder: (context, blogProvider, child) {
              if(blogProvider.blogs.isEmpty){
                return Center(child: Text("Không có bài viết nào."));
              }

              // SỬA LỖI: Thay thế bằng ListView.builder để tăng tính ổn định
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: blogProvider.blogs.length,
                itemBuilder: (context, index) {
                  final blog = blogProvider.blogs[index];
                  // Sử dụng Card để có giao diện rõ ràng, hiện đại
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlogDetailsScreen(
                              blog: blog,
                            ),
                          ));
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 5,
                      shadowColor: MyTheme.light_grey.withOpacity(0.5),
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 160,
                            width: double.infinity,
                            child: Image.network(
                              blog.banner,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                    child: Icon(Icons.image_not_supported,
                                        color: Colors.grey, size: 40));
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  blog.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: MyTheme.dark_font_grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  blog.shortDescription,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: MyTheme.font_grey,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        });
  }
}
