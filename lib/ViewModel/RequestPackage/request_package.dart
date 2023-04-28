import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_wallpaper_x/Model/Constant/const.dart';
import 'package:flutter_wallpaper_x/Model/WallpaperEntity/wallpaper_entity.dart';
import 'package:path_provider/path_provider.dart';

// request configurations
const String _apiUrl = "https://wallhaven.cc/api/v1/search";
final Dio _baseApi = Dio(BaseOptions(baseUrl: _apiUrl));

// requests parameters
Map<String, dynamic> _searchParameters({required String searchKeyword}) {
  return {
    "q": searchKeyword,
    "sorting": ApiOrder.random.name,

  };
}

Map<String, dynamic> _getFeaturedWallpaperParameters({required int page}) {
  return {
    "page": page,
    "sorting": ApiOrder.random.name,
  };
}

Map<String, dynamic> _getCollectionsCoverParameters({
  int? page,
  required String query,
  ApiOrder? apiOrder,
}) {
  return {
    "page": page ?? defaultPageNumber,
    "q": query,
    "sorting": apiOrder != null ? apiOrder.name : ApiOrder.random.name,
  };
}

Map<String, dynamic> _getCollectionWallpapersParameters(
    {required String collectionName, int? page, ApiOrder? apiOrder}) {
  return {
    "page": page ?? defaultPageNumber,
    "q": collectionName,
    "sorting": apiOrder != null ? apiOrder.name : ApiOrder.random.name,
  };
}

class RequestPackage {
  final Response _defaultResponse = Response(requestOptions: RequestOptions());

  Response _parseJson({required Map json}) {
    _defaultResponse.data = json["data"];
    return _defaultResponse;
  }

  Future<Response> _httpResponse({
    required File cachedFile,
    required Map<String, dynamic>? parameters,
    required String url,
  }) async {
    final Response response =
        await _baseApi.get(url, queryParameters: parameters);
    if (response.statusCode == 200) {
      if (!await cachedFile.exists()) {
        await cachedFile.create(recursive: true);
      }
      final Response parsedResponse = _parseJson(json: response.data);
      await cachedFile.writeAsString(jsonEncode(parsedResponse.data));
      return parsedResponse;
    } else {
      throw customExcepiton;
    }
  }

  Future<Response> _cachedResponse(
      {required String url,
      Map<String, dynamic>? parameters,
      String key = "",
      Duration? cacheMaxAge}) async {
    final Directory cacheDirectory = await getTemporaryDirectory();
    // Custom file for cache items
    final File cachedFile = File("${cacheDirectory.path}/$url$key/cache");

    final Duration requestCacheMaxAge =
        cacheMaxAge ?? defaultRequestCacheMaxAge;
    if (await cachedFile.exists()) {
      if (DateTime.now().difference(await cachedFile.lastModified()).inHours <=
          requestCacheMaxAge.inHours) {
        final jsonData = await cachedFile.readAsString();
        _defaultResponse.data = jsonDecode(jsonData);
        return _defaultResponse;
      } else {
        return await _httpResponse(
          url: url,
          cachedFile: cachedFile,
          parameters: parameters,
        );
      }
    } else {
      return await _httpResponse(
        url: url,
        cachedFile: cachedFile,
        parameters: parameters,
      );
    }
  }

  Future<List<WallpaperEntity>> getFeaturedWallpaperList(
      {required int page,
      String? urlPath,
      String? cacheKey,
      Duration? cacheMaxAge}) async {
    final Response httpClient = await _cachedResponse(
      url: urlPath ?? "",
      cacheMaxAge: cacheMaxAge,
      key: cacheKey ?? featuredWallpapersQuery,
      parameters: _getFeaturedWallpaperParameters(
        page: page,
      ),
    );

    List<WallpaperEntity> wallpaperList = [];
    if (httpClient.data != null) {
      wallpaperList = (httpClient.data as List)
          .map((json) => WallpaperEntity.fromJson(json))
          .toList();
      return wallpaperList;
    } else {
      throw customExcepiton;
    }
  }

  Future<List<WallpaperEntity>> searchWallpapers(
      {required String searchKeyword}) async {
    List<WallpaperEntity> searchResultList = [];
    final httpClient = await _baseApi.get("",
        queryParameters: _searchParameters(searchKeyword: searchKeyword));
    if (httpClient.statusCode == 200) {
      final Response response = _parseJson(json: httpClient.data);
      searchResultList = (response.data as List)
          .map((json) => WallpaperEntity.fromJson(json))
          .toList();
      return searchResultList;
    } else {
      throw customExcepiton;
    }
  }

  Future<List<WallpaperEntity>> getCollectionWallpapers(
      {required String collectionName,
      required int page,
      String? cacheKey,
      Duration? cacheMaxAge,
      ApiOrder? apiOrder}) async {
    final Response httpClient = await _cachedResponse(
      url: "",
      cacheMaxAge: cacheMaxAge,
      key: cacheKey ?? "",
      parameters: _getCollectionWallpapersParameters(
          collectionName: collectionName, page: page, apiOrder: apiOrder),
    );

    List<WallpaperEntity> wallpaperCollectionList = [];
    if (httpClient.data != null) {
      wallpaperCollectionList = (httpClient.data as List)
          .map((json) => WallpaperEntity.fromJson(json))
          .toList();
      return wallpaperCollectionList;
    } else {
      throw customExcepiton;
    }
  }

  Future<List<WallpaperCollectionEntity>> getCollectionsCover(
      {int? page,
      String? urlPath,
      required String query,
      ApiOrder? orderBy,
      String? cacheKey,
      Duration? cacheMaxAge}) async {
    final Response httpClient = await _cachedResponse(
      url: urlPath ?? "",
      cacheMaxAge: cacheMaxAge,
      key: cacheKey ?? "",
      parameters: _getCollectionsCoverParameters(
          page: page, query: query, apiOrder: orderBy),
    );

    List<WallpaperCollectionEntity> wallpaperList = [];
    if (httpClient.data != null) {
      wallpaperList = (httpClient.data as List)
          .map((json) => WallpaperCollectionEntity.fromJson(json))
          .toList();
      return wallpaperList;
    } else {
      throw customExcepiton;
    }
  }
}
