import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// A robust and kid-friendly image widget for cards and thumbnails.
/// Handles remote URLs, asset images, loading states, and provides
/// a beautifully styled fallback/broken-image placeholder that fills
/// the full card area without distortion.
class AppCardImage extends StatelessWidget {
  final String? imageUrl;
  final String? fallbackAsset;
  final IconData? fallbackIcon;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;

  const AppCardImage({
    super.key,
    this.imageUrl,
    this.fallbackAsset,
    this.fallbackIcon,
    this.fit = BoxFit.cover,
    this.width = double.infinity,
    this.height = double.infinity,
    this.borderRadius,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;
    final url = imageUrl?.trim();

    if (url != null && url.isNotEmpty) {
      if (url.startsWith('http://') || url.startsWith('https://')) {
        content = CachedNetworkImage(
          imageUrl: url,
          fit: fit,
          width: width,
          height: height,
          alignment: Alignment.center,
          placeholder: (context, url) => _buildLoadingPlaceholder(),
          errorWidget: (context, url, error) => _buildFallbackOrPlaceholder(),
        );
      } else if (url.startsWith('assets/')) {
        content = Image.asset(
          url,
          fit: fit,
          width: width,
          height: height,
          alignment: Alignment.center,
          errorBuilder: (context, error, stackTrace) {
            return _buildFallbackOrPlaceholder();
          },
        );
      } else {
        content = _buildFallbackOrPlaceholder();
      }
    } else {
      content = _buildFallbackOrPlaceholder();
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: content,
      );
    }

    return content;
  }

  Widget _buildFallbackOrPlaceholder() {
    final asset = fallbackAsset?.trim();
    if (asset != null && asset.isNotEmpty && asset.startsWith('assets/')) {
      return Image.asset(
        asset,
        fit: fit,
        width: width,
        height: height,
        alignment: Alignment.center,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: backgroundColor ?? const Color(0xFFF1F5F9),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF38BDF8)),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: backgroundColor ?? const Color(0xFFF1F5F9),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            fallbackIcon ?? Icons.image_not_supported_rounded,
            size: 28,
            color: const Color(0xFF94A3B8),
          ),
        ),
      ),
    );
  }
}
