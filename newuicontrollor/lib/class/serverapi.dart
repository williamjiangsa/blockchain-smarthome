class ServerAPI {
  List<dynamic> abi;
  String contractAddress;
  List<dynamic> keyObject;




  ServerAPI (
      {this.abi,
      this.contractAddress,
      this.keyObject});
      


  factory ServerAPI.fromJson(Map<String, dynamic> json) {
    return ServerAPI(
      abi: json['abi'],
      contractAddress: json['contractAddress'],
      keyObject: json['keyObject'],
    );
  }
}