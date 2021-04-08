enum Ranks { bronze, silver, gold, platinum, diamond, master, predetor }

extension ParseToString on Ranks {
  String toShortString() {
    return this.toString().split('.').last;
  }
}