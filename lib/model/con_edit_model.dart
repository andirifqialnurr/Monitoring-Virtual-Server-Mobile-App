// CPU Container Model
class EditCPUContainerModel {
  int? id;
  int? cpu;

  EditCPUContainerModel({
    this.id,
    this.cpu,
  });

  EditCPUContainerModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    cpu = int.parse(json['cpu'].toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cpu': cpu,
    };
  }
}

// HDD Container Model
class EditHDDContainerModel {
  int? id;
  int? disk;

  EditHDDContainerModel({
    this.id,
    this.disk,
  });

  EditHDDContainerModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    disk = int.parse(json['disk'].toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'disk': disk,
    };
  }
}

// RAM Container Model
class EditRAMContainerModel {
  int? id;
  int? mem;

  EditRAMContainerModel({
    this.id,
    this.mem,
  });

  EditRAMContainerModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    mem = int.parse(json['mem'].toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mem': mem,
    };
  }
}
