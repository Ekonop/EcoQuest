import 'package:eco_quest/models/module.dart';

class ModuleRepository {
  Future<List<Module>> getModules() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Module.mock('m1', 'Climate Change'),
      Module.mock('m2', 'Biodiversity'),
      Module.mock('m3', 'Sustainability'),
      Module.mock('m4', 'Pollution'),
    ];
  }
}