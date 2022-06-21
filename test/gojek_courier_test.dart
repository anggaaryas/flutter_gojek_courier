import 'package:flutter_test/flutter_test.dart';
import 'package:gojek_courier/gojek_courier.dart';
import 'package:gojek_courier/src/gojek_courier_platform_interface.dart';
import 'package:gojek_courier/src/gojek_courier_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGojekCourierPlatform 
    with MockPlatformInterfaceMixin
    implements GojekCourierPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final GojekCourierPlatform initialPlatform = GojekCourierPlatform.instance;

  test('$MethodChannelGojekCourier is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGojekCourier>());
  });

  test('getPlatformVersion', () async {
    GojekCourier gojekCourierPlugin = GojekCourier();
    MockGojekCourierPlatform fakePlatform = MockGojekCourierPlatform();
    GojekCourierPlatform.instance = fakePlatform;
  
    expect(await gojekCourierPlugin.getPlatformVersion(), '42');
  });
}
