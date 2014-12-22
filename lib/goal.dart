library goal;

import 'package:writestat/storage.dart';

class Goal {
  DateTime  start;
  DateTime  end;
  int       amount;
  Duration  duration;
  List<int> progress;

  Goal.loadOrCreate() {
    var start, end, amount;

    if (Storage.hasKey('start')) {
      start = Storage.get('start');
    } else {
      start = new DateTime.now().toString();
    }

    if (Storage.hasKey('end')) {
      end = Storage.get('end');
    } else {
      end = new DateTime.now().add(new Duration(days: 7)).toString();
    }

    if (Storage.hasKey('amount')) {
      amount = Storage.get('amount');
    } else {
      amount = 50000;
    }

    update(start, end, amount);

    // TODO Can we do this without looping?
    if (Storage.hasKey('progress')) {
      progress = new List<int>();
      for (var value in Storage.get('progress').split(',')) {
        progress.add(int.parse(value));
      }
    } else {
      progress = new List.filled(8, 0);
    }
  }

  save() {
    if (start != null) {
      Storage.set('start', start.toIso8601String());
    }
    if (end != null) {
      Storage.set('end', end.toIso8601String());
    }
    if (amount != null) {
      Storage.set('amount', amount.toString());
    }
    if (progress != null) {
      Storage.set('progress', progress.join(','));
    }
  }

  update(String start, String end, String amount) {
    this.start = DateTime.parse(start);
    this.end = DateTime.parse(end);
    this.amount = int.parse(amount);

    _updateDuration();
    _updateProgress();
  }

  void _updateDuration() {
    duration = null;
    if (start != null && end != null) {
      // subtract() includes the chosen start day in the goal
      duration = end.difference(start.subtract(new Duration(days: 1)));
    }
  }

  void _updateProgress() {
    if (duration == null) {
      progress = null;
      return;
    }

    var oldProgress = progress;
    progress = new List<int>.generate(duration.inDays, (x) => 0);

    if (oldProgress != null) {
      for (var i=0; i<progress.length && i<oldProgress.length; i++) {
        progress[i] = oldProgress[i];
      }
    }
  }
}