import 'package:bahrain_manpower/models/Companies/Employees.dart';

class FavoriteEmployee {
  FavoriteEmployee({
    this.favoriteId,
    this.workerId,
    this.created,
    this.worker,
  });

  String? favoriteId;
  String? workerId;
  String? created;
  Employees? worker;

  factory FavoriteEmployee.fromJson(Map<String, dynamic> json) =>
      FavoriteEmployee(
        favoriteId: json["favorite_id"],
        workerId: json["worker_id"],
        created: json["created"],
        worker: Employees.fromJson(json["worker"]),
      );
}
