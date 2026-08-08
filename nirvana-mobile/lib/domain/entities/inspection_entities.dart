/// User entity
class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  final String? department;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    this.department,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      role: json['role'] ?? 'engineer',
      department: json['department'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'department': department,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

/// LVMDP Inspection Entity
class LvmdpInspection {
  final int? id;
  final String date;
  final String timeSlot;
  final double? ampereR;
  final double? ampereS;
  final double? ampereT;
  final double? voltRS;
  final double? voltST;
  final double? voltTR;
  final double? cosPhi;
  final double? kw;
  final double? kwh;
  final double? hz;
  final int? userId;
  final bool isSynced;
  final DateTime? createdAt;

  LvmdpInspection({
    this.id,
    required this.date,
    required this.timeSlot,
    this.ampereR,
    this.ampereS,
    this.ampereT,
    this.voltRS,
    this.voltST,
    this.voltTR,
    this.cosPhi,
    this.kw,
    this.kwh,
    this.hz,
    this.userId,
    this.isSynced = false,
    this.createdAt,
  });

  factory LvmdpInspection.fromJson(Map<String, dynamic> json) {
    return LvmdpInspection(
      id: json['id'],
      date: json['date'] ?? '',
      timeSlot: json['time_slot'] ?? '',
      ampereR: json['ampere_r']?.toDouble(),
      ampereS: json['ampere_s']?.toDouble(),
      ampereT: json['ampere_t']?.toDouble(),
      voltRS: json['volt_rs']?.toDouble(),
      voltST: json['volt_st']?.toDouble(),
      voltTR: json['volt_tr']?.toDouble(),
      cosPhi: json['cos_phi']?.toDouble(),
      kw: json['kw']?.toDouble(),
      kwh: json['kwh']?.toDouble(),
      hz: json['hz']?.toDouble(),
      userId: json['user_id'],
      isSynced: json['is_synced'] == 1,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'date': date,
      'time_slot': timeSlot,
      'ampere_r': ampereR,
      'ampere_s': ampereS,
      'ampere_t': ampereT,
      'volt_rs': voltRS,
      'volt_st': voltST,
      'volt_tr': voltTR,
      'cos_phi': cosPhi,
      'kw': kw,
      'kwh': kwh,
      'hz': hz,
      'user_id': userId,
      'is_synced': isSynced ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

/// STP Inspection Entity
class StpInspection {
  final int? id;
  final String date;
  final String timeSlot;
  final String? gritChamberStatus;
  final String? equalizingTankStatus;
  final String? aerationStatus;
  final String? sedimentasiTankStatus;
  final String? effluentTankStatus;
  final String? pumpBlowerStatus;
  final String? notes;
  final int? userId;
  final bool isSynced;
  final DateTime? createdAt;

  StpInspection({
    this.id,
    required this.date,
    required this.timeSlot,
    this.gritChamberStatus,
    this.equalizingTankStatus,
    this.aerationStatus,
    this.sedimentasiTankStatus,
    this.effluentTankStatus,
    this.pumpBlowerStatus,
    this.notes,
    this.userId,
    this.isSynced = false,
    this.createdAt,
  });

  factory StpInspection.fromJson(Map<String, dynamic> json) {
    return StpInspection(
      id: json['id'],
      date: json['date'] ?? '',
      timeSlot: json['time_slot'] ?? '',
      gritChamberStatus: json['grit_chamber_status'],
      equalizingTankStatus: json['equalizing_tank_status'],
      aerationStatus: json['aeration_status'],
      sedimentasiTankStatus: json['sedimentasi_tank_status'],
      effluentTankStatus: json['effluent_tank_status'],
      pumpBlowerStatus: json['pump_blower_status'],
      notes: json['notes'],
      userId: json['user_id'],
      isSynced: json['is_synced'] == 1,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'date': date,
      'time_slot': timeSlot,
      'grit_chamber_status': gritChamberStatus,
      'equalizing_tank_status': equalizingTankStatus,
      'aeration_status': aerationStatus,
      'sedimentasi_tank_status': sedimentasiTankStatus,
      'effluent_tank_status': effluentTankStatus,
      'pump_blower_status': pumpBlowerStatus,
      'notes': notes,
      'user_id': userId,
      'is_synced': isSynced ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

/// Electrical Log Entity
class ElectricalLog {
  final int? id;
  final String date;
  final int shift;
  final double? currentPower;
  final double? kwhWbp;
  final double? kwhLwbp;
  final double? kwhKvarh;
  final double? voltageR;
  final double? voltageS;
  final double? voltageT;
  final double? currentR;
  final double? currentS;
  final double? currentT;
  final int? userId;
  final bool isSynced;
  final DateTime? createdAt;

  ElectricalLog({
    this.id,
    required this.date,
    required this.shift,
    this.currentPower,
    this.kwhWbp,
    this.kwhLwbp,
    this.kwhKvarh,
    this.voltageR,
    this.voltageS,
    this.voltageT,
    this.currentR,
    this.currentS,
    this.currentT,
    this.userId,
    this.isSynced = false,
    this.createdAt,
  });

  factory ElectricalLog.fromJson(Map<String, dynamic> json) {
    return ElectricalLog(
      id: json['id'],
      date: json['date'] ?? '',
      shift: json['shift'] ?? 1,
      currentPower: json['current_power']?.toDouble(),
      kwhWbp: json['kwh_wbp']?.toDouble(),
      kwhLwbp: json['kwh_lwbp']?.toDouble(),
      kwhKvarh: json['kwh_kvarh']?.toDouble(),
      voltageR: json['voltage_r']?.toDouble(),
      voltageS: json['voltage_s']?.toDouble(),
      voltageT: json['voltage_t']?.toDouble(),
      currentR: json['current_r']?.toDouble(),
      currentS: json['current_s']?.toDouble(),
      currentT: json['current_t']?.toDouble(),
      userId: json['user_id'],
      isSynced: json['is_synced'] == 1,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'date': date,
      'shift': shift,
      'current_power': currentPower,
      'kwh_wbp': kwhWbp,
      'kwh_lwbp': kwhLwbp,
      'kwh_kvarh': kwhKvarh,
      'voltage_r': voltageR,
      'voltage_s': voltageS,
      'voltage_t': voltageT,
      'current_r': currentR,
      'current_s': currentS,
      'current_t': currentT,
      'user_id': userId,
      'is_synced': isSynced ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

/// Water Log Entity
class WaterLog {
  final int? id;
  final String date;
  final int shift;
  final double? pamMeter;
  final double? deepwellMeter;
  final double? groundTankLevel;
  final double? roofTankLevel;
  final double? boosterPressure;
  final double? flowMeterReading;
  final int? userId;
  final bool isSynced;
  final DateTime? createdAt;

  WaterLog({
    this.id,
    required this.date,
    required this.shift,
    this.pamMeter,
    this.deepwellMeter,
    this.groundTankLevel,
    this.roofTankLevel,
    this.boosterPressure,
    this.flowMeterReading,
    this.userId,
    this.isSynced = false,
    this.createdAt,
  });

  factory WaterLog.fromJson(Map<String, dynamic> json) {
    return WaterLog(
      id: json['id'],
      date: json['date'] ?? '',
      shift: json['shift'] ?? 1,
      pamMeter: json['pam_meter']?.toDouble(),
      deepwellMeter: json['deepwell_meter']?.toDouble(),
      groundTankLevel: json['ground_tank_level']?.toDouble(),
      roofTankLevel: json['roof_tank_level']?.toDouble(),
      boosterPressure: json['booster_pressure']?.toDouble(),
      flowMeterReading: json['flow_meter_reading']?.toDouble(),
      userId: json['user_id'],
      isSynced: json['is_synced'] == 1,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'date': date,
      'shift': shift,
      'pam_meter': pamMeter,
      'deepwell_meter': deepwellMeter,
      'ground_tank_level': groundTankLevel,
      'roof_tank_level': roofTankLevel,
      'booster_pressure': boosterPressure,
      'flow_meter_reading': flowMeterReading,
      'user_id': userId,
      'is_synced': isSynced ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

/// Checklist Entity
class Checklist {
  final int? id;
  final String date;
  final int shift;
  final String? gensetCondition;
  final String? gensetOperational;
  final String? liftCondition;
  final String? liftOperational;
  final String? hydrantCondition;
  final String? hydrantOperational;
  final String? drainageCondition;
  final String? drainageOperational;
  final String? waterSystemCondition;
  final String? waterSystemOperational;
  final String? fireAlarmCondition;
  final String? fireAlarmOperational;
  final String? otherNotes;
  final int? userId;
  final bool isSynced;
  final DateTime? createdAt;

  Checklist({
    this.id,
    required this.date,
    required this.shift,
    this.gensetCondition,
    this.gensetOperational,
    this.liftCondition,
    this.liftOperational,
    this.hydrantCondition,
    this.hydrantOperational,
    this.drainageCondition,
    this.drainageOperational,
    this.waterSystemCondition,
    this.waterSystemOperational,
    this.fireAlarmCondition,
    this.fireAlarmOperational,
    this.otherNotes,
    this.userId,
    this.isSynced = false,
    this.createdAt,
  });

  factory Checklist.fromJson(Map<String, dynamic> json) {
    return Checklist(
      id: json['id'],
      date: json['date'] ?? '',
      shift: json['shift'] ?? 1,
      gensetCondition: json['genset_condition'],
      gensetOperational: json['genset_operational'],
      liftCondition: json['lift_condition'],
      liftOperational: json['lift_operational'],
      hydrantCondition: json['hydrant_condition'],
      hydrantOperational: json['hydrant_operational'],
      drainageCondition: json['drainage_condition'],
      drainageOperational: json['drainage_operational'],
      waterSystemCondition: json['water_system_condition'],
      waterSystemOperational: json['water_system_operational'],
      fireAlarmCondition: json['fire_alarm_condition'],
      fireAlarmOperational: json['fire_alarm_operational'],
      otherNotes: json['other_notes'],
      userId: json['user_id'],
      isSynced: json['is_synced'] == 1,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'date': date,
      'shift': shift,
      'genset_condition': gensetCondition,
      'genset_operational': gensetOperational,
      'lift_condition': liftCondition,
      'lift_operational': liftOperational,
      'hydrant_condition': hydrantCondition,
      'hydrant_operational': hydrantOperational,
      'drainage_condition': drainageCondition,
      'drainage_operational': drainageOperational,
      'water_system_condition': waterSystemCondition,
      'water_system_operational': waterSystemOperational,
      'fire_alarm_condition': fireAlarmCondition,
      'fire_alarm_operational': fireAlarmOperational,
      'other_notes': otherNotes,
      'user_id': userId,
      'is_synced': isSynced ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

/// QR Location Entity
class QrLocation {
  final int? id;
  final String qrCode;
  final String locationName;
  final String? equipmentType;
  final String? description;
  final double? latitude;
  final double? longitude;

  QrLocation({
    this.id,
    required this.qrCode,
    required this.locationName,
    this.equipmentType,
    this.description,
    this.latitude,
    this.longitude,
  });

  factory QrLocation.fromJson(Map<String, dynamic> json) {
    return QrLocation(
      id: json['id'],
      qrCode: json['qr_code'] ?? '',
      locationName: json['location_name'] ?? '',
      equipmentType: json['equipment_type'],
      description: json['description'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'qr_code': qrCode,
      'location_name': locationName,
      'equipment_type': equipmentType,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
