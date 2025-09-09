import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldkey;
  bool drawer;
  bool notification;
  bool compaq;
  String title;

  CustomAppBar(
      {super.key,
      required this.scaffoldkey,
      required this.drawer,
      required this.notification,
      required this.compaq,
      required this.title});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize {
    return const Size.fromHeight(56.0);
  }
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
        leading: widget.drawer
            ? InkWell(
                child: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                onTap: () {
                  widget.scaffoldkey.currentState!.openDrawer();
                },
              )
            : InkWell(
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 18,
                ),
                onTap: () {
                  Get.back();
                }),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: Colors.white,
              height: 2.0,
            )),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            widget.compaq
                ? InkWell(
                    onTap: () {},
                    child: SvgPicture.asset(
                      "assets/images/ic_logo.svg",
                      height: 35,
                    ),
                  )
                : Container(),
            widget.title != ''
                ? Container(
                    margin: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Text(
                      widget.title,
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                : Container(),
          ],
        ),
        centerTitle: true,
        titleSpacing: 0.0,
        actions: [
          widget.notification
              ? Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: InkWell(
                    onTap: () {},
                    child: Center(
                      child: Stack(
                        children: [
                          SvgPicture.asset(
                            "assets/images/notification.svg",
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
