class FileModel {
  String? fileId;
  String? fileName;
  String? downloadUrl;
  String? customerId;
  int? numPages;
  String? fileExtension;
  String? uploadAt;

  FileModel({
    required this.fileId,
    required this.fileName,
    required this.downloadUrl,
    required this.customerId,
    required this.numPages,
    required this.fileExtension,
    required this.uploadAt,
  });

  FileModel.fromJson(Map<String, dynamic> jsonObject) {
    fileId = jsonObject['fileId'];
    fileName = jsonObject['file_name'];
    downloadUrl = jsonObject['downloadUrl'];
    numPages = jsonObject['numPages'];
    fileExtension = jsonObject['file_extension'];
    customerId = jsonObject['customer'];
    uploadAt = jsonObject['upload_at'];
  }

  Map<String, dynamic> toMap() {
    return {
      'fileId': fileId,
      'file_name': fileName,
      'downloadUrl': downloadUrl,
      'numPages': numPages,
      'file_extension': fileExtension,
      'customer': customerId,
      'upload_at': uploadAt,
    };
  }
}
