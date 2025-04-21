//
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

 ImageProvider<Object> cacheImage(String? url) {
  return CachedNetworkImageProvider(
    url ?? 'https://avatars.githubusercontent.com/u/1200?v=4',
  );
}
