import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quran_app/app/data/models/Juz.dart' as juz;
import 'package:quran_app/app/data/models/Surah.dart';

import '../../../constant/color.dart';
import '../controllers/detail_juz_controller.dart';

class DetailJuzView extends GetView<DetailJuzController> {
  const DetailJuzView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    juz.Juz detailJuz = Get.arguments["juz"];
    List<Surah> allSurahInThisJust = Get.arguments["surah"];
    allSurahInThisJust.forEach((element) {
      print(element.name.transliteration.id);
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Juz ${detailJuz.juz}'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: detailJuz.verses!.length,
        itemBuilder: (context, index) {
          if (detailJuz.verses == null || detailJuz.verses?.length == 0) {
            return Center(
              child: Text("Tidak ada data"),
            );
          }
          juz.Verses ayat = detailJuz.verses![index];
          if (index != 0) {
            if (ayat.number?.inSurah == 1) {
              controller.index++;
            }
          }

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
                              child: Text("${ayat.number?.inSurah}"),
                            ),
                          ),
                          Text(
                            allSurahInThisJust[controller.index]
                                .name
                                .transliteration
                                .id,
                            style: TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 15),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.bookmark_add_outlined,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.play_arrow,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "${ayat.text?.arab}",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "${ayat.text!.transliteration?.en}",
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
                "${ayat.translation!.id}",
                textAlign: TextAlign.justify,
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
  }
}
