// ignore: file_names
class Employees {
  Employees({
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
    this.categoryWorker,
    this.education,
    this.language,
    this.skills,
    this.additional,
    this.company,
    this.isPaid,
    this.favourite,
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
  CategoryWorker? categoryWorker;
  List<Education>? education;
  List<Language>? language;
  List<Skill>? skills;
  Additional? additional;
  dynamic company;
  bool? isPaid;
  bool? favourite;

  factory Employees.fromJson(Map<String, dynamic> json) => Employees(
        workerId: json["worker_id"],
        nameEn: json["name_en"],
        nameAr: json["name_ar"],
        salary: json["salary"],
        experience: json["experience"],
        contractPeriod: json["contract_period"],
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
        categoryWorker: json["category_worker"] == null
            ? null
            : CategoryWorker.fromJson(json["category_worker"]),
        education: List<Education>.from(
            json["education"].map((x) => Education.fromJson(x))),
        language: List<Language>.from(
            json["language"].map((x) => Language.fromJson(x))),
        skills: List<Skill>.from(json["skills"].map((x) => Skill.fromJson(x))),
        additional: json["additional"] == null
            ? null
            : Additional.fromJson(json["additional"]),
        company: json["company"],
        isPaid: json["is_paid"],
       favourite: json["favourite"],
      );
}

class Additional {
  Additional({
    this.children,
    this.length,
    this.weight,
    this.passportNo,
    this.passportPlace,
    this.passportDate,
    this.passportExpDate,
  });

  String? children;
  String? length;
  String? weight;
  String? passportNo;
  String? passportPlace;
  String? passportDate;
  String? passportExpDate;

  factory Additional.fromJson(Map<String, dynamic> json) => Additional(
        children: json["children"],
        length: json["length"],
        weight: json["weight"],
        passportNo: json["passport_no"],
        passportPlace:
            json["passport_place"],
        passportDate:
            json["passport_date"],
        passportExpDate: json["passport_exp_date"],
      );

  Map<String, dynamic> toJson() => {
        "children": children,
        "length": length,
        "weight": weight,
        "passport_no": passportNo,
        "passport_place": passportPlace,
        "passport_date": passportDate,
        "passport_exp_date": passportExpDate,
      };
}

class CategoryWorker {
  CategoryWorker({
    this.categoryWorkerId,
    this.titleAr,
    this.titleEn,
  });

  String? categoryWorkerId;
  String? titleAr;
  String? titleEn;

  factory CategoryWorker.fromJson(Map<String, dynamic> json) => CategoryWorker(
        categoryWorkerId: json["category_worker_id"],
        titleAr: json["title_ar"],
        titleEn: json["title_en"],
      );
}

class Education {
  Education({
    this.educationId,
    this.titleAr,
    this.titleEn,
  });

  String? educationId;
  String? titleAr;
  String? titleEn;

  factory Education.fromJson(Map<String, dynamic> json) => Education(
        educationId: json["education_id"],
        titleAr: json["title_ar"],
        titleEn: json["title_en"],
      );
}

class Language {
  Language({
    this.languageId,
    this.titleAr,
    this.titleEn,
  });

  String? languageId;
  String? titleAr;
  String? titleEn;

  factory Language.fromJson(Map<String, dynamic> json) => Language(
        languageId: json["language_id"],
        titleAr: json["title_ar"],
        titleEn: json["title_en"],
      );
}

class Nationality {
  Nationality({
    this.nationalityId,
    this.titleAr,
    this.titleEn,
  });

  String? nationalityId;
  String? titleAr;
  String? titleEn;

  factory Nationality.fromJson(Map<String, dynamic> json) => Nationality(
        nationalityId: json["nationality_id"],
        titleAr: json["title_ar"],
        titleEn: json["title_en"],
      );
}

class Occupation {
  Occupation({
    this.occupationId,
    this.titleAr,
    this.titleEn,
    this.formCv,
  });

  String? occupationId;
  String? titleAr;
  String? titleEn;
  String? formCv;

  factory Occupation.fromJson(Map<String, dynamic> json) => Occupation(
        occupationId: json["occupation_id"],
        titleAr: json["title_ar"],
        titleEn: json["title_en"],
        formCv: json["form_cv"],
      );
}

class Religion {
  Religion({
    this.religionId,
    this.titleAr,
    this.titleEn,
  });

  String? religionId;
  String? titleAr;
  String? titleEn;

  factory Religion.fromJson(Map<String, dynamic> json) => Religion(
        religionId: json["religion_id"],
        titleAr: json["title_ar"],
        titleEn: json["title_en"],
      );
}

class Residence {
  Residence({
    this.residenceId,
    this.titleAr,
    this.titleEn,
  });

  String? residenceId;
  String? titleAr;
  String? titleEn;

  factory Residence.fromJson(Map<String, dynamic> json) => Residence(
        residenceId: json["residence_id"],
        titleAr: json["title_ar"],
        titleEn: json["title_en"],
      );
}

class Skill {
  Skill({
    this.skillsId,
    this.titleAr,
    this.titleEn,
  });

  String? skillsId;
  String? titleAr;
  String? titleEn;

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
        skillsId: json["skills_id"],
        titleAr: json["title_ar"],
        titleEn: json["title_en"],
      );
}

class Status {
  Status({
    this.statusnId,
    this.titleAr,
    this.titleEn,
  });

  String? statusnId;
  String? titleAr;
  String? titleEn;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        statusnId: json["statusn_id"],
        titleAr: json["title_ar"],
        titleEn: json["title_en"],
      );
}
