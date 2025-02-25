class NodeModel {
  int? index;
  String? id;
  num? cpu;
  int? cpus;
  int? mem;
  int? maxmem;
  int? disk;
  int? maxdisk;
  String? status;
  String? node;
  String? type;

  NodeModel({
    this.index,
    this.id,
    this.cpu,
    this.cpus,
    this.mem,
    this.maxmem,
    this.disk,
    this.maxdisk,
    this.status,
    this.node,
    this.type,
  });

  NodeModel.fromJson(Map<String, dynamic> json) {
    index = json['index'] as int?;
    id = json['id'] as String?;
    cpu = json['cpu'] as num?;
    cpus = json['maxcpu'] as int?;
    mem = json['mem'] as int?;
    maxmem = json['maxmem'] as int?;
    disk = json['disk'] as int?;
    maxdisk = json['maxdisk'] as int?;
    status = json['status'] as String?;
    node = json['node'] as String?;
    type = json['type'] as String?;
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'id': id,
      'cpu': cpu,
      'cpus': cpus,
      'mem': mem,
      'maxmem': maxmem,
      'disk': disk,
      'maxdisk': maxdisk,
      'status': status,
      'node': node,
      'type': type,
    };
  }
}
