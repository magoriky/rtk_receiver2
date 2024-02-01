class Position {
  Position({required this.message});
  String message;
  final String _name1 = "GNRMC";
  final String _name2 = "GNVTG";
  final String _name3 = "GNGGA";

  List<String> _GNRMC = [];
  List<String> _GNVTG = [];
  List<String> _GNGGA = [];

  //int _getIndexFromString(List<String> list){
  //  List<String> listOfNames = ["\$GNRMC", "\$GNVTG",];
  //  return
  //}

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
        return pairLatLng;
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

    print("the pairLatLng is: $pairLatLng");
  }
}
