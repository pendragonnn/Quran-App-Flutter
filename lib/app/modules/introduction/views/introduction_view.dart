import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:quran_app/app/constant/color.dart';
import 'package:quran_app/app/routes/app_pages.dart';

import '../controllers/introduction_controller.dart';

class IntroductionView extends GetView<IntroductionController> {
  const IntroductionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Al-Quran Apps",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
              ),
              child: Text(
                "Sesibuk itukah kamu sampai belum membaca al-quran",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 300,
              height: 300,
              child: Lottie.asset(
                "assets/lotties/animasi-quran.json",
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () => Get.offAllNamed(Routes.HOME),
              child: Text(
                "Get Started",
                style: TextStyle(
                  color: Get.isDarkMode ? appPurpleDark : appWhite,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Get.isDarkMode ? appWhite : appPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
