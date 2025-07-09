import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/app/data/models/DetailSurah.dart';

class DetailJuzController extends GetxController {
  final player = AudioPlayer();
  Verse? lastVerse;

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
