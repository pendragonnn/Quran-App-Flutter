import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quran_app/app/constant/color.dart';
import 'package:quran_app/app/data/models/DetailSurah.dart' as detail;
import 'package:quran_app/app/data/models/Surah.dart';

import '../controllers/detail_surah_controller.dart';

class DetailSurahView extends GetView<DetailSurahController> {
  final Surah surah = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SURAH ${surah.name.transliteration.id.toUpperCase()}',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            GestureDetector(
              onTap: () => Get.defaultDialog(
                backgroundColor: Get.isDarkMode ? appPurpleLight1 : appWhite,
                titlePadding: EdgeInsets.only(
                  top: 30,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                title: "Tafsir ${surah.name.transliteration.id}",
                titleStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                content: Container(
                  child: Text(
                    surah.tafsir.id,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      appPurpleLight1,
                      appPurpleDark,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        "${surah.name.transliteration.id.toUpperCase()}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: appWhite,
                        ),
                      ),
                      Text(
                        "(${surah.name.translation.id})",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: appWhite,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${surah.numberOfVerses} Ayat | ${surah.revelation.id}",
                        style: TextStyle(
                          fontSize: 16,
                          color: appWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            FutureBuilder<detail.DetailSurah>(
              future: controller.getDetailSurah(surah.number.toString()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData) {
                  return Center(
                    child: Text("Tidak ada data"),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data?.verses.length ?? 0,
                    itemBuilder: (context, index) {
                      if (snapshot.data!.verses.length == 0) {
                        return SizedBox();
                      }

                      detail.Verse ayat = snapshot.data!.verses[index];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: appPurpleLight1.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/list.png"),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text("${index + 1}"),
                                    ),
                                  ),
                                  Obx(
                                    () => Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.bookmark_add_outlined,
                                          ),
                                        ),
                                        (controller.audioCondition.value ==
                                                "stop")
                                            ? IconButton(
                                                onPressed: () {
                                                  controller.playAudio(
                                                      ayat.audio.primary);
                                                },
                                                icon: Icon(
                                                  Icons.play_arrow,
                                                ),
                                              )
                                            : Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  (controller.audioCondition
                                                              .value ==
                                                          "playing")
                                                      ? IconButton(
                                                          onPressed: () {
                                                            controller
                                                                .pauseAudio();
                                                          },
                                                          icon: Icon(
                                                            Icons.pause,
                                                          ),
                                                        )
                                                      : IconButton(
                                                          onPressed: () {
                                                            controller
                                                                .resumeAudio();
                                                          },
                                                          icon: Icon(
                                                            Icons.play_arrow,
                                                          ),
                                                        ),
                                                  IconButton(
                                                    onPressed: () {
                                                      controller.stopAudio();
                                                    },
                                                    icon: Icon(
                                                      Icons.stop,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "${ayat.text.arab}",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${ayat.text.transliteration.en}",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            "${ayat.translation.id}",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
