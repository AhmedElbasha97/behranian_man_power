class About {
  About({
    this.aboutid,
    this.title,
    this.text,
    this.video,
  });

  String? aboutid;
  String? title;
  String? text;
  String? video;

  factory About.fromJson(Map<String, dynamic> json) => About(
        aboutid: json["aboutid"],
        title: json["title"],
        text: json["text"],
        video: json["video"],
      );
}
