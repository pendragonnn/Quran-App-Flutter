import 'dart:convert';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/app/data/models/DetailSurah.dart';
import 'package:http/http.dart' as http;

class DetailSurahController extends GetxController {
  final player = AudioPlayer();
  RxString audioCondition = "stop".obs;

  Future<DetailSurah> getDetailSurah(String id) async {
    Uri url = Uri.parse("https://api.quran.gading.dev/surah/$id");
    var res = await http.get(url);

    Map<String, dynamic> data =
        (json.decode(res.body) as Map<String, dynamic>)["data"];

    return DetailSurah.fromJson(data);
  }

  void pauseAudio() async {
    try {
      await player.pause();
      audioCondition.value = "pause";
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

  void resumeAudio() async {
    try {
      audioCondition.value = "playing";
      await player.play();
      audioCondition.value = "stop";
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

  void stopAudio() async {
    try {
      await player.stop();
      audioCondition.value = "stop";
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

  void playAudio(String url) async {
    try {
      await player.stop();
      await player.setUrl(url);
      audioCondition.value = "playing";
      await player.play();
      audioCondition.value = "stop";
      await player.stop();
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
