import 'package:spring_ud4_grupo1_app/models/BusinessModel.dart';
import 'package:spring_ud4_grupo1_app/models/ProFamilyModel.dart';

class ServicioModel {
  int? id;
  String? title;
  String? description;
  DateTime? registerDate;
  DateTime? happeningDate;
  int? studentId;
  BusinessModel? businessId;
  ProFamilyModel? profesionalFamilyId;
  double? valoration;
  int? finished;
  String? comment;
  int? deleted;

  ServicioModel({
    this.id,
    this.title,
    this.description,
    this.registerDate,
    this.happeningDate,
    this.studentId,
    this.businessId,
    this.profesionalFamilyId,
    this.valoration,
    this.finished,
    this.comment,
    this.deleted,
  });

  factory ServicioModel.fromJson(Map<String, dynamic> json) {
    print(json);
    return ServicioModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      registerDate: json['registerDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['registerDate'])
          : null,
      happeningDate: json['happeningDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['happeningDate'])
          : null,
      studentId: json['studentId'],
      businessId: json['businessId'],
      profesionalFamilyId: json['profesionalFamilyId'],
      valoration: json['valoration'] != null
          ? (json['valoration'] is int
              ? (json['valoration'] as int).toDouble()
              : json['valoration'])
          : null,
      finished: json['finished'],
      comment: json['comment'] ?? '',
      deleted: json['deleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'registerDate': registerDate?.toIso8601String(),
      'happeningDate': happeningDate?.toIso8601String(),
      'studentId': studentId,
      'businessId': businessId?.toJson(), // Asegúrate de llamar a toJson() aquí
      'profesionalFamilyId': profesionalFamilyId?.toJson(), // Y aquí también
      'valoration': valoration,
      'finished': finished,
      'comment': comment,
      'deleted': deleted,
    };
  }
}

class ServicioResponse {
  bool? success;
  ServicioModel? data;
  String? message;

  ServicioResponse({this.success, this.data, this.message});

  factory ServicioResponse.fromJson(Map<String, dynamic> json) {
    return ServicioResponse(
      success: json['success'],
      data: json['data'] != null ? ServicioModel.fromJson(json['data']) : null,
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
