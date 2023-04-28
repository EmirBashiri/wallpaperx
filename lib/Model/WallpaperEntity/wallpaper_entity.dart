import 'package:hive_flutter/hive_flutter.dart';
part 'wallpaper_entity.g.dart';

// Wallpaper Entity configuration for save in database
const int _wallpaperTypeId = 1;

const int _wallpaperFieldId = 0;
const int _wallpaperFieldCover = 1;
const int _wallpaperFieldView = 2;
const int _wallpaperFieldDownload = 3;
const int _wallpaperFieldPhotograph = 4;

@HiveType(typeId: _wallpaperTypeId)
class WallpaperEntity {
  @HiveField(_wallpaperFieldId)
  final String id;
  @HiveField(_wallpaperFieldCover)
  final String coverLink;
  @HiveField(_wallpaperFieldView)
  final String viewLink;
  @HiveField(_wallpaperFieldDownload)
  final String downloadLink;
  @HiveField(_wallpaperFieldPhotograph)
  final String photographerProfileLink;

  WallpaperEntity({
    required this.id,
    required this.coverLink,
    required this.viewLink,
    required this.downloadLink,
    required this.photographerProfileLink,
  });

  factory WallpaperEntity.fromJson(Map<String, dynamic> json) {
    return WallpaperEntity(
      id: json["id"],
      coverLink: json["thumbs"]["original"],
      viewLink: json["path"],
      downloadLink: json["path"],
      photographerProfileLink: json["url"],
    );
  }

  // Pixbay response fetch
  WallpaperEntity.fromJsonPixbay(Map<String, dynamic> json)
      : id = json["id"].toString(),
        coverLink = json["previewURL"] ?? "",
        viewLink = json["largeImageURL"] ?? "",
        downloadLink = json["largeImageURL"] ?? "",
        photographerProfileLink = json["pageURL"] ?? "";
}

class WallpaperCollectionEntity {
  final String id;
  final String collectionCoverUrl;

  WallpaperCollectionEntity(this.id, this.collectionCoverUrl);
  WallpaperCollectionEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        collectionCoverUrl = json["thumbs"]["original"] ?? "";
}
