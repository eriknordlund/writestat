import 'dart:html';

import 'package:intl/intl.dart';
import 'package:writestat/chart.dart';
import 'package:writestat/goal.dart';

class WriteStat {
  Goal goal;
  Chart chart;

  WriteStat() {
    loadGoal();

    // TODO Refactor together with createGoal. Handle DOM stuff in Goal?
    createGoalTrackingInputs();
    chart = new Chart(goal.duration, goal.amount);
    chart.progress = goal.progress;
    // TODO Render should be done implicit
    chart.render();

    querySelector('#submitGoal').onClick.listen(createGoal);
  }

  createGoal(Event e) {
    InputElement inputGoalStart = querySelector('#inputGoalStart');
    InputElement inputGoalEnd = querySelector('#inputGoalEnd');
    InputElement inputGoalAmount = querySelector('#inputGoalAmount');
    if (inputGoalAmount.value.isEmpty) {
      inputGoalAmount.value = '50000';
    }

    goal = new Goal(inputGoalStart.value, inputGoalEnd.value, inputGoalAmount.value);
    goal.save();

    createGoalTrackingInputs();
    chart = new Chart(goal.duration, goal.amount);

    e.preventDefault();
  }

  createGoalTrackingInputs() {
    var goalTrackingForm = querySelector('#goalTrackingForm');
    goalTrackingForm.children.clear();

    for (var i = 1; i <= goal.duration.inDays; i++) {
      var formGroup = new DivElement();
      formGroup.classes.add('form-group form-group-sm');
      goalTrackingForm.children.add(formGroup);

      var label = new LabelElement();
      label.text = 'Dag $i';
      label.classes.add('col-sm-4 control-label');
      label.attributes['for'] = 'goalDay$i';
      formGroup.children.add(label);

      var input = new InputElement(type: 'input');
      input.classes.add('form-control');
      input.id = 'goalDay$i';
      input.value = goal.progress.elementAt(i-1).toString();

      var wrapDiv = new DivElement();
      wrapDiv.classes.add('col-sm-8');
      wrapDiv.children.add(input);
      formGroup.children.add(wrapDiv);

      input.onBlur.listen((event) {
        goal.progress[i-1] = int.parse(input.value);
        recalculateGoal(event);
        goal.save();
      });
    }
  }

  loadGoal() {
    var formatter = new DateFormat('yyyy-MM-dd');
    goal = Goal.load();
    InputElement inputGoalStart = querySelector('#inputGoalStart');
    InputElement inputGoalEnd = querySelector('#inputGoalEnd');
    InputElement inputGoalAmount = querySelector('#inputGoalAmount');
    inputGoalStart.value  = formatter.format(goal.start);
    inputGoalEnd.value    = formatter.format(goal.end);
    inputGoalAmount.value = goal.amount.toString();
  }

  recalculateGoal(Event e) {
    var values = [];
    var inputs = querySelectorAll('#goalTrackingForm input');
    for (var input in inputs) {
      if (!input.value.isEmpty) {
        values.add(int.parse(input.value));
      }
    }
    chart.progress = values;
    // TODO Render should be done implicit
    chart.render();
  }
}

void main() {
  WriteStat writeStat = new WriteStat();
}
