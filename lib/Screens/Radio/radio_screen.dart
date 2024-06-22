import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_radio_player/flutter_radio_player.dart';
import 'package:flutter_radio_player/models/frp_source_modal.dart';

Future<void> initRadioService() async {
  FlutterRadioPlayer flutterRadioPlayer = FlutterRadioPlayer();

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

class RadioScreen extends StatefulWidget {
  const RadioScreen({Key? key}) : super(key: key);

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  bool isPlay = false;
  bool isRewind = false;
  bool isForward = false;

  @override
  void initState() {
    initRadioService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Center(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 200,
                      width: 200,
                      // padding: EdgeInsets.all(8),
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/radio/yuwave_logo.jpg'),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Yuwave Radio",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Spacer(),
                    Icon(
                      Icons.favorite_outlined,
                      size: 25,
                    ),
                    SizedBox(width: 30),
                    Icon(
                      Icons.share,
                      size: 25,
                    ),
                    SizedBox(width: 30),
                    Icon(
                      Icons.shop_2_outlined,
                      size: 25,
                    ),
                    Spacer(),
                  ],
                )
              ],
            ),
            Container(
              height: 60,
              width: size.width * 0.75,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black54,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isRewind = !isRewind;
                        isRewind == true ? isPlay = false : isPlay = true;
                      });
                    },
                    child: isRewind == false
                        ? Icon(Icons.fast_rewind_outlined)
                        : Icon(Icons.fast_rewind),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isPlay = !isPlay;
                      });
                    },
                    child: isPlay == false
                        ? Icon(
                            Icons.play_arrow,
                            size: 40,
                          )
                        : Icon(
                            Icons.pause,
                            size: 40,
                          ),
                  ),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          isForward = !isForward;
                          isForward == true ? isPlay = false : isPlay = true;
                        });
                      },
                      child: isForward == false
                          ? Icon(Icons.fast_forward_outlined)
                          : Icon(Icons.fast_forward)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
