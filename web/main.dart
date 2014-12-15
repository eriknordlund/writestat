import 'dart:html';

import 'package:writestat/chart.dart';
import 'package:writestat/goal.dart';

class WriteStat {
  Goal      goal;
  Chart chart;

  WriteStat() {
    querySelector('#createGoal').onClick.listen(createGoal);
  }

  createGoal(Event e) {
    InputElement inputGoalStart  = querySelector('#inputGoalStart');
    InputElement inputGoalEnd    = querySelector('#inputGoalEnd');
    InputElement inputGoalAmount = querySelector('#inputGoalAmount');
    if (inputGoalAmount.value.isEmpty) {
      inputGoalAmount.value = '50000';
    }
    DateTime start = DateTime.parse(inputGoalStart.value);
    DateTime end   = DateTime.parse(inputGoalEnd.value);
    int amount     = int.parse(inputGoalAmount.value);

    goal = new Goal(start, end, amount);

    for (var i=1; i<=goal.duration.inDays; i++) {
      createGoalTrackingInputs(i);
    }

    chart = new Chart(goal.duration, goal.amount);

    e.preventDefault();
  }

  createGoalTrackingInputs(day) {
    var goalTrackingForm = querySelector('#goalTrackingForm');

    var formGroup = new DivElement();
    formGroup.classes.add('form-group form-group-sm');
    goalTrackingForm.children.add(formGroup);

    var label = new LabelElement();
    //TODO Create 'for' attribute
    label.text = 'Dag $day';
    label.attributes['for'] = 'goalDay$day';
    label.classes.add('col-sm-4 control-label');
    formGroup.children.add(label);

    var input = new InputElement(type: 'input');
    //TODO Create 'for' attribute
    input.attributes = { 'id': 'goalDay$day', 'type': 'number', 'class': 'form-control' };

    var wrapDiv = new DivElement();
    wrapDiv.classes.add('col-sm-8');
    wrapDiv.children.add(input);
    formGroup.children.add(wrapDiv);

    input.onBlur.listen(recalculateGoal);
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
