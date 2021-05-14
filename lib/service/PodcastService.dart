import 'package:flutter_application_1/util/ConfigUtil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PodcastService {
  Future<Map<String, dynamic>> fetchBestPodcasts() async {
    String key =
        await ConfigUtil.getConfigData().then((value) => value['listenKey']);
    final response = await http.get(
        Uri.parse(
            'https://listen-api-test.listennotes.com/api/v2/best_podcasts'),
        headers: {
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
    final response = await http.get(
        Uri.parse('https://listen-api-test.listennotes.com/api/v2/genres'),
        headers: {
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
    final response = await http.get(
        Uri.parse(
            'https://listen-api-test.listennotes.com/api/v2/podcasts/' + id),
        headers: {
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

  Future<List<Map<String, dynamic>>> getSuggestions(String pattern) async {
    String key =
        await ConfigUtil.getConfigData().then((value) => value['listenKey']);
    final response = await http.get(
      // Uri.https("listen-api-test.listennotes.com", "/api/v2/typeahead",
      //     {"q": pattern, "show_podcasts": 3}),
      Uri.parse("https://listen-api-test.listennotes.com/api/v2/typeahead?q=" +
          pattern +
          "&show_podcasts=3"),
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
}
