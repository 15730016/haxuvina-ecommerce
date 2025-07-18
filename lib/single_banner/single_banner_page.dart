import 'package:haxuvina/helpers/shimmer_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_config.dart';
import 'photo_provider.dart'; // Path to your provider file

class PhotoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<PhotoProvider>(context, listen: false).fetchPhotos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ShimmerHelper()
              .buildBasicShimmer(height: 50); // Show shimmer while loading
        }

        if (snapshot.hasError) {
          return Center(
              child: Text('Error loading photos')); // Handle API call errors
        }

        return Consumer<PhotoProvider>(
          builder: (context, photoProvider, child) {
            if (photoProvider.singleBanner.isEmpty) {
              return Center(
                  child: Text('No photos available.')); // No photos fallback
            }

            final photoData = photoProvider.singleBanner[0];

            return GestureDetector(
              onTap: () async {
                final url = photoData.url;
                if (url.isNotEmpty) {
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    throw 'Could not launch $url';
                  }
                } else {
                  print('URL is empty');
                }
              },
              child: Image.network(
                _buildFullImageUrl(photoData.photo),
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset('assets/images/image_placeholder.png'),
              ),
            );
          },
        );
      },
    );
  }

  String _buildFullImageUrl(String? photo) {
    if (photo == null || photo.trim().isEmpty) {
      return '${AppConfig.BASE_URL}/assets/img/placeholder.png'; // fallback ảnh mặc định
    }
    if (photo.startsWith('http')) return photo;
    return '${AppConfig.BASE_URL}/uploads/all/${photo.trim()}';
  }

}
