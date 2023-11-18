import 'package:flutter/material.dart';

import '../model/certificate_basic_info.dart';
import '../services/certificate/certificate_service.dart';

class CertificateProvider extends ChangeNotifier {
  final CertificateService service = CertificateService();

  Future<List<CertificateInfo>?>? _certificateList;

  Future<List<CertificateInfo>?>? get getCertificates {

    return Future.value(List.empty(growable: true));
  }

  Future<List<CertificateInfo>?>? loadCertificates() {

    _certificateList ??= service.listCertificateInfo();

    return _certificateList;
  }

  Future<void> clearCertificates() async {
    _certificateList = null;
    notifyListeners();
  }

  Future<void> updateCertificates() async {
    _certificateList = service.listCertificateInfo();
    notifyListeners();
  }
}
