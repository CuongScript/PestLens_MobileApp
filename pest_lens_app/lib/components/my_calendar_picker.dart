import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MyCalendarPicker extends StatefulWidget {
  final Function(DateTimeRange?) onDateRangeSelected;
  final VoidCallback onDefaultModeSelected;
  final DateTimeRange? initialDateRange;

  const MyCalendarPicker({
    super.key,
    required this.onDateRangeSelected,
    required this.onDefaultModeSelected,
    this.initialDateRange,
  });

  @override
  _MyCalendarPickerState createState() => _MyCalendarPickerState();
}

class _MyCalendarPickerState extends State<MyCalendarPicker> {
  DateTimeRange? selectedRange;
  late DateRangePickerController _datePickerController;
  @override
  void initState() {
    super.initState();
    selectedRange = widget.initialDateRange;
    _datePickerController = DateRangePickerController();
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      final range = args.value as PickerDateRange;
      final start = range.startDate!;
      final end = range.endDate ?? start;

      if (end.difference(start).inDays > 30) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please select a range of 30 days or less')),
        );
        return;
      }
      setState(() {
        selectedRange = DateTimeRange(
          start: range.startDate!,
          end: range.endDate ?? range.startDate!,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text(
                'Select Date Range',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  DateTime sd =
                      DateTime.now().subtract(const Duration(days: 3));
                  DateTime ed = DateTime(DateTime.now().year,
                      DateTime.now().month, DateTime.now().day, 23, 59, 59);

                  setState(() {
                    _datePickerController.selectedRange =
                        PickerDateRange(sd, ed);

                    selectedRange = DateTimeRange(
                      start: sd,
                      end: ed,
                    );
                  });
                },
                tooltip: 'Set to Current Date',
              )
            ]),
            const SizedBox(height: 16),
            SfDateRangePicker(
              controller: _datePickerController,
              selectionMode: DateRangePickerSelectionMode.range,
              onSelectionChanged: _onSelectionChanged,
              maxDate: DateTime.now(),
              initialSelectedRange: PickerDateRange(
                selectedRange?.start,
                selectedRange?.end,
              ),
              selectionColor: Colors.blue,
              startRangeSelectionColor: Colors.blue,
              endRangeSelectionColor: Colors.blue,
              rangeSelectionColor: Colors.blue.withOpacity(0.1),
              backgroundColor: Colors.white,
              monthCellStyle: const DateRangePickerMonthCellStyle(
                textStyle: TextStyle(fontSize: 18),
                todayTextStyle: TextStyle(fontSize: 18),
              ),
              yearCellStyle: const DateRangePickerYearCellStyle(
                textStyle: TextStyle(fontSize: 18),
                todayTextStyle: TextStyle(fontSize: 18),
              ),
              headerStyle: const DateRangePickerHeaderStyle(
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                backgroundColor:
                    Color.fromARGB(255, 237, 237, 237), // Light gray background
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onDateRangeSelected(selectedRange);
                      Navigator.pop(context);
                    },
                    child: const Text('Confirm'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
