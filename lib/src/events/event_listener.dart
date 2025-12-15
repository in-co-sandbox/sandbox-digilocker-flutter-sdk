/// An abstract listener for receiving DigiLocker SDK events.
///
/// Implement this class to handle events emitted by the DigiLocker SDK.
abstract class EventListener {
  /// Called when an event occurs in the DigiLocker SDK.
  ///
  /// [event] is a map containing event data.
  void onEvent(Map<String, dynamic> event);
}
