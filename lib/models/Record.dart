import '../enums/Rank.dart';

const INITIAL_RP_KEY = 'initial_rp';
const RECORD_KEY = 'record';
const RECORDS_KEY = 'records';

class Record {
  Rank rank = Rank.bronze;
  int kill;
  int assist;
  int ranking;
  int rp;
  int damage;
  DateTime playedAt;

  Record({
    this.rank = Rank.bronze,
    this.kill = 0,
    this.assist = 0,
    this.ranking = 10,
    this.rp = 0,
    this.damage = 0,
    this.playedAt,
  });

  Record.fromJson(Map<String, dynamic> json)
    : rank = parseStringToRank[json['rank']],
      kill = int.parse(json['kill'].toString()),
      assist = int.parse(json['assist'].toString()),
      ranking = int.parse(json['ranking'].toString()),
      rp = int.parse(json['rp'].toString()),
      damage = int.parse(json['damage'].toString()),
      playedAt = DateTime.tryParse(json['playedAt'].toString());

  Map<String, dynamic> toJson() => {
    'rank': rank.toShortString(),
    'kill': kill.toString(),
    'assist': assist.toString(),
    'ranking': ranking.toString(),
    'rp': rp.toString(),
    'damage': damage.toString(),
    'playedAt': playedAt.toString(),
  };
}