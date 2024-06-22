import 'package:tune_360/CustomWidgets/gradient_containers.dart';
import 'package:tune_360/Helpers/backup_restore.dart';
import 'package:tune_360/Helpers/config.dart';
import 'package:tune_360/Helpers/supabase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController controller = TextEditingController();
  final key = GlobalKey<FormState>();
  Uuid uuid = const Uuid();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future _addUserData(String name) async {
    await Hive.box('settings').put('name', name.trim());
    // final DateTime now = DateTime.now();
    // final List createDate = now
    //     .toUtc()
    //     .add(const Duration(hours: 5, minutes: 30))
    //     .toString()
    //     .split('.')
    //   ..removeLast()
    //   ..join('.');

    final String userId = uuid.v1();
    print("id is $userId");
    // await SupaBase().createUser({
    //   'id': userId,
    //   'name': name,
    //   'accountCreatedOn': '${createDate[0]} IST',
    //   'timeZone':
    //       "Zone: ${now.timeZoneName} Offset: ${now.timeZoneOffset.toString().replaceAll('.000000', '')}",
    // });
    await Hive.box('settings').put('userId', userId);
  }

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      opacity: true,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                left: 50,
                right: 50,
                top: 60,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.width / 2,
                  child: const Image(
                    image: AssetImage(
                      'assets/logo.png',
                    ),
                  ),
                ),
              ),
              // const GradientContainer(
              //   child: null,
              //   opacity: true,
              // ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          await restore(context);
                          GetIt.I<MyTheme>().refresh();
                          Navigator.popAndPushNamed(context, '/');
                        },
                        child: Text(
                          AppLocalizations.of(context)!.restore,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await _addUserData(
                            AppLocalizations.of(context)!.guest,
                          );
                          Navigator.popAndPushNamed(context, '/pref');
                        },
                        child: Text(
                          AppLocalizations.of(context)!.skip,
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0,top: 15),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Tune 360',
                                  style: TextStyle(
                                    height: 0.10,
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                            Column(
                              children: [
                                Form(
                                  key: key,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      top: 5,
                                      bottom: 5,
                                      left: 10,
                                      right: 10,
                                    ),
                                    height: 57.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.grey[900],
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 5.0,
                                          offset: Offset(0.0, 3.0),
                                        )
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: controller,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      keyboardType: TextInputType.name,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        focusedBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1.5,
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                        border: InputBorder.none,
                                        hintText: AppLocalizations.of(context)!
                                            .enterName,
                                        hintStyle: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      validator: (data) {
                                        if (data == null ||
                                            data == '' ||
                                            data.isEmpty) {
                                          return 'Please enter your name';
                                        } else if (data.length < 3) {
                                          return 'Name atleast 3 character';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (key.currentState!.validate()) {
                                      await _addUserData(
                                        controller.text.trim(),
                                      );
                                      Navigator.popAndPushNamed(
                                          context, '/pref');
                                    } else {
                                      // await _addUserData('Guest');
                                      // Navigator.popAndPushNamed(
                                      //     context, '/pref');
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                    ),
                                    height: 55.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 5.0,
                                          offset: Offset(0.0, 3.0),
                                        )
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .getStarted,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20.0,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .disclaimer,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .disclaimerText,
                                        style: TextStyle(
                                          color: Colors.grey.withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
