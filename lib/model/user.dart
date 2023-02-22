class User{
    final String email;
    final String firstName;
    final String lastName;

    User(this.email, this.firstName, this.lastName);

    String get getEmail => this.email;
    String get getFirstName => this.firstName;
    String get getLastName => this.lastName;
}