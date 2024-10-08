import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

Future<void> searchBusLines(String query, Function(List<String>, List<Polyline>) updateCallback) async {
  final response = await http.get(
    Uri.parse('https://www.sistemas.dftrans.df.gov.br/percurso/linha/numero/$query/WGS'),);
  tileProvider: CancellableNetworkTileProvider();

  if (response.statusCode == 200) { // Converte a resposta JSON em um mapa
    final data = json.decode(response.body);
    List<Polyline> busRoutes = [];

    if (data != null && data['features'] != null) {
      for (var feature in data['features']) {
        if (feature['geometry'] != null && feature['geometry']['coordinates'] != null) {
          List<LatLng> points = feature['geometry']['coordinates']
              .map<LatLng>((coord) => LatLng(coord[1], coord[0])).toList();
            // Inverte a ordem se necessário

            // Cria uma polilinha
          busRoutes.add(Polyline(points: points, strokeWidth: 4.0, color: Colors.blue));
        }
      }
    }
    updateCallback([], busRoutes);
  } else {
    updateCallback([], []);
  }
}