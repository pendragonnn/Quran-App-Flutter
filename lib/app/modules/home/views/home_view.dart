import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quran_app/app/constant/color.dart';
import 'package:quran_app/app/data/models/DetailSurah.dart' as detail;
import 'package:quran_app/app/data/models/Surah.dart';
import 'package:quran_app/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    if (Get.isDarkMode) {
      controller.isDark.value = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Al Quran Apps',
          style: TextStyle(
            color: appWhite,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.SEARCH),
            icon: Icon(
              Icons.search,
              color: appWhite,
            ),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Assalamualaikum",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      appPurpleLight1,
                      appPurpleDark,
                    ],
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () => Get.toNamed(Routes.LAST_READ),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: -50,
                            right: 0,
                            child: Opacity(
                              opacity: 0.6,
                              child: Container(
                                width: 200,
                                height: 200,
                                child: Image.asset(
                                  "assets/images/alquran.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.menu_book_rounded,
                                      color: appWhite,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Terakhir Dibaca",
                                      style: TextStyle(color: appWhite),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  "Al-Fatihah",
                                  style: TextStyle(
                                    color: appWhite,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "Juz 1 | Ayat 5",
                                  style: TextStyle(
                                    color: appWhite,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              TabBar(
                indicatorColor: appPurpleDark,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: "Surah"),
                  Tab(text: "Juz"),
                  Tab(text: "Bookmark"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    FutureBuilder<List<Surah>>(
                      future: controller.getAllSurah(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (!snapshot.hasData) {
                          return Center(
                            child: Text("Tidak ada data"),
                          );
                        }

                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Surah surah = snapshot.data![index];
                            return ListTile(
                              onTap: () {
                                Get.toNamed(Routes.DETAIL_SURAH,
                                    arguments: surah);
                              },
                              leading: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/list.png"),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "${surah.number}",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                surah.name.transliteration.id,
                              ),
                              subtitle: Text(
                                "${surah.numberOfVerses} Ayat | ${surah.revelation.id}",
                                style: TextStyle(
                                  color: Colors.grey[500],
                                ),
                              ),
                              trailing: Text(
                                surah.name.short,
                              ),
                            );
                          },
                        );
                      },
                    ),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: controller.getAllJuz(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (!snapshot.hasData) {
                          return Center(
                            child: Text("Tidak ada data"),
                          );
                        }

                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> dataMapPerJuz =
                                snapshot.data![index];
                            return ListTile(
                              onTap: () {
                                Get.toNamed(Routes.DETAIL_JUZ,
                                    arguments: dataMapPerJuz);
                              },
                              leading: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/list.png"),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "${index + 1}",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                "Juz ${index + 1}",
                              ),
                              isThreeLine: true,
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Mulai dari ${(dataMapPerJuz["start"]["surah"] as detail.DetailSurah).name.transliteration.id} ayat ${(dataMapPerJuz["start"]["ayat"] as detail.Verse).number.inSurah.toString()}",
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  Text(
                                    "Sampai ${(dataMapPerJuz["end"]["surah"] as detail.DetailSurah).name.transliteration.id} ayat ${(dataMapPerJuz["end"]["ayat"] as detail.Verse).number.inSurah.toString()}",
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    Center(
                      child: Text("page 3"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.changeTemeMode(),
        child: Icon(
          Icons.color_lens,
          color: appPurpleLight1,
        ),
      ),
    );
  }
}
