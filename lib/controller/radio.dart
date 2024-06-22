import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_radio_player/flutter_radio_player.dart';
import 'package:flutter_radio_player/models/frp_source_modal.dart';
import 'package:get/get.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

class RadioController extends GetxController {
  static RadioController get to => Get.put(RadioController());

  PanelController? panelController;
  TabController? tabController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? currentBackPressedTime;

  FlutterRadioPlayer flutterRadioPlayer = FlutterRadioPlayer();

  int currentIndex = 0;
  double volume = 0.8;

  var _data = "".obs;

  get data => _data.value;

  set data(value) {
    _data.value = "$value";
  }

  onWillBack() async {
    if (panelController!.isPanelClosed) {
      panelController!.close();
      return Future<bool>.value(false);
    } else if (scaffoldKey.currentState!.isDrawerOpen) {
      Get.back();
      return Future<bool>.value(false);
    } else {
      var now = DateTime.now();
      if (currentBackPressedTime == null ||
          now.difference(currentBackPressedTime!) >
              const Duration(seconds: 2)) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          content: const Text(
            "Double tap tp exit app",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
        ));
        return Future.value(false);
      }
      dispose();
      return Future.value(true);
    }
  }

  Future<void> initRadioService() async {
    try {
      flutterRadioPlayer.initPlayer();

      final FRPSource frpSource = FRPSource(
        mediaSources: <MediaSources>[
          MediaSources(
              url: "http://209.133.216.3:7018/;stream.mp3", // dummy url
              description: "Flutter Radio Example",
              isPrimary: false,
              title: "Flutter Radio Example",
              isAac: true),
        ],
      );
    } on PlatformException {
      print("Exception occurred while trying to register the services.");
    }
  }
}
