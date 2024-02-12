import 'package:proj4dart/proj4dart.dart' as proj4;

proj4.Point mercatorForward(
    {required double latitude, required double longitude}) {
  final projFrom = proj4.Projection.get('EPSG:4326')!; //Lat long system
  final projTo = proj4.Projection.get('EPSG:3857')!; // meters system
  final pointSrc = proj4.Point(x: longitude, y: latitude);
  final transformedPoint = projFrom.transform(projTo, pointSrc);

  return transformedPoint;
}

proj4.Point mercatorInverse(
    {required double xEasting, required double yNorthing}) {
  final projTo = proj4.Projection.get('EPSG:4326')!; //Lat long system
  final projFrom = proj4.Projection.get('EPSG:3857')!; // meters system
  final pointSrc = proj4.Point(x: xEasting, y: yNorthing);
  final transformedPoint = projFrom.transform(projTo, pointSrc);

  return transformedPoint;
}
