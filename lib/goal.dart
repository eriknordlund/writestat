library goal;

import 'dart:collection';
import 'dart:html';

class Goal {
  DateTime start;
  DateTime end;
  int      amount;
  Duration duration;
  List<int> progress;

  Goal(String start, String end, String amount) {
    this.start  = DateTime.parse(start);
    this.end    = DateTime.parse(end);
    this.amount = int.parse(amount);

    // subtract() includes the chosen start day in the goal
    duration = this.end.difference(this.start.subtract(new Duration(days: 1)));
    progress = new List.generate(duration.inDays, (int index) => 0);
  }

  void save() {
    window.localStorage['start']    = start.toIso8601String();
    window.localStorage['end']      = end.toIso8601String();
    window.localStorage['amount']   = amount.toString();
    window.localStorage['progress'] = progress.join(',');
  }

  static Goal load() {
    var start = new DateTime.now().toString();
    var end = new DateTime.now().add(new Duration(days: 7)).toString();
    var amount = '50000';
    var progress = new List.generate(new Duration(days: 7).inDays, (int index) => 0);
    Goal goal;

    if (window.localStorage.containsKey('start') && window.localStorage['start'].isNotEmpty) {
      start = window.localStorage['start'];
    }

    if (window.localStorage.containsKey('end') && window.localStorage['end'].isNotEmpty) {
      end = window.localStorage['end'];
    }

    if (window.localStorage.containsKey('amount') && window.localStorage['amount'].isNotEmpty) {
      amount = window.localStorage['amount'];
    }

    if (window.localStorage.containsKey('progress') && window.localStorage['progress'].isNotEmpty) {
      progress.clear();
      for (var value in window.localStorage['progress'].split(',')) {
        progress.add(int.parse(value));
      }
    }

    goal = new Goal(start, end, amount);
    goal.progress = progress;
    return goal;
  }
}