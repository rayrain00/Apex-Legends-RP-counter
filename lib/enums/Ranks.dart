enum Rank { bronze, silver, gold, platinum, diamond, master, predetor }

extension ParseToString on Rank {
  String toShortString() {
    return this.toString().split('.').last;
  }
}