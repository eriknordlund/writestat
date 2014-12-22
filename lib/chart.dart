library chart;

import 'dart:js';

class Chart {
  Duration duration;
  int goal;
  List<int> idealProgress;
  List<int> progress;

  render() {
    var options = new JsObject.jsify({
      'chart': {
        'renderTo': 'container',
        'type': 'line'
      },
      'series': [{
        'name': 'Idealisk progress',
        'dashStyle': 'dot',
        'color': '#4572A7',
        'data': idealProgress
      }, {
        'name': 'Faktisk progress',
        'type': 'column',
        'color': '#9972A7',
        'data': progress
      }]
    });

    new JsObject(context['Highcharts']['Chart'], [options]);
  }

  setActualProgress(List<int> progress) {
    this.progress = [];
    this.progress.addAll(progress);
    this.progress.removeWhere((i) => i == 0);
    render();
  }

  setIdealProgress(int goal, Duration duration) {
    this.goal = goal;
    this.duration = duration;
    this.idealProgress = [];

    if (goal != null && duration != null) {
      var goalIncrement = goal / duration.inDays;
      for (var day=0; day<=duration.inDays; day++) {
        idealProgress.add(day*goalIncrement);
      }
    }
    render();
  }
}
