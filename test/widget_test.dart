import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quran_app/app/data/models/DetailSurah.dart';
import 'package:quran_app/app/data/models/Surah.dart';

void main() async {
  Uri url = Uri.parse("https://api.quran.gading.dev/surah/");
  var res = await http.get(url);

  List data = (json.decode(res.body) as Map<String, dynamic>)["data"];

  Surah surahAnnas = Surah.fromJson(data[113]);

  // print(surahAnnas.name.long);
  // print(surahAnnas.name.translation.en);
  // print(surahAnnas.revelation.arab);

  Uri urlAnnas =
      Uri.parse("https://api.quran.gading.dev/surah/${surahAnnas.number}");
  var resAnnas = await http.get(urlAnnas);
  Map<String, dynamic> dataAnnas =
      (json.decode(resAnnas.body) as Map<String, dynamic>)["data"];

  DetailSurah detailSurahAnnas = DetailSurah.fromJson(dataAnnas);

  print(detailSurahAnnas.verses[0].text.arab);
}
