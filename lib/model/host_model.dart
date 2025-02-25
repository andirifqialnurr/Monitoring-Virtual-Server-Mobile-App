class HostModel {
  int? id;
  String? ipAddress;
  String? port;
  String? username;
  String? password;
  String? usernameFromProxmox;

  HostModel({
    this.id,
    this.ipAddress,
    this.port,
    this.username,
    this.password,
    this.usernameFromProxmox,
  });

  HostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    ipAddress = json['ip_address'] as String?;
    port = json['port'] as String?;
    username = json['username'] as String?;
    password = json['password'] as String?;
    usernameFromProxmox = json['usernameFromProxmox'] as String?;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ip_address': ipAddress,
      'port': port,
      'username': username,
      'password': password,
      'usernameFromProxmox': usernameFromProxmox,
    };
  }
}
