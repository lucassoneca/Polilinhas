import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../Linhas/buscalinha.dart';

class TelaMapa extends StatefulWidget {
  const TelaMapa({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<TelaMapa> {
  final TextEditingController _searchController = TextEditingController();
  List<Polyline> _busRoutes = [];
  bool _isLoading = false;

  void _updateBusLinesAndRoutes(List<String> busLines, List<Polyline> busRoutes) {
    setState(() {
      _busRoutes = busRoutes;
      _isLoading = false; // Para ocultar o indicador de carregamento
    });
  }

  Future<void> _searchBusLine(String query) async {
    setState(() {
      _isLoading = true; // Para mostrar o indicador de carregamento
    });
    await searchBusLines(query, _updateBusLinesAndRoutes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Mapa de Linhas de Ônibus')),
        body: Column(
            children: [
              _buildSearchField(),
              if (_isLoading) const CircularProgressIndicator(), // Indicador de carregamento
              Expanded(child: _buildMap()),
            ],
        ),
    );
  }
                Widget _buildSearchField() {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Buscar linha de ônibus',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () =>
                              _searchBusLine(_searchController.text),
                        ),
                      ),
                      onSubmitted: _searchBusLine,
                    ),
                  );
                }
  Widget _buildMap() {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(-15.7801, -47.9292),
        initialZoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'tela semob',
        ),
        PolylineLayer(polylines: _busRoutes),
      ],
    );
  }
}