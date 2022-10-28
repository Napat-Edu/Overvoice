class UserDetails
{
  String? displayName;
  String? email;
  String? photoURL;

  //constructor
  UserDetails({this.displayName, this.email, this.photoURL});

  //create map
  UserDetails.fromJson(Map<String, dynamic> json)
  {
    displayName = json["displayName"];
    email = json["email"];
    photoURL = json["photoURL"];
  }

  Map<String, dynamic> toJson()
  {
    //object to data
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["displayName"] = displayName;
    data["email"] = email;
    data["photoURL"] = photoURL;

    return data;
  }
}