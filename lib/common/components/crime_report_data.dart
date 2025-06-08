class CrimeFormData {
  String? subject;
  String? crimeDescription;
  String? date;
  bool isLocationEnabled;
  double? latitude;
  double? longitude;

  
  CrimeFormData({
    this.subject,
    this.crimeDescription,
    this.date,
    this.isLocationEnabled = false,
    this.latitude,
    this.longitude,
  });
}