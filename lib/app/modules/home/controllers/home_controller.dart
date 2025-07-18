import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:quran_app/app/constant/color.dart';
import 'package:quran_app/app/data/db/bookmark.dart';
import 'package:quran_app/app/data/models/DetailSurah.dart';
import 'package:quran_app/app/data/models/Surah.dart';
import 'package:sqflite/sqflite.dart';

class HomeController extends GetxController {
  RxBool isDark = false.obs;
  RxBool isDataAllJuz = false.obs;
  List<Surah> allSurah = [];
  List<Map<String, dynamic>> allJuz = [];

  DatabaseManager database = DatabaseManager.instance;

  void changeTemeMode() async {
    Get.isDarkMode ? Get.changeTheme(themeLight) : Get.changeTheme(themeDark);

    final box = GetStorage();

    if (Get.isDarkMode) {
      box.remove("themeDark");
    } else {
      box.write("themeDark", true);
    }
  }

  Future<Map<String, dynamic>?> getLastRead() async {
    Database db = await database.db;
    List<Map<String, dynamic>> dataLastRead =
        await db.query("bookmark", where: "last_read = 1");

    if (dataLastRead.length == 0) {
      return null;
    } else {
      return dataLastRead.first;
    }
  }

  deleteLastRead(int id) async {
    Database db = await database.db;
    await db.delete("bookmark", where: "id = $id and last_read=1");

    update();
    Get.back();
    Get.snackbar("Berhasil", "Telah berhasil menghapus last read",
        colorText: appWhite);
  }

  deleteBookmark(int id) async {
    Database db = await database.db;
    await db.delete("bookmark", where: "id = $id");

    update();
    Get.snackbar("Berhasil", "Telah berhasil menghapus bookmark",
        colorText: appWhite);
  }

  Future<List<Map<String, dynamic>>> getBookmark() async {
    Database db = await database.db;
    List<Map<String, dynamic>> allBookmarks = await db.query("bookmark",
        where: "last_read = 0", orderBy: "juz, via, surah, ayat");
    return allBookmarks;
  }

  Future<List<Surah>> getAllSurah() async {
    Uri url = Uri.parse("https://api.quran.gading.dev/surah/");
    var res = await http.get(url);

    List? data = (json.decode(res.body) as Map<String, dynamic>)["data"];

    if (data == null || data.isEmpty) {
      return [];
    } else {
      allSurah = data.map((e) => Surah.fromJson(e)).toList();
      return allSurah;
    }
  }

  Future<List<Map<String, dynamic>>> getAllJuz() async {
    int juz = 1;

    List<Map<String, dynamic>> penampungAyat = [];

    for (var i = 1; i <= 114; i++) {
      var res = await http.get(Uri.parse("http://10.0.2.2:3000/surah/${i}"));
      Map<String, dynamic> rawData = json.decode(res.body)["data"];
      DetailSurah data = DetailSurah.fromJson(rawData);

      if (data.verses != null) {
        data.verses.forEach((ayat) {
          if (ayat.meta.juz == juz) {
            penampungAyat.add({
              "surah": data,
              "ayat": ayat,
            });
          } else {
            allJuz.add({
              "juz": juz,
              "start": penampungAyat[0],
              "end": penampungAyat[penampungAyat.length - 1],
              "verses": penampungAyat,
            });

            juz++;
            penampungAyat = [];
            penampungAyat.add({
              "surah": data,
              "ayat": ayat,
            });
          }
        });
      }
    }

    allJuz.add({
      "juz": juz,
      "start": penampungAyat[0],
      "end": penampungAyat[penampungAyat.length - 1],
      "verses": penampungAyat,
    });

    return allJuz;
  }
}
