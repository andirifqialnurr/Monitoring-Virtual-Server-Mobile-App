// CPU VM Model
class EditCPUVMModel {
  int? id;
  int? cpu;

  EditCPUVMModel({
    this.id,
    this.cpu,
  });

  EditCPUVMModel.fromJson(Map<String, dynamic> json) {
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

// HDD VM Model
class EditHDDVMModel {
  int? id;
  int? disk;

  EditHDDVMModel({
    this.id,
    this.disk,
  });

  EditHDDVMModel.fromJson(Map<String, dynamic> json) {
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

// RAM VM Model
class EditRAMVMModel {
  int? id;
  int? memory;

  EditRAMVMModel({
    this.id,
    this.memory,
  });

  EditRAMVMModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    memory = int.parse(json['mem'].toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mem': memory,
    };
  }
}
