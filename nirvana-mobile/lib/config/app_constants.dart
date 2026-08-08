class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://api.nirvanaboutique.com';
  static const String apiVersion = '/api/v1';
  
  // API Endpoints
  static const String loginEndpoint = '$apiVersion/auth/login';
  static const String logoutEndpoint = '$apiVersion/auth/logout';
  static const String userEndpoint = '$apiVersion/user';
  
  // Inspection Modules
  static const String lvmdpEndpoint = '$apiVersion/inspections/lvmdp';
  static const String stpEndpoint = '$apiVersion/inspections/stp';
  static const String electricalEndpoint = '$apiVersion/inspections/electrical';
  static const String waterEndpoint = '$apiVersion/inspections/water';
  static const String checklistEndpoint = '$apiVersion/inspections/checklist';
  
  // Sync Endpoints
  static const String syncEndpoint = '$apiVersion/sync';
  static const String exportPdfEndpoint = '$apiVersion/export/pdf';
  static const String exportExcelEndpoint = '$apiVersion/export/excel';
  
  // Time Slots
  static const List<String> inspectionTimes = [
    '00:00', '05:00', '07:00', '09:00', '11:00', 
    '13:00', '15:00', '17:00', '19:00', '21:00', '22:00'
  ];
  
  // Shift Times
  static const String shift1Start = '07:00';
  static const String shift1End = '15:00';
  static const String shift2Start = '15:00';
  static const String shift2End = '22:00';
  static const String nightShiftStart = '22:00';
  static const String nightShiftEnd = '07:00';
  
  // Encryption Key (should be stored securely in production)
  static const String encryptionKey = 'nirvana_secure_key_2024_engineering';
  static const String encryptionIv = 'nirvana_iv_2024';
  
  // Local Storage Keys
  static const String userDataKey = 'user_data';
  static const String authTokenKey = 'auth_token';
  static const String offlineDataKey = 'offline_data';
  static const String lastSyncKey = 'last_sync_timestamp';
  
  // Status
  static const String statusOK = 'OK';
  static const String statusNOK = 'N.OK';
}
