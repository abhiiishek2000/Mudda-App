
class UserSettingConfigS3Folder {


  String? channel;
  String? chat;
  String? country;
  String? mudda;
  String? notificationType;
  String? postForMudda;
  String? quoteOrActivity;
  String? user;

  UserSettingConfigS3Folder({
    this.channel,
    this.chat,
    this.country,
    this.mudda,
    this.notificationType,
    this.postForMudda,
    this.quoteOrActivity,
    this.user,
  });
  UserSettingConfigS3Folder.fromJson(Map<String, dynamic> json) {
    channel = json['channel']?.toString();
    chat = json['chat']?.toString();
    country = json['country']?.toString();
    mudda = json['mudda']?.toString();
    notificationType = json['notificationType']?.toString();
    postForMudda = json['postForMudda']?.toString();
    quoteOrActivity = json['quoteOrActivity']?.toString();
    user = json['user']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['channel'] = channel;
    data['chat'] = chat;
    data['country'] = country;
    data['mudda'] = mudda;
    data['notificationType'] = notificationType;
    data['postForMudda'] = postForMudda;
    data['quoteOrActivity'] = quoteOrActivity;
    data['user'] = user;
    return data;
  }
}

class UserSettingConfigS3 {


  String? url;
  UserSettingConfigS3Folder? folder;

  UserSettingConfigS3({
    this.url,
    this.folder,
  });
  UserSettingConfigS3.fromJson(Map<String, dynamic> json) {
    url = json['url']?.toString();
    folder = (json['folder'] != null) ? UserSettingConfigS3Folder.fromJson(json['folder']) : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['url'] = url;
    if (folder != null) {
      data['folder'] = folder!.toJson();
    }
    return data;
  }
}

class UserSettingConfig {

  UserSettingConfigS3? s3;

  UserSettingConfig({
    this.s3,
  });
  UserSettingConfig.fromJson(Map<String, dynamic> json) {
    s3 = (json['s3'] != null) ? UserSettingConfigS3.fromJson(json['s3']) : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (s3 != null) {
      data['s3'] = s3!.toJson();
    }
    return data;
  }
}

class UserSetting {


  int? status;
  UserSettingConfig? config;

  UserSetting({
    this.status,
    this.config,
  });
  UserSetting.fromJson(Map<dynamic, dynamic> json) {
    status = json['status']?.toInt();
    config = (json['config'] != null) ? UserSettingConfig.fromJson(json['config']) : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    if (config != null) {
      data['config'] = config!.toJson();
    }
    return data;
  }
}
