import 'dart:html';

import 'package:writestat/chart.dart';
import 'package:writestat/goal.dart';

class WriteStat {
  Goal goal;
  Chart chart;

  WriteStat() {
    querySelector('#createGoal').onClick.listen(createGoal);
  }

  createGoal(Event e) {
    InputElement inputGoalStart = querySelector('#inputGoalStart');
    InputElement inputGoalEnd = querySelector('#inputGoalEnd');
    InputElement inputGoalAmount = querySelector('#inputGoalAmount');
    if (inputGoalAmount.value.isEmpty) {
      inputGoalAmount.value = '50000';
    }
    DateTime start = DateTime.parse(inputGoalStart.value);
    DateTime end = DateTime.parse(inputGoalEnd.value);
    int amount = int.parse(inputGoalAmount.value);

    goal = new Goal(start, end, amount);
    createGoalTrackingInputs(goal.duration.inDays);

    chart = new Chart(goal.duration, goal.amount);

    e.preventDefault();
  }

  createGoalTrackingInputs(amount) {
    for (var i = 1; i <= amount; i++) {

      var goalTrackingForm = querySelector('#goalTrackingForm');

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

      var wrapDiv = new DivElement();
      wrapDiv.classes.add('col-sm-8');
      wrapDiv.children.add(input);
      formGroup.children.add(wrapDiv);

      input.onBlur.listen(recalculateGoal);
    }
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
