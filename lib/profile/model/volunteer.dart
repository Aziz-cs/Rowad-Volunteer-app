class Volunteer {
  String id;
  String name;
  String email;
  String phoneNo;
  String birthday;
  bool isMale;
  String area;
  String city;
  String educationDegree;
  String specialization;
  String volunteerLevel;
  // === Optional
  String avatarURL;
  String nationalID;
  String nationality;
  String socialState;
  String workType;
  String job;
  Map languages;
  List skillsList;
  List interestsList;

  Volunteer({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNo,
    required this.birthday,
    required this.isMale,
    required this.area,
    required this.city,
    required this.educationDegree,
    required this.specialization,
    required this.volunteerLevel,
    required this.avatarURL,
    required this.nationalID,
    required this.nationality,
    required this.socialState,
    required this.workType,
    required this.job,
    required this.languages,
    required this.skillsList,
    required this.interestsList,
  });

  factory Volunteer.fromDB(Map<String, dynamic> data, String id) {
    return Volunteer(
      //Mandatory fields
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phoneNo: data['phoneNo'] ?? '',
      area: data['area'] ?? '',
      birthday: data['birthday'] ?? '',
      city: data['city'] ?? '',
      educationDegree: data['educationDegree'] ?? '',
      volunteerLevel: data['volunteerLevel'] ?? '',
      isMale: data['isMale'] ?? '',
      //Optional fields
      languages: data['languages'] ?? {},
      avatarURL: data['avatarURL'] ?? '',
      nationalID: data['nationalID'] ?? '',
      nationality: data['nationality'] ?? '',
      skillsList: data['skillsList'] ?? [],
      socialState: data['socialState'] ?? '',
      specialization: data['specialization'] ?? '',
      interestsList: data['interestsList'] ?? [],
      workType: data['workType'] ?? '',
      job: data['job'] ?? '',
    );
  }
}
