class ContainerModel {
  int? vmid;
  num? cpu;
  int? cpus;
  int? mem;
  int? maxmem;
  int? disk;
  int? maxdisk;
  String? status;
  String? name;
  String? type;
  bool? isAutomationRunning;

  ContainerModel({
    this.vmid,
    this.cpu,
    this.cpus,
    this.mem,
    this.maxmem,
    this.disk,
    this.maxdisk,
    this.status,
    this.name,
    this.type,
    this.isAutomationRunning,
  });

  ContainerModel.fromJson(Map<String, dynamic> json) {
    vmid = json['vmid'] as int?;
    cpu = json['cpu'] as num?;
    cpus = json['cpus'] as int?;
    mem = json['mem'] as int?;
    maxmem = json['maxmem'] as int?;
    disk = json['disk'] as int?;
    maxdisk = json['maxdisk'] as int?;
    status = json['status'] as String?;
    name = json['name'] as String?;
    type = json['type'] as String?;
    isAutomationRunning = json['isAutomationRunning'] as bool?;
  }

  Map<String, dynamic> toJson() {
    return {
      'vmid': vmid,
      'cpu': cpu,
      'cpus': cpus,
      'mem': mem,
      'maxmem': maxmem,
      'disk': disk,
      'maxdisk': maxdisk,
      'status': status,
      'name': name,
      'type': type,
      'isAutomationRunning': isAutomationRunning,
    };
  }

  ContainerModel copyWith({
    int? vmid,
    num? cpu,
    int? cpus,
    int? mem,
    int? maxmem,
    int? disk,
    int? maxdisk,
    String? status,
    String? name,
    String? type,
    bool? isAutomationRunning,
  }) {
    return ContainerModel(
      vmid: vmid ?? this.vmid,
      cpu: cpu ?? this.cpu,
      cpus: cpus ?? this.cpus,
      mem: mem ?? this.mem,
      maxmem: maxmem ?? this.maxmem,
      disk: disk ?? this.disk,
      maxdisk: maxdisk ?? this.maxdisk,
      status: status ?? this.status,
      name: name ?? this.name,
      type: type ?? this.type,
      isAutomationRunning: isAutomationRunning ?? this.isAutomationRunning,
    );
  }
}
