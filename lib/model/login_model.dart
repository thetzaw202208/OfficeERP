class MyModel {
  String? a;
  String? b;
  String? c;
  String? d;
  String? e;

  String? f;
  String? g;
  String? h;
  String? i;
  String? j;
  String? k;
  String? l;
  String? m;
  String? n;

  MyModel(
      {this.a,
      this.b,
      this.c,
      this.d,
      this.e,
      this.f,
      this.g,
      this.h,
      this.i,
      this.j,
      this.k,
      this.l,
      this.m,
      this.n});

  MyModel.fromJson(Map<String, dynamic> json) {
    a = json['UserID'];
    b = json['UserCode'];
    c = json['UserName'];
    d = json['Email'];
    e = json['Ref_Type'];
    f = json['Ref_ID'];
    g = json['AdminRoleID'];
    h = json['AdminRoleCode'];
    i = json['CashRoleID'];
    j = json['CashRoleCode'];
    k = json['DepartmentID'];
    l = json['DepartmentName'];
    m = json['BranchCode'];
    n = json['Gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['a'] = this.a;
    data['b'] = this.b;
    data['c'] = this.c;
    data['d'] = this.d;
    data['e'] = this.e;
    data['f'] = this.f;
    data['g'] = this.g;
    data['h'] = this.h;
    data['i'] = this.i;
    data['j'] = this.j;
    data['k'] = this.k;
    data['l'] = this.l;
    data['m'] = this.m;
    data['n'] = this.n;

    return data;
  }
}
