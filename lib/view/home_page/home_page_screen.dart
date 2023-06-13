import 'package:backdrop/backdrop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/app_constants.dart';
import '../../utils/palette.dart';
import '../chat/chat_room_screen.dart';
import 'home_page_content_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.loggedInUser}) : super(key: key);
  final String loggedInUser;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // late String loggedInUser;

  // Future<void> getData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //  loggedInUser = prefs.getString('logged').toString();
  // }
  @override
  initState() {
    super.initState();
    // getData();
  }

  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomeContent(),
    const HomeContent(),
    const HomeContent(),
    const HomeContent(),
  ];
  final List<Widget> _pagesGuest = [
    const HomeContent(),
    const HomeContent(),
    const HomeContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hera',
      darkTheme: ThemeData(
        appBarTheme:
            const AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
        scaffoldBackgroundColor: AppConstants.xiketik,
        backgroundColor: AppConstants.xiketik,
        primarySwatch: Palette.kPink,
        primaryColor: AppConstants.pastelePink,
        textTheme: TextThemes.darkTextTheme,
      ),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: AppConstants.black)),
        scaffoldBackgroundColor: AppConstants.snow,
        backgroundColor: AppConstants.snow,
        primarySwatch: Palette.kPink,
        primaryColor: AppConstants.pastelePink,
        textTheme: TextThemes.lightTextTheme,
      ),
      home: BackdropScaffold(
        // bottomNavigationBar: BottomAppBar(
        //   color: Color(0xFFF9D9DA),
        //   child: TextButton(
        //     onPressed: () {},
        //     child: Shimmer.fromColors(
        //       baseColor: Color(0xFF2C2E3C),
        //       highlightColor: Color(0xFFFFF6F7),
        //       child: Row(
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //         children: [
        //           Icon(
        //             Icons.camera,
        //             color: Color(0xFFFAE2E2),
        //             size: 35,
        //           ),
        //           Text(
        //             'Try Our Filters',
        //             style: TextStyle(
        //               color: Colors.white,
        //               fontSize: 35,
        //               fontWeight: FontWeight.bold,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     style: TextButton.styleFrom(
        //       primary: Colors.transparent,
        //       elevation: 0,
        //       shadowColor: Colors.transparent,
        //     ),
        //   ),
        // ),
        //backgroundColor:Color(0xFF2C2E3C),
        backLayerBackgroundColor: AppConstants.spanishPink,
        backLayerScrim: Colors.black54,
        frontLayerScrim: Colors.black54,
        drawerScrimColor: Colors.black54,

        appBar: BackdropAppBar(
          actionsIconTheme: const IconThemeData(color: Color(0xFF2C2E3C)),
          iconTheme: const IconThemeData(color: Color(0xFF2C2E3C)),
          backgroundColor: AppConstants.spanishPink,
          centerTitle: true,
          title: const Text(
            "<HERA>",
            style: TextStyle(
                fontFamily: 'Hujan',
                // fontWeight: FontWeight.bold,
                fontSize: 35,
                color: AppConstants.black),
          ),
          actions: <Widget>[
            widget.loggedInUser == 'user'
                ? Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const ChatRoomPage()));
                        },
                        icon: const Icon(
                          CupertinoIcons.chat_bubble_2,
                          size: 27,
                          color: Color(0xFF2C2E3C),
                        )),
                  )
                : const SizedBox(),
            widget.loggedInUser == 'user'
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.search,
                          color: Color(0xFF2C2E3C),
                        )),
                  )
                : const SizedBox(),
          ],
        ),

        stickyFrontLayer: true,
        frontLayer: widget.loggedInUser == 'user'
            ? _pages[_currentIndex]
            : _pagesGuest[_currentIndex],
        backLayer: BackdropNavigationBackLayer(
          itemPadding: const EdgeInsets.all(8),
          items: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: SizedBox(
                  height: 115,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.loggedInUser == 'user'
                        ? AppConstants.screens.length
                        : AppConstants.screensGuest.length,
                    itemBuilder: (context, index) => buildScreens(index),
                  ),
                ),
              ),
            ),
          ],
          onTap: (int position) => {setState(() => _currentIndex = position)},
        ),
      ),
    );
  }

  Widget buildScreens(int index) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          _currentIndex = index;

          print('selected' + _currentIndex.toString());
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color:
                    _currentIndex == index ? AppConstants.black : Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.5),
                //     spreadRadius: 3,
                //     blurRadius: 7,
                //     offset: Offset(0, 3), // changes position of shadow
                //   ),
                // ],
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(
                widget.loggedInUser == 'user'
                    ? AppConstants.screens[index]
                    : AppConstants.screensGuest[index],
                color:
                    _currentIndex == index ? Colors.white : AppConstants.black,
                size: 30,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                widget.loggedInUser == 'user'
                    ? AppConstants.screenTxt[index]
                    : AppConstants.screenTxtGuest[index],
                style: const TextStyle(
                    fontFamily: 'Manrope',
                    color: Color(0xFF2C2E3C),
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
