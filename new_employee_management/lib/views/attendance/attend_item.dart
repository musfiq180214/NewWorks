import 'package:employee_management/utils/timeFormatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AttendanceItem extends StatefulWidget {
  final dynamic item;
  final int index;

  const AttendanceItem({required this.item, required this.index, super.key});

  @override
  State<AttendanceItem> createState() => _AttendanceItemState();
}

class _AttendanceItemState extends State<AttendanceItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.grey.shade100,
          border: Border.all(width: 1, color: Colors.grey.shade300)),
      margin: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(5, 20, 10, 20),
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 1, color: Colors.black)),
            alignment: Alignment.center,
            width: 40,
            child: Text(
              (widget.index + 1).toString(),
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  widget.item.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: SvgPicture.asset(
                          'assets/images/out.svg',
                          colorFilter: ColorFilter.mode(
                            Colors.green[900]!,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.only(left: 2),
                          width: MediaQuery.of(context).size.width * .18,
                          child: widget.item.inTime != '-'
                              ? Text(
                                  TimeFormatter()
                                      .returnDate(widget.item.inTime),
                                  style: TextStyle(
                                      color: TimeFormatter().inTimeColor(
                                              TimeFormatter().returnDate(
                                                  widget.item.inTime))
                                          ? const Color(0xFFB00020)
                                          : Colors.black),
                                )
                              : const Text('-'))
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: SvgPicture.asset(
                          'assets/images/in.svg',
                          colorFilter: const ColorFilter.mode(
                            Color(0xFFB00020),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.only(left: 2),
                          width: MediaQuery.of(context).size.width * .18,
                          child: widget.item.outTime != '-'
                              ? Text(
                                  TimeFormatter()
                                      .returnDate(widget.item.outTime),
                                  style: TextStyle(
                                      color: TimeFormatter().outTimeColor(
                                              TimeFormatter().returnDate(
                                                  widget.item.outTime))
                                          ? const Color(0xFFB00020)
                                          : Colors.black),
                                )
                              : const Text('-'))
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        width: 20,
                        height: 20,
                        child: SvgPicture.asset(
                          'assets/images/duration.svg',
                          colorFilter: ColorFilter.mode(
                            Colors.blue[900]!,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.only(left: 2),
                          width: MediaQuery.of(context).size.width * .18,
                          child: widget.item.duration != '-'
                              ? Text(
                                  TimeFormatter()
                                      .durationFormatter(widget.item.duration),
                                  style: TextStyle(
                                      color: TimeFormatter()
                                              .avgColor(widget.item.duration)
                                          ? const Color(0xFFB00020)
                                          : Colors.black))
                              : const Text('-'))
                    ],
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
