import 'package:rtk_receiver/functions/convert_time.dart';

enum Data {
  latitude,
  longitude,
  time,
}

class Position {
  Position({required this.message});
  String message;
  final String _name1 = "GNRMC";
  final String _name2 = "GNVTG";
  final String _name3 = "GNGGA";

  List<String> _GNRMC = [];
  List<String> _GNVTG = [];
  List<String> _GNGGA = [];

  List<double> _useMercatorConverter(List<double> valuePair) {
    double latInDeg = ((valuePair[0] - (valuePair[0] % 100)) / 100) +
        ((valuePair[0] % 100) / 60);
    double lngInDeg = ((valuePair[1] - (valuePair[1] % 100)) / 100) +
        ((valuePair[1] % 100) / 60);

    //* Define Point
    // var pointSrc = Point(x:lngInDeg, y:latInDeg);
    // var projDst = Projection.get('EPSG:4326');

    return [latInDeg, lngInDeg];
  }

  String _getTime(List<String>? line) {
    if (line != null && line.isNotEmpty) {
      if (line[0].contains(_name1) || line[0].contains(_name3)) {
        List<String> lineSplit = line[0].split(",");
        String time = lineSplit[1];
        return utc2kst(time);
      }
    }
    return " ";
  }

  List<double> _getLatLng(List<String>? line) {
    if (line != null && line.isNotEmpty) {
      if (line[0].contains(_name1) || line[0].contains(_name3)) {
        List<String> lineSplit = line[0].split(",");
        int indexLatitude = lineSplit.indexOf("N") - 1;
        int indexLongitude = lineSplit.indexOf("E") - 1;
        List<double> pairLatLng = [
          double.parse(lineSplit[indexLatitude]),
          double.parse(lineSplit[indexLongitude])
        ];
        return _useMercatorConverter(pairLatLng);
      }
    }
    return [];
  }

  void convertMessage() {
    List<String> lines = message.split("\$");
    lines.removeAt(0); //*Get rid of the first element, which is always empty;
    //lines = lines
    //    .where((element) => (element.contains(_name1) ||
    //        element.contains(_name2) ||
    //        element.contains(_name3)))
    //    .toList();
    //for (int i = 0; i < lines.length; ++i) {
    //  print("Line $i is : ${lines[i]}");
    //}

    _GNRMC = lines.where((element) => element.contains(_name1)).toList();
    _GNVTG = lines.where((element) => element.contains(_name2)).toList();
    _GNGGA = lines.where((element) => element.contains(_name3)).toList();

    List<double> pairLatLng =
        _GNRMC.isEmpty ? _getLatLng(_GNGGA) : _getLatLng(_GNRMC);

    String convertedTime = _GNRMC.isEmpty ? _getTime(_GNGGA) : _getTime(_GNRMC);

    print("the pairLatLng is: $pairLatLng \ntime is: $convertedTime");
  }

  List<double> getCoordinates() {
    List<String> lines = message.split("\$");
    lines.removeAt(0); //*Get rid of the first element, which is always empty;
    //lines = lines
    //    .where((element) => (element.contains(_name1) ||
    //        element.contains(_name2) ||
    //        element.contains(_name3)))
    //    .toList();
    //for (int i = 0; i < lines.length; ++i) {
    //  print("Line $i is : ${lines[i]}");
    //}

    _GNRMC = lines.where((element) => element.contains(_name1)).toList();
    _GNVTG = lines.where((element) => element.contains(_name2)).toList();
    _GNGGA = lines.where((element) => element.contains(_name3)).toList();

    List<double> pairLatLng =
        _GNRMC.isEmpty ? _getLatLng(_GNGGA) : _getLatLng(_GNRMC);

    //print("the pairLatLng is: $pairLatLng");
    return pairLatLng;
  }

  Map<Data, dynamic> getData() {
    List<String> lines = message.split("\$");
    lines.removeAt(0); //*Get rid of the first element, which is always empty;
    //lines = lines
    //    .where((element) => (element.contains(_name1) ||
    //        element.contains(_name2) ||
    //        element.contains(_name3)))
    //    .toList();
    //for (int i = 0; i < lines.length; ++i) {
    //  print("Line $i is : ${lines[i]}");
    //}

    _GNRMC = lines.where((element) => element.contains(_name1)).toList();
    _GNVTG = lines.where((element) => element.contains(_name2)).toList();
    _GNGGA = lines.where((element) => element.contains(_name3)).toList();

    List<double> pairLatLng =
        _GNRMC.isEmpty ? _getLatLng(_GNGGA) : _getLatLng(_GNRMC);

    String convertedTime = _GNRMC.isEmpty ? _getTime(_GNGGA) : _getTime(_GNRMC);

    return {
      Data.latitude: pairLatLng[0],
      Data.longitude: pairLatLng[1],
      Data.time: convertedTime
    };
  }
}
