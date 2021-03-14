import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:global_configuration/global_configuration.dart';

Future<Map<String, dynamic>> fetchBestPodcasts() async {
  final response = await http.get(
      'https://listen-api-test.listennotes.com/api/v2/best_podcasts',
      headers: {
        'X-ListenAPI-Key': GlobalConfiguration().getValue("listenKey")
      });

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return jsonDecode(response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load best podcast');
  }
}

Future<Map<String, dynamic>> fetchGenres() async {
  final response = await http
      .get('https://listen-api-test.listennotes.com/api/v2/genres', headers: {
    'X-ListenAPI-Key': GlobalConfiguration().getValue("listenKey")
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
