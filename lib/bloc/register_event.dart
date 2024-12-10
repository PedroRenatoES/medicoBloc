abstract class RegisterEvent {}

class RegisterButtonPressed extends RegisterEvent {
  final Map<String, dynamic> formData;

  RegisterButtonPressed(this.formData);
}
