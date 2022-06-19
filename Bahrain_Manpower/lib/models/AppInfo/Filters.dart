// ignore_for_file: file_names

class FiltersData {
  FiltersData({
    this.country,
    this.category,
    this.religion,
    this.status,
    this.occupation,
    this.nationality,
    this.gender,
    this.residence,
    this.skills,
    this.language,
    this.education,
  });

  List<Country>? country;
  List<Category>? category;
  List<Religion>? religion;
  List<Status>? status;
  List<Occupation>? occupation;
  List<Nationality>? nationality;
  List<Gender>? gender;
  List<Residence>? residence;
  List<Skill>? skills;
  List<Language>? language;
  List<Education>? education;

  factory FiltersData.fromJson(Map<String, dynamic> json) => FiltersData(
        country: json["country"] == null
            ? null
            : List<Country>.from(
                json["country"].map((x) => Country.fromJson(x))),
        category: json["category"] == null
            ? null
            : List<Category>.from(
                json["category"].map((x) => Category.fromJson(x))),
        religion: json["religion"] == null
            ? null
            : List<Religion>.from(
                json["religion"].map((x) => Religion.fromJson(x))),
        status: json["status"] == null
            ? null
            : List<Status>.from(json["status"].map((x) => Status.fromJson(x))),
        occupation: json["occupation"] == null
            ? null
            : List<Occupation>.from(
                json["occupation"].map((x) => Occupation.fromJson(x))),
        nationality: json["nationality"] == null
            ? null
            : List<Nationality>.from(
                json["nationality"].map((x) => Nationality.fromJson(x))),
        gender: json["gender"] == null
            ? null
            : List<Gender>.from(json["gender"].map((x) => Gender.fromJson(x))),
        residence: json["residence"] == null
            ? null
            : List<Residence>.from(
                json["residence"].map((x) => Residence.fromJson(x))),
        skills: json["skills"] == null
            ? null
            : List<Skill>.from(json["skills"].map((x) => Skill.fromJson(x))),
        language: json["language"] == null
            ? null
            : List<Language>.from(
                json["language"].map((x) => Language.fromJson(x))),
        education: json["education"] == null
            ? null
            : List<Education>.from(
                json["education"].map((x) => Education.fromJson(x))),
      );
}

class Category {
  Category({
    this.categoryId,
    this.categoryName,
    this.categoryNameEn,
  });

  String? categoryId;
  String? categoryName;
  String? categoryNameEn;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        categoryId: json["category_id"],
        categoryName:
            json["category_name"],
        categoryNameEn:
            json["category_name_en"],
      );
}

class Country {
  Country({
    this.countryId,
    this.countryName,
    this.countryNameEn,
    this.dialing,
    this.icon,
  });

  String? countryId;
  String? countryName;
  String? countryNameEn;
  String? dialing;
  String? icon;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    countryId: json["country_id"],
    countryName: json["country_name"],
    countryNameEn: json["country_name_en"],
    dialing: json["dialing"],
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "country_id": countryId,
    "country_name": countryName,
    "country_name_en": countryNameEn,
    "dialing": dialing,
    "icon": icon,
  };
}


class Education {
  Education({
    this.educationId,
    this.educationName,
    this.educationNameEn,
  });

  String? educationId;
  String? educationName;
  String? educationNameEn;

  factory Education.fromJson(Map<String, dynamic> json) => Education(
        educationId: json["education_id"],
        educationName:
            json["education_name"],
        educationNameEn: json["education_name_en"],
      );
}

class Gender {
  Gender({
    this.genderId,
    this.genderName,
    this.genderNameEn,
  });

  String? genderId;
  String? genderName;
  String? genderNameEn;

  factory Gender.fromJson(Map<String, dynamic> json) => Gender(
        genderId: json["gender_id"],
        genderName: json["gender_name"],
        genderNameEn:
            json["gender_name_en"],
      );
}

class Language {
  Language({
    this.languageId,
    this.languageName,
    this.languageNameEn,
  });

  String? languageId;
  String? languageName;
  String? languageNameEn;

  factory Language.fromJson(Map<String, dynamic> json) => Language(
        languageId: json["language_id"],
        languageName:
            json["language_name"],
        languageNameEn:
            json["language_name_en"],
      );
}

class Nationality {
  Nationality({
    this.nationalityId,
    this.nationalityName,
    this.nationalityNameEn,
  });

  String? nationalityId;
  String? nationalityName;
  String? nationalityNameEn;

  factory Nationality.fromJson(Map<String, dynamic> json) => Nationality(
        nationalityId:
            json["nationality_id"],
        nationalityName:
            json["nationality_name"],
        nationalityNameEn: json["nationality_name_en"],
      );
}

class Occupation {
  Occupation({
    this.occupationId,
    this.occupationName,
    this.occupationNameEn,
    this.formCv,
  });

  String? occupationId;
  String? occupationName;
  String? occupationNameEn;
  String? formCv;

  factory Occupation.fromJson(Map<String, dynamic> json) => Occupation(
        occupationId:
            json["occupation_id"],
        occupationName:
            json["occupation_name"],
        occupationNameEn: json["occupation_name_en"],
        formCv: json["form_cv"],
      );
}

class Religion {
  Religion({
    this.religionId,
    this.religionName,
    this.religionNameEn,
  });

  String? religionId;
  String? religionName;
  String? religionNameEn;

  factory Religion.fromJson(Map<String, dynamic> json) => Religion(
        religionId: json["religion_id"],
        religionName:
            json["religion_name"],
        religionNameEn:
            json["religion_name_en"],
      );
}

class Residence {
  Residence({
    this.residenceId,
    this.residenceName,
    this.residenceNameEn,
  });

  String? residenceId;
  String? residenceName;
  String? residenceNameEn;

  factory Residence.fromJson(Map<String, dynamic> json) => Residence(
        residenceId: json["residence_id"],
        residenceName:
            json["residence_name"],
        residenceNameEn: json["residence_name_en"],
      );
}

class Skill {
  Skill({
    this.skillsId,
    this.skillsName,
    this.skillsNameEn,
  });

  String? skillsId;
  String? skillsName;
  String? skillsNameEn;

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
        skillsId: json["skills_id"],
        skillsName: json["skills_name"],
        skillsNameEn:
            json["skills_name_en"],
      );
}

class Status {
  Status({
    this.statusId,
    this.statusName,
    this.statusNameEn,
  });

  String? statusId;
  String? statusName;
  String? statusNameEn;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        statusId: json["status_id"],
        statusName: json["status_name"],
        statusNameEn:
            json["status_name_en"],
      );
}
