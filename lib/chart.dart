library chart;

import 'dart:collection';
import 'dart:js';

class Chart {
  Duration duration;
  int goal;
  LinkedHashMap options;
  List idealProgress;
  List progress;

  Chart(this.duration, this.goal) {
    idealProgress = [];
    var goalIncrement = goal / duration.inDays;
    for (var day=0; day<=duration.inDays; day++) {
      idealProgress.add(day*goalIncrement);
    }

    render();
  }

  render() {
    var options = new JsObject.jsify({
      'chart': {
        'renderTo': 'container',
        'type': 'line'
      },
      'series': [{
        'name': 'Future',
        'dashStyle': 'dot',
        'color': '#4572A7',
        'data': idealProgress
      }, {
        'name': 'Lotta',
        //'type': 'area',
        'type': 'column',
        'color': '#4572A7',
        'data': progress
      }]
    });

    new JsObject(context['Highcharts']['Chart'], [options]);
  }
}
