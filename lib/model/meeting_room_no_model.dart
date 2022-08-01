class MeetingRoomNo {
  int ID;
  String HEADERNAME;
  String CODEDESP;
  String CODEVALUE;
  bool ACTIVE;
  int SORTORDER;
  String RelatedCode;
  MeetingRoomNo(
    this.ID,
    this.HEADERNAME,
    this.CODEDESP,
    this.CODEVALUE,
    this.ACTIVE,
    this.SORTORDER,
    this.RelatedCode,
  );
  factory MeetingRoomNo.fromJson(dynamic json) {
    return MeetingRoomNo(
      json['ID'] as int,
      json['HEADERNAME'] as String,
      json['CODEDESP'] as String,
      json['CODEVALUE'] as String,
      json['ACTIVE'] as bool,
      json['SORTORDER'] as int,
      json['RelatedCode'] as String,
    );
  }
  @override
  String toString() {
    return '{  ${this.ID},${this.HEADERNAME},${this.CODEDESP},${this.CODEVALUE},${this.ACTIVE},${this.SORTORDER},${this.RelatedCode}, }';
  }
}
