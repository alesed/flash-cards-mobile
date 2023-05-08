import 'package:flashcards/features/sets/models/accessibility.dart';
import 'package:flashcards/features/sets/models/card_set_model.dart';
import 'package:flashcards/features/sets/services/sets_manager_service.dart';
import 'package:flashcards/features/statistics/models/sorting.dart';
import 'package:flutter/material.dart';

import '../../../locator.dart';
import '../../sets/models/sets_filter.dart';

class StatisticsList extends StatefulWidget {
  const StatisticsList({super.key});

  @override
  State<StatisticsList> createState() => _StatisticsListState();
}

class _StatisticsListState extends State<StatisticsList> {
  Sorting _sorting = Sorting.playsCounter;

  @override
  Widget build(BuildContext context) {
    final setsService = getIt<SetsManagerService>();
    final publicSetsStream = setsService.getFilteredSetsStream(
      SetsFilter(
        accessibility: Accessibility.public,
        justOwn: false,
      ),
    );

    return Column(
      children: [
        _buildSortingByType(),
        StreamBuilder(
            stream: publicSetsStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Err: ${snapshot.error.toString()}");
              }
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              final setList = _getByDescendingOrder(snapshot.data!);
              return Expanded(
                child: ListView.separated(
                    separatorBuilder: (_, index) => Divider(),
                    itemCount: setList.length,
                    itemBuilder: (_, index) => Card(
                          child: ListTile(
                            title: Text(setList[index].setName),
                            trailing: Text(_getTrailingText(
                              _sorting == Sorting.playsCounter
                                  ? setList[index].playsCounter.toString()
                                  : setList[index].successRate.toString(),
                              _sorting,
                            )),
                          ),
                        )),
              );
            }),
      ],
    );
  }

  List<CardSetModel> _getByDescendingOrder(List<CardSetModel> data) {
    if (_sorting == Sorting.playsCounter) {
      return data..sort((a, b) => b.playsCounter.compareTo(a.playsCounter));
    }
    return data..sort((a, b) => b.successRate.compareTo(a.successRate));
  }

  DropdownButton<Sorting> _buildSortingByType() {
    return DropdownButton<Sorting>(
      value: _sorting,
      onChanged: (value) {
        setState(() {
          _sorting = value!;
        });
      },
      items: Sorting.values
          .map<DropdownMenuItem<Sorting>>((value) => DropdownMenuItem<Sorting>(
                value: value,
                child: Text(_translateSortingName(value)),
              ))
          .toList(),
    );
  }

  String _getTrailingText(String value, Sorting sorting) {
    if (sorting == Sorting.playsCounter) {
      return "$value plays";
    }
    final successRate = double.parse(value);
    if (successRate < 0) {
      return "N/A";
    }
    return "${(successRate * 100).toStringAsFixed(2)}%";
  }

  String _translateSortingName(Sorting value) {
    return value == Sorting.playsCounter ? "Plays counter" : "Success rate";
  }
}
