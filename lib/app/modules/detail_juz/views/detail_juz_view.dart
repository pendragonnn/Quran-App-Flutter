import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quran_app/app/data/models/DetailSurah.dart' as detail;
import '../../../constant/color.dart';
import '../controllers/detail_juz_controller.dart';

class DetailJuzView extends GetView<DetailJuzController> {
  const DetailJuzView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> dataMapPerJuz = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Juz ${dataMapPerJuz["juz"]}'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(20),
            itemCount: (dataMapPerJuz["verses"] as List).length,
            itemBuilder: (context, index) {
              if (dataMapPerJuz["verses"] == null ||
                  dataMapPerJuz["verses"].length == 0) {
                return Center(
                  child: Text("Tidak ada data"),
                );
              }

              Map<String, dynamic> ayat = dataMapPerJuz["verses"][index];
              detail.DetailSurah surah = ayat["surah"];
              detail.Verse verse = ayat["ayat"];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (verse.number.inSurah == 1)
                    GestureDetector(
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
                        width: Get.width,
                        margin: EdgeInsets.only(bottom: 20),
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
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/list.png"),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                child: Center(
                                  child: Text("${verse.number.inSurah}"),
                                ),
                              ),
                              Text(
                                "${surah.name.transliteration.id}",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 15),
                              ),
                            ],
                          ),
                          GetBuilder<DetailJuzController>(
                            builder: (c) => Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.bookmark_add_outlined,
                                  ),
                                ),
                                (verse.audioCondition == "stop")
                                    ? IconButton(
                                        onPressed: () {
                                          c.playAudio(verse);
                                        },
                                        icon: Icon(
                                          Icons.play_arrow,
                                        ),
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          (verse.audioCondition == "playing")
                                              ? IconButton(
                                                  onPressed: () {
                                                    c.pauseAudio(verse);
                                                  },
                                                  icon: Icon(
                                                    Icons.pause,
                                                  ),
                                                )
                                              : IconButton(
                                                  onPressed: () {
                                                    c.resumeAudio(verse);
                                                  },
                                                  icon: Icon(
                                                    Icons.play_arrow,
                                                  ),
                                                ),
                                          IconButton(
                                            onPressed: () {
                                              c.stopAudio(verse);
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
                    "${(ayat['ayat'] as detail.Verse).text?.arab}",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${(ayat['ayat'] as detail.Verse).text.transliteration.en}",
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
                    "${(ayat['ayat'] as detail.Verse).translation.id}",
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
        ],
      ),
    );
  }
}
