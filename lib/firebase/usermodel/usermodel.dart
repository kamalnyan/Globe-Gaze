class userModel{
   final String? id;
   final String fullname;
   final String email;
   final String phone;
   final String password;
  const userModel({
    this.id,
    required this.fullname,
    required this.email,
    required this.phone,
    required this.password
});
  toJson(){
    return{
      "Fullname":fullname,
      "Email":email,
      "Phone":phone,
      "Password":password
    };
  }
}