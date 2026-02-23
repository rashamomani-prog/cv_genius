class UserModel {
  String? id;
  String fullName;
  String email;
  String phone;
  String address;
  String? jobTitle; // للسمارت
  String? education; // للبسيط
  String? skills; // للبسيط (String) أو للسمارت (List) حسب ما بتخزنيه
  List<dynamic>? smartSkills; // للمقترحات الـ AI في السمارت
  String? experience;
  String? summary;
  String? linkedin; // للسمارت
  String? birthDate; // للسمارت
  String? profileImage; // للسمارت (رابط الصورة)
  bool isSmart; // عشان نميز البيانات جاية من أي نموذج

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
    required this.isSmart,
  });

  // وظيفة لتحويل البيانات من Map (Firestore) إلى Object (App)
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
      isSmart: data['isSmart'] ?? false,
    );
  }

  // وظيفة لتحويل الـ Object إلى Map عشان نخزنه في Firestore
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
      'isSmart': isSmart,
    };
  }
}