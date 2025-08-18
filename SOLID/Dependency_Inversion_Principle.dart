abstract class MessageSender { // Abstraction
  void send(String message);
}

class EmailSender implements MessageSender { 
  @override
  void send(String message) => print("Sending Email: $message");
}

class SmsSender implements MessageSender {
  @override
  void send(String message) => print("Sending SMS: $message");
}

class NotificationService { // High-level depends on abstraction
  final MessageSender sender;

  NotificationService(this.sender);

  void notifyUser(String message) {
    sender.send(message);
  }
}

void main() {
  NotificationService emailService = NotificationService(EmailSender());
  emailService.notifyUser("Hello via Email!");

  NotificationService smsService = NotificationService(SmsSender());
  smsService.notifyUser("Hello via SMS!");
}
