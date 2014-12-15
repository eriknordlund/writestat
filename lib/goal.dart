library goal;

class Goal {
  DateTime start;
  DateTime end;
  int      amount;
  Duration duration;

  Goal(this.start, this.end, this.amount) {
    this.start.subtract(new Duration(days: 1)); // include the chosen start day in the goal
    duration = end.difference(start);
  }
}