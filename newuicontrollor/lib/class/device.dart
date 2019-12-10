class Device{
  String id;
  String seller;
  String name;
  String description;
  String switchon; //0 means off, 100 means on
  String deviceid;
  String color;
  String intensity; // 0-100
  String classnum; //lightbulbs for 0, plugs for 1.
  String lastcomtime;

  Device(
      {this.id,
      this.seller,
      this.name,
      this.description,
      this.switchon,
      this.deviceid,
      this.color,
      this.intensity,
      this.classnum,
      this.lastcomtime});

  factory Device.fromJson(Map<String, dynamic> json) {
    return new Device(
      id: json['id'],
      seller: json['seller'],
      name: json['name'],
      description: json['description'],
      switchon: json['switchon'],
      deviceid: json['deviceid'],
      color: json['color'],
      intensity: json['intensity'],
      classnum: json['classnum'],
      lastcomtime: json['lastcomtime'],
    );
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'seller': seller,
        'name': name,
        'description': description,
        'switchon': switchon,
        'deviceid': deviceid,
        'color': color,
        'intensity': intensity,
        'classnum': classnum,
        'lastcomtime': lastcomtime,
      };
}
