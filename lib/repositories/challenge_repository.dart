import 'package:eco_quest/models/challenge.dart';

class ChallengeRepository {
  Future<List<Challenge>> getOngoingChallenges() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [Challenge.mock(), Challenge.mock()];
  }
}