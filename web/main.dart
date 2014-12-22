import 'dart:html';

import 'package:intl/intl.dart';
import 'package:writestat/chart.dart';
import 'package:writestat/goal.dart';

class WriteStat {
  Goal goal;
  Chart chart = new Chart();

  WriteStat() {
    loadOrCreateGoal();

    inputGoalAmount().onBlur.listen(updateGoal);
    inputGoalStart().onBlur.listen(updateGoal);
    inputGoalEnd().onBlur.listen(updateGoal);
  }

  loadOrCreateGoal() {
    var formatter = new DateFormat('yyyy-MM-dd');
    goal = new Goal.loadOrCreate();
    inputGoalAmount().value = goal.amount.toString();
    inputGoalStart().value = formatter.format(goal.start);
    inputGoalEnd().value = formatter.format(goal.end);

    updateGoalTrackers();
    chart.setIdealProgress(goal.amount, goal.duration);
    chart.setActualProgress(goal.progress);
  }

  updateGoal(Event e) {
    String start  = inputGoalStart().value;
    String end    = inputGoalEnd().value;
    String amount = inputGoalAmount().value;
    goal.update(start, end, amount);
    goal.save();

    updateGoalTrackers();
    chart.setIdealProgress(goal.amount, goal.duration);
  }

  updateGoalTrackers() {
    goalTrackersForm().children.clear();

    for (var i=0; i<goal.duration.inDays; i++) {
      var id = i+1;

      var formGroup = new DivElement()
        ..classes.add('form-group form-group-sm');

      var label = new LabelElement()
        ..text = 'Dag $id'
        ..classes.add('col-sm-4 control-label')
        ..attributes['for'] = 'goalDay$id';

      var input = new InputElement(type: 'input')
        ..classes.add('form-control')
        ..id = 'goalDay$id'
        ..value = goal.progress.elementAt(i).toString();

      var wrapDiv = new DivElement()
        ..classes.add('col-sm-8')
        ..children.add(input);

      formGroup.children.add(label);
      formGroup.children.add(wrapDiv);
      goalTrackersForm().children.add(formGroup);

      input.onBlur.listen((event) {
        goal.progress[i] = int.parse(input.value);
        goal.save();
        chart.setActualProgress(goal.progress);
      });
    }
  }

  FormElement goalTrackersForm() {
    return querySelector('#goalTrackersForm');
  }

  InputElement inputGoalAmount() {
    return querySelector('#inputGoalAmount');
  }

  InputElement inputGoalStart() {
    return querySelector('#inputGoalStart');
  }

  InputElement inputGoalEnd() {
    return querySelector('#inputGoalEnd');
  }
}

void main() {
  WriteStat writeStat = new WriteStat();
}
