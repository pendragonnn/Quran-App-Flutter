import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quran_app/app/constant/color.dart';
import 'package:quran_app/app/data/models/DetailSurah.dart' as detail;
import 'package:quran_app/app/modules/home/controllers/home_controller.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../controllers/detail_surah_controller.dart';

class DetailSurahView extends GetView<DetailSurahController> {
  final homeC = Get.find<HomeController>();
  Map<String, dynamic>? bookmark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SURAH ${Get.arguments["name"].toString().toUpperCase()}',
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<detail.DetailSurah>(
        future: controller.getDetailSurah(Get.arguments["number"].toString()),
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

          if (Get.arguments["bookmark"] != null) {
            bookmark = Get.arguments["bookmark"];
            if (bookmark!["index_ayat"] > 0) {
              print("index ayat: ${bookmark!['index_ayat']}");
              controller.scrollC.scrollToIndex(
                bookmark!["index_ayat"] + 2,
                preferPosition: AutoScrollPosition.begin,
              );
            }
          }
          print(bookmark);

          detail.DetailSurah surah = snapshot.data!;

          List<Widget> allAyat =
              List.generate(snapshot.data?.verses.length ?? 0, (index) {
            detail.Verse? ayat = snapshot.data?.verses?[index];
            return AutoScrollTag(
              key: ValueKey(index + 2),
              index: index + 2,
              controller: controller.scrollC,
              child: Column(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/list.png"),
                                fit: BoxFit.contain,
                              ),
                            ),
                            child: Center(
                              child: Text("${index + 1}"),
                            ),
                          ),
                          GetBuilder<DetailSurahController>(
                            builder: (c) => Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Get.defaultDialog(
                                      title: "Bookmark",
                                      middleText: "Pilih Jenis Bookmark",
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            await c.addBookmark(true,
                                                snapshot.data!, ayat!, index);
                                            homeC.update();
                                          },
                                          child: Text("Last Read"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            c.addBookmark(false, snapshot.data!,
                                                ayat!, index);
                                          },
                                          child: Text("Bookmark"),
                                        ),
                                      ],
                                    );
                                  },
                                  icon: Icon(
                                    Icons.bookmark_add_outlined,
                                  ),
                                ),
                                (ayat!.audioCondition == "stop")
                                    ? IconButton(
                                        onPressed: () {
                                          c.playAudio(ayat);
                                        },
                                        icon: Icon(
                                          Icons.play_arrow,
                                        ),
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          (ayat.audioCondition == "playing")
                                              ? IconButton(
                                                  onPressed: () {
                                                    c.pauseAudio(ayat);
                                                  },
                                                  icon: Icon(
                                                    Icons.pause,
                                                  ),
                                                )
                                              : IconButton(
                                                  onPressed: () {
                                                    c.resumeAudio(ayat);
                                                  },
                                                  icon: Icon(
                                                    Icons.play_arrow,
                                                  ),
                                                ),
                                          IconButton(
                                            onPressed: () {
                                              c.stopAudio(ayat);
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
                    "${ayat!.text.arab}",
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
              ),
            );
          });

          return Padding(
            padding: EdgeInsets.all(20),
            child: ListView(
              controller: controller.scrollC,
              children: [
                AutoScrollTag(
                  key: ValueKey(0),
                  index: 0,
                  controller: controller.scrollC,
                  child: GestureDetector(
                    onTap: () => Get.defaultDialog(
                      backgroundColor:
                          Get.isDarkMode ? appPurpleLight1 : appWhite,
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
                ),
                AutoScrollTag(
                  key: ValueKey(1),
                  index: 1,
                  controller: controller.scrollC,
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                ...allAyat,
              ],
            ),
          );
        },
      ),
    );
  }
}
