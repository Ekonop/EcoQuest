import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eco_quest/models/module.dart';
import 'package:eco_quest/repositories/module_repository.dart';

abstract class ModulesState {}
class ModulesLoading extends ModulesState {}
class ModulesLoaded extends ModulesState {
  final List<Module> modules;
  ModulesLoaded(this.modules);
}
class ModulesError extends ModulesState {
  final String message;
  ModulesError(this.message);
}

class ModulesCubit extends Cubit<ModulesState> {
  final ModuleRepository repository;
  ModulesCubit(this.repository) : super(ModulesLoading());

  Future<void> loadModules() async {
    try {
      final mods = await repository.getModules();
      emit(ModulesLoaded(mods));
    } catch (e) {
      emit(ModulesError(e.toString()));
    }
  }
}