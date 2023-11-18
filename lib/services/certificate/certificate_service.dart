import 'dart:io';

import '../../model/certificate_basic_info.dart';
import 'certificate_adapter.dart';

class CertificateService {
  final CertificateAdapter _adapter = CertificateAdapter();

  Future<List<CertificateInfo>?> listCertificateInfo() async {
    String run = await runCertutil();

    List<String> certificatesString = listOfStringCertificateInfo(run);
    List<String> certListFiltrada = certificatesString
        .where((cert) => cert.contains("O=ICP-Brasil"))
        .toList();

    List<CertificateInfo> listCertificateInfo =
        certListFiltrada.map(_adapter.certificateInfoAdapter).toList();

    return Future<List<CertificateInfo>?>.value(listCertificateInfo);
  }

// Split da string retornada pelo certutil em lista, quebrando por
// ================ Certificado 8 ================
  List<String> listOfStringCertificateInfo(String run) {
    final re = RegExp(r'================ Certificado *[0-9] ================');
    return run.split(re);
  }

  Future<String> runCertutil() async {
    var result =
        await Process.run('certutil', ['-store', '-silent', '-user', 'my']);

    int exitCode = result.exitCode;
    print('exit code: $exitCode');

    if (exitCode != 0) {
      throw ProcessException('certutil', [
        'Ocorreu um erro na execucao do Certutil',
        'Exit code: ${exitCode.toString()}'
      ]);
    }

    return result.stdout;
  }
}
