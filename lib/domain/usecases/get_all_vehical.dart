import 'package:tara_driver_application/domain/entities/user_entities.dart';
import 'package:tara_driver_application/domain/repositories/vehical_reposity.dart';

class GetAllVehical {
  final VehicalReposity repository;

  GetAllVehical(this.repository);

  Future<VehicalTypeEntities> execute() async {
    return await repository.getAllVehical();
  }
}
