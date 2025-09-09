// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmployeeItem extends StatefulWidget {
  dynamic item;

  EmployeeItem({required this.item, super.key});

  @override
  State<EmployeeItem> createState() => _EmployeeItemState();
}

class _EmployeeItemState extends State<EmployeeItem> {
  var fname = '';
  var lname = '';
  var afname = '';
  var alname = '';
  String getInitial() {
    fname = widget.item.name.split(' ').first;
    if (widget.item.name.split(' ').last != null) {
      lname = widget.item.name.split(' ').last;
    } else {
      lname = '';
    }
    afname = fname[0].toUpperCase();
    alname = lname[0].toUpperCase();

    return afname + alname;
  }

  @override
  void initState() {
    getInitial();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey.shade100,
            border: Border.all(width: 1, color: Colors.grey.shade300)),
        margin: const EdgeInsets.symmetric(
          vertical: 6,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.black,
                  child: Text(
                    getInitial(),
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 200,
                      child: Text(
                        widget.item.name,
                        maxLines: 2,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Text(widget.item.designation,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[400])),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ],
            ),
            SvgPicture.asset(
              'assets/images/rightarrow.svg',
              width: 10,
              height: 14,
            )
          ],
        ));
  }
}
