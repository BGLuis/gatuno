import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../core/di/injection.dart';
import '../../../core/network/dio_client.dart';
import 'app_skeleton.dart';

class AppImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  @override
  State<AppImage> createState() => _AppImageState();
}

class _AppImageState extends State<AppImage> {
  late Future<Uint8List?> _fetchFuture;
  final _dioClient = sl<DioClient>();

  @override
  void initState() {
    super.initState();
    _fetchFuture = _fetchImage();
  }

  @override
  void didUpdateWidget(AppImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      setState(() {
        _fetchFuture = _fetchImage();
      });
    }
  }

  Future<Uint8List?> _fetchImage() async {
    try {
      final response = await _dioClient.dio.get<List<int>>(
        widget.imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.data != null) {
        return Uint8List.fromList(response.data!);
      }
    } catch (e) {
      debugPrint('Error fetching image (${widget.imageUrl}): $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _fetchFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return widget.placeholder ??
              AppSkeleton(width: widget.width, height: widget.height);
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return SizedBox(
            width: widget.width,
            height: widget.height,
            child: Center(
              child:
                  widget.errorWidget ??
                  widget.placeholder ??
                  const Icon(Icons.broken_image, size: 24.0),
            ),
          );
        }

        return Image.memory(
          snapshot.data!,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child:
                  widget.errorWidget ??
                  const Icon(Icons.broken_image, size: 24.0),
            );
          },
        );
      },
    );
  }
}
