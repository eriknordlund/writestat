import 'dart:html';

import 'package:writestat/chart.dart';

class WriteStat {
  int      goal;
  DateTime goalStart;
  DateTime goalEnd;
  Duration goalDuration;
  GoalChart chart;

  WriteStat() {
    querySelector('#createGoal').onClick.listen(createGoal);
  }

  createGoal(Event e) {
    var inputGoal      = querySelector('#inputGoal');
    var inputStartDate = querySelector('#inputStartDate');
    var inputEndDate   = querySelector('#inputEndDate');
    if (inputGoal.value.isEmpty) {
      inputGoal.value = '50000';
    }
    goal      = int.parse(inputGoal.value);
    goalStart = DateTime.parse(inputStartDate.value);
    goalEnd   = DateTime.parse(inputEndDate.value);
    // TODO Add 1 day to duration?
    goalDuration = goalEnd.difference(goalStart);

    for (var i=1; i<=goalDuration.inDays; i++) {
      createGoalTrackingInputs(i);
    }

    chart = new GoalChart(goalDuration, goal);

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
