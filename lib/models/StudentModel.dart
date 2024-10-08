import 'package:spring_ud4_grupo1_app/models/ProFamilyModel.dart';
import 'package:spring_ud4_grupo1_app/models/UserModel.dart';

class StudentModel extends UserModel {
  int? id;
  String? name;
  String? surname;
  String? username;
  String? email;
  String? password;
  int? enabled;
  int? deleted;
  String? role;
  String? token;
  ProFamilyModel? profesionalFamily;
  List<String>? servicios;

  StudentModel({
    this.id,
    this.name,
    this.surname,
    this.username,
    this.email,
    this.password,
    this.enabled,
    this.role,
    this.token,
    this.deleted,
    this.profesionalFamily,
    this.servicios,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      enabled: json['enabled'],
      role: json['role'],
      token: json['token'],
      deleted: json['deleted'],
      profesionalFamily: json['profesionalFamily'],
      servicios: List<String>.from(json['servicios'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['surname'] = surname;
    data['username'] = username;
    data['email'] = email;
    data['password'] = password;
    data['enabled'] = enabled;
    data['role'] = role;
    data['token'] = token;
    data['deleted'] = deleted;
    data['profesionalFamily'] = profesionalFamily;
    data['servicios'] = servicios;
    return data;
  }
}

class StudentResponse extends UserModel {
  bool? success;
  StudentModel? data;
  String? message;

  StudentResponse({this.success, this.data, this.message});

  factory StudentResponse.fromJson(Map<String, dynamic> json) {
    return StudentResponse(
      success: json['success'],
      data: json['data'] != null ? StudentModel.fromJson(json['data']) : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}
