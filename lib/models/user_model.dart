class UserModel {
  String? id;
  String fullName;
  String email;
  String phone;
  String address;
  String? jobTitle;     // للسمارت
  String? education;    // للبسيط والسمارت
  String? skills;       // المهارات (نص)
  List<dynamic>? smartSkills; // مهارات AI
  String? experience;
  String? summary;
  String? linkedin;     // رابط لينكد إن
  String? birthDate;    // تاريخ الميلاد
  String? profileImage; // رابط الصورة من Firebase Storage
  String? languages;    // اللغات (الإضافة الجديدة)
  bool isSmart;

  UserModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    this.jobTitle,
    this.education,
    this.skills,
    this.smartSkills,
    this.experience,
    this.summary,
    this.linkedin,
    this.birthDate,
    this.profileImage,
    this.languages,    // أضفناها هنا
    required this.isSmart,
  });

  // من Firestore إلى App
  factory UserModel.fromMap(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      jobTitle: data['jobTitle'],
      education: data['education'],
      skills: data['skills'],
      smartSkills: data['smartSkills'],
      experience: data['experience'],
      summary: data['summary'],
      linkedin: data['linkedin'],
      birthDate: data['birthDate'],
      profileImage: data['profileImage'],
      languages: data['languages'], // قراءة اللغات
      isSmart: data['isSmart'] ?? false,
    );
  }

  // من App إلى Firestore
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'jobTitle': jobTitle,
      'education': education,
      'skills': skills,
      'smartSkills': smartSkills,
      'experience': experience,
      'summary': summary,
      'linkedin': linkedin,
      'birthDate': birthDate,
      'profileImage': profileImage,
      'languages': languages, // تخزين اللغات
      'isSmart': isSmart,
    };
  }
}