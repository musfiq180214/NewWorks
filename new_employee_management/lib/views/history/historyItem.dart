import 'package:employee_management/utils/timeFormatter.dart';
import 'package:flutter/material.dart';

class HistoryItem extends StatefulWidget {
  dynamic item;

  HistoryItem({required this.item, super.key});

  @override
  State<HistoryItem> createState() => _HistoryItemState();
}

class _HistoryItemState extends State<HistoryItem> {
  var date = '';
  String getDate(String day) {
    date = day.split('-').first;
    return date;
  }

  @override
  void initState() {
    getDate(widget.item.date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 90,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey.shade100,
            border: Border.all(width: 1, color: Colors.grey.shade400)),
        margin: const EdgeInsets.symmetric(
          vertical: 5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.black)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'DATE',
                      style: TextStyle(fontSize: 16, color: Color(0xFFC0C0C0)),
                    ),
                    Text(
                      getDate(widget.item.date),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'IN TIME',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  widget.item.inTime != '-'
                      ? Text(
                          TimeFormatter().returnDate(widget.item.inTime),
                          style: TextStyle(
                              color: TimeFormatter()
                                      .inTimeColor(widget.item.inTime)
                                  ? const Color(0xFFB00020)
                                  : Colors.black),
                        )
                      : const Text('-')
                ],
              ),
            ),
            Container(
              height: 55,
              width: 1,
              color: Colors.grey[400],
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'OUT TIME',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  widget.item.outTime != '-'
                      ? Text(
                          TimeFormatter().returnDate(widget.item.outTime),
                          style: TextStyle(
                              color: TimeFormatter()
                                      .outTimeColor(widget.item.outTime)
                                  ? const Color(0xFFB00020)
                                  : Colors.black),
                        )
                      : const Text('-')
                ],
              ),
            ),
            Container(
              height: 55,
              width: 1,
              color: Colors.grey[400],
            ),
            Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'DURATION',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  widget.item.duration != '-'
                      ? Text(
                          TimeFormatter()
                              .durationFormatter(widget.item.duration),
                          style: TextStyle(
                              color:
                                  TimeFormatter().avgColor(widget.item.duration)
                                      ? const Color(0xFFB00020)
                                      : Colors.black))
                      : const Text('-')
                ],
              ),
            )
          ],
        ));
  }
}
