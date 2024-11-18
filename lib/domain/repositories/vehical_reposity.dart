import 'package:com.tara_driver_application/domain/entities/user_entities.dart';

abstract class VehicalReposity {
  Future<VehicalTypeEntities> getAllVehical();
}
