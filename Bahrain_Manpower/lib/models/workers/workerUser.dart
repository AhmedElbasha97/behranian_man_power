import 'package:bahrain_manpower/models/AppInfo/Filters.dart';

class WorkerProfile {
  WorkerProfile({
    this.workerId,
    this.nameEn,
    this.nameAr,
    this.salary,
    this.experience,
    this.contractPeriod,
    this.birthDate,
    this.age,
    this.mobile,
    this.whatsapp,
    this.image1,
    this.image2,
    this.image3,
    this.occupation,
    this.nationality,
    this.religion,
    this.status,
    this.residence,
    this.education,
    this.language,
    this.skills,
    this.additional,
    this.company,
  });

  String? workerId;
  String? nameEn;
  String? nameAr;
  String? salary;
  String? experience;
  String? contractPeriod;
  String? birthDate;
  String? age;
  String? mobile;
  String? whatsapp;
  String? image1;
  String? image2;
  String? image3;
  Occupation? occupation;
  Nationality? nationality;
  Religion? religion;
  Status? status;
  Residence? residence;
  List<Education>? education;
  List<Language>? language;
  List<Skill>? skills;
  dynamic additional;
  dynamic company;

  factory WorkerProfile.fromJson(Map<String, dynamic> json) => WorkerProfile(
        workerId: json["worker_id"],
        nameEn: json["name_en"],
        nameAr: json["name_ar"],
        salary: json["salary"],
        experience: json["experience"],
        contractPeriod:
            json["contract_period"],
        birthDate: json["birth_date"],
        age: json["age"],
        mobile: json["mobile"],
        whatsapp: json["whatsapp"],
        image1: json["image1"],
        image2: json["image2"],
        image3: json["image3"],
        occupation: json["occupation"] == null
            ? null
            : Occupation.fromJson(json["occupation"]),
        nationality: json["nationality"] == null
            ? null
            : Nationality.fromJson(json["nationality"]),
        religion: json["religion"] == null
            ? null
            : Religion.fromJson(json["religion"]),
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        residence: json["residence"] == null
            ? null
            : Residence.fromJson(json["residence"]),
        education: json["education"] == null
            ? null
            : List<Education>.from(
                json["education"].map((x) => Education.fromJson(x))),
        language: json["language"] == null
            ? null
            : List<Language>.from(json["language"].map((x) => x)),
        skills: json["skills"] == null
            ? null
            : List<Skill>.from(json["skills"].map((x) => Skill.fromJson(x))),
        additional: json["additional"],
        company: json["company"],
      );
}
