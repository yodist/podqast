import 'package:podqast/util/config_util.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PodcastService {
  Future<Map<String, dynamic>> fetchBestPodcasts() async {
    String key =
        await ConfigUtil.getConfigData().then((value) => value['listenKey']);
    String baseUrl = await getBaseUrl();
    final response =
        await http.get(Uri.parse(baseUrl + '/best_podcasts'), headers: {
      'X-ListenAPI-Key': key,
    });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load best podcast');
    }
  }

  Future<Map<String, dynamic>> fetchGenres() async {
    String key =
        await ConfigUtil.getConfigData().then((value) => value['listenKey']);
    String baseUrl = await getBaseUrl();
    final response =
        await http.get(Uri.parse('$baseUrl/genres?top_level_only=1'), headers: {
      'X-ListenAPI-Key': key,
    });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load genres');
    }
  }

  Future<Map<String, dynamic>> fetchPodcastListById(String id) async {
    String key =
        await ConfigUtil.getConfigData().then((value) => value['listenKey']);
    String baseUrl = await getBaseUrl();
    final response =
        await http.get(Uri.parse(baseUrl + '/podcasts/' + id), headers: {
      'X-ListenAPI-Key': key,
    });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load genres');
    }
  }

  Future<List<String>> getSuggestions(String pattern) async {
    if (pattern.isEmpty) return Future.value(List.empty());

    String key =
        await ConfigUtil.getConfigData().then((value) => value['listenKey']);
    String baseUrl = await getBaseUrl();
    final response = await http.get(
      Uri.parse("$baseUrl/typeahead?q=${pattern.toLowerCase()}"),
      headers: {
        'X-ListenAPI-Key': key,
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> decoded =
          jsonDecode(utf8.decode(response.bodyBytes));
      List<String> listDec = List<String>.from(decoded['terms']);
      return Future.value(listDec);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to typeahead');
    }
  }

  Future<List<Map<String, dynamic>>> getSuggestionsPodcast(
      String pattern) async {
    String key =
        await ConfigUtil.getConfigData().then((value) => value['listenKey']);
    var baseUrl = await getBaseUrl();
    final response = await http.get(
      // Uri.https("listen-api-test.listennotes.com", "/api/v2/typeahead",
      //     {"q": pattern, "show_podcasts": 3}),
      Uri.parse("$baseUrl/typeahead?q=$pattern&show_podcasts=1"),
      headers: {
        'X-ListenAPI-Key': key,
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> decoded =
          jsonDecode(utf8.decode(response.bodyBytes));
      List<Map<String, dynamic>> listDec =
          List<Map<String, dynamic>>.from(decoded['podcasts']);
      return Future.value(listDec);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to typeahead');
    }
  }

  Future<List<Map<String, dynamic>>> searchPodcasts(String pattern) async {
    String key =
        await ConfigUtil.getConfigData().then((value) => value['listenKey']);
    String baseUrl = await getBaseUrl();
    final response = await http.get(
      Uri.parse("$baseUrl/search?q=$pattern&type=podcast"),
      headers: {
        'X-ListenAPI-Key': key,
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> decoded =
          jsonDecode(utf8.decode(response.bodyBytes));
      List<Map<String, dynamic>> listDec =
          List<Map<String, dynamic>>.from(decoded['results']);
      return Future.value(listDec);
    } else {
      throw Exception('Something is wrong');
    }
  }

  Future<String> getBaseUrl() async {
    bool production = false;
    String api = 'api-test';
    await ConfigUtil.getConfigData().then((value) {
      production = value['production'];
    });

    if (production) {
      api = 'api';
    }

    return 'https://listen-$api.listennotes.com/api/v2';
  }
}
