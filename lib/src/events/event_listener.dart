/// An abstract listener for receiving Digilocker SDK events.
///
/// Implement this class to handle events emitted by the Digilocker SDK.
abstract class EventListener {
  /// Called when an event occurs in the Digilocker SDK.
  ///
  /// [event] is a map containing event data.
  void onEvent(Map<String, dynamic> event);
}
