import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eco_quest/models/challenge.dart';

// For now, no additional data fetching
abstract class ChallengeDetailsState {}
class ChallengeDetailsInitial extends ChallengeDetailsState {}
class ChallengeDetailsLoaded extends ChallengeDetailsState {
  final Challenge challenge;
  ChallengeDetailsLoaded(this.challenge);
}

class ChallengeDetailsCubit extends Cubit<ChallengeDetailsState> {
  ChallengeDetailsCubit() : super(ChallengeDetailsInitial());

  void loadDetails(Challenge challenge) {
    emit(ChallengeDetailsLoaded(challenge));
  }
}