enum Rank { bronze, silver, gold, platinum, diamond, master, predetor }

const Map<String, Rank> parseStringToRank = {
  'bronze': Rank.bronze,
  'silver': Rank.silver,
  'gold': Rank.gold,
  'platinum': Rank.platinum,
  'diamond': Rank.diamond,
  'master': Rank.master,
  'predetor': Rank.predetor,
};

extension ParseToString on Rank {
  String toShortString() {
    return this.toString().split('.').last;
  }
}