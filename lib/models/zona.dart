class Zona {
  final String id;
  final String municipio;
  final String nombre;
  final double latitud;
  final double longitud;

  const Zona({
    required this.id,
    required this.municipio,
    required this.nombre,
    required this.latitud,
    required this.longitud,
  });

  String get etiqueta => '$municipio · $nombre';
}
