import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/app/constant/color.dart';
import 'package:quran_app/app/data/db/bookmark.dart';
import 'package:quran_app/app/data/models/DetailSurah.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sqflite/sqflite.dart';

class DetailJuzController extends GetxController {
  AutoScrollController scrollC = AutoScrollController();
  final player = AudioPlayer();
  Verse? lastVerse;

  DatabaseManager database = DatabaseManager.instance;

  Future<void> addBookmark(
      bool lastRead, DetailSurah surah, Verse ayat, int indexAyat) async {
    Database db = await database.db;
    bool flagExist = false;

    if (lastRead == true) {
      await db.delete("bookmark", where: "last_read = 1");
    } else {
      List checkData = await db.query("bookmark",
          columns: [
            "surah",
            "number_surah",
            "ayat",
            "juz",
            "via",
            "index_ayat",
            "last_read"
          ],
          where:
              "surah = '${surah.name.transliteration.id.replaceAll("'", "+")}' and number_surah = ${surah.number} and ayat = ${ayat.number.inSurah} and juz = ${ayat.meta.juz} and via = 'juz' and index_ayat = $indexAyat and last_read = 0");
      if (checkData.length != 0) {
        flagExist = true;
      }
    }

    if (flagExist == false) {
      await db.insert("bookmark", {
        "surah": "${surah.name.transliteration.id.replaceAll("'", "+")}",
        "number_surah": surah.number,
        "ayat": ayat.number.inSurah,
        "juz": ayat.meta.juz,
        "via": "juz",
        "index_ayat": indexAyat,
        "last_read": lastRead == true ? 1 : 0,
      });

      Get.back();
      Get.snackbar("Berhasil", "Berhasil menambahkan bookmark",
          colorText: appWhite);
    } else {
      Get.back();
      Get.snackbar("Terjadi Kesalahan", "Bookmark telah tersedia",
          colorText: appWhite);
    }

    var data = await db.query("bookmark");
    print(data);
  }

  void pauseAudio(Verse ayat) async {
    try {
      await player.pause();
      ayat.audioCondition = "pause";
      update();
    } on PlayerException catch (e) {
      Get.defaultDialog(
          title: "Terjadi Kesalahan", middleText: e.message.toString());
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: "Connection aborted: ${e.message.toString()}");
    } catch (e) {
      Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: "Tidak dapat menghentikan audio");
    }
  }

  void resumeAudio(Verse ayat) async {
    try {
      ayat.audioCondition = "playing";
      update();
      await player.play();
      ayat.audioCondition = "stop";
      update();
    } on PlayerException catch (e) {
      Get.defaultDialog(
          title: "Terjadi Kesalahan", middleText: e.message.toString());
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: "Connection aborted: ${e.message.toString()}");
    } catch (e) {
      Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: "Tidak dapat melanjutkan audio");
    }
  }

  void stopAudio(Verse ayat) async {
    try {
      await player.stop();
      ayat.audioCondition = "stop";
      update();
    } on PlayerException catch (e) {
      Get.defaultDialog(
          title: "Terjadi Kesalahan", middleText: e.message.toString());
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: "Connection aborted: ${e.message.toString()}");
    } catch (e) {
      Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: "Tidak dapat menghentikan audio");
    }
  }

  void playAudio(Verse ayat) async {
    try {
      if (lastVerse == null) {
        lastVerse = ayat;
      }

      lastVerse!.audioCondition = "stop";
      lastVerse = ayat;
      lastVerse!.audioCondition = "stop";
      update();

      await player.stop();
      await player.setUrl(ayat.audio.primary);
      ayat.audioCondition = "playing";
      update();
      await player.play();
      ayat.audioCondition = "stop";
      await player.stop();
      update();
    } on PlayerException catch (e) {
      Get.defaultDialog(
          title: "Terjadi Kesalahan", middleText: e.message.toString());
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: "Connection aborted: ${e.message.toString()}");
    } catch (e) {
      Get.defaultDialog(
          title: "Terjadi Kesalahan", middleText: "Tidak dapat memutar audio");
    }
  }

  @override
  void onClose() {
    player.stop();
    player.dispose();
    super.onClose();
  }
}
