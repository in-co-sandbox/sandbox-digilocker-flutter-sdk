enum Events {
  initialized('in.co.sandbox.kyc.digilocker_sdk.initialized'),
  ready('in.co.sandbox.kyc.digilocker_sdk.ready'),
  closed('in.co.sandbox.kyc.digilocker_sdk.session.closed'),
  completed('in.co.sandbox.kyc.digilocker_sdk.session.completed'),
  failed('in.co.sandbox.kyc.digilocker_sdk.session.failed');

  final String value;
  const Events(this.value);
}
