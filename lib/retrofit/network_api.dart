import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
import 'package:zomox_driver/model/change_password_model.dart';
import 'package:zomox_driver/model/check_otp_model.dart';
import 'package:zomox_driver/model/delivery_zone_model.dart';
import 'package:zomox_driver/model/driver_current_order_model.dart';
import 'package:zomox_driver/model/driver_earning_model.dart';
import 'package:zomox_driver/model/driver_order_history_model.dart';
import 'package:zomox_driver/model/driver_order_model.dart';
import 'package:zomox_driver/model/driver_status_change_model.dart';
import 'package:zomox_driver/model/driver_support_model.dart';
import 'package:zomox_driver/model/forgot_password_model.dart';
import 'package:zomox_driver/model/login_driver_detail_model.dart';
import 'package:zomox_driver/model/login_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:zomox_driver/model/register_model.dart';
import 'package:zomox_driver/model/resend_otp_model.dart';
import 'package:zomox_driver/model/set_delivery_zone_model.dart';
import 'package:zomox_driver/model/setting_model.dart';
import 'package:zomox_driver/model/update_driver_model.dart';
import 'package:zomox_driver/model/update_image_model.dart';
import 'package:zomox_driver/model/update_lat_lang_model.dart';
import 'package:zomox_driver/model/upload_document_model.dart';
import 'package:zomox_driver/retrofit/apis.dart';

part 'network_api.g.dart';

@RestApi(baseUrl: Apis.baseUrl)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @POST(Apis.driver_login)
  Future<LoginModel> loginRequest(@Body() body);

  @POST(Apis.driver_register)
  Future<RegisterModel> registerRequest(@Body() body);

  @GET(Apis.driver_setting)
  Future<SettingModel> settingRequest();

  @POST(Apis.check_otp)
  Future<CheckOtpModel> checkOtpRequest(@Body() body);

  @POST(Apis.update_document)
  Future<UploadDocumentModel> uploadDocumentRequest(@Body() body);

  @GET(Apis.delivery_zone)
  Future<DeliveryZoneModel> deliveryZoneRequest();

  @POST(Apis.set_location)
  Future<SetDeliveryZoneModel> setDeliveryZoneRequest(@Body() body);

  @POST(Apis.update_driver)
  Future<UpdateDriverModel> updateDriverRequest(@Body() body);

  @GET(Apis.driver_detail)
  Future<LoginDriverDetailModel> loginDriverDetailRequest();

  @POST(Apis.update_driver_image)
  Future<UpdateImageModel> updateImageRequest(@Body() body);

  @POST(Apis.delivery_person_change_password)
  Future<ChangePasswordModel> changePasswordRequest(@Body() body);

  @GET(Apis.earning)
  Future<DriverEarningModel> driverEarningRequest();

  @GET(Apis.driver_order)
  Future<DriverOrderModel> driverOrderRequest();

  @POST(Apis.driver_status_change)
  Future<DriverStatusChangeModel> driverStatusChangeRequest(@Body() body);

  @POST(Apis.driver_update_latLang)
  Future<UpdateLatLangModel>  driverUpdateLatLangRequest(@Body() body);

  @GET(Apis.driver_order_history)
  Future<DriverOrderHistoryModel> driverOrderHistoryRequest();

  @GET(Apis.driver_support)
  Future<DriverSupportModel> driverSupportRequest();

  @GET(Apis.driver_Current_Order)
  Future<DriverCurrentOrderModel> driverCurrentOrderRequest();

  @POST(Apis.resend_otp)
  Future<ResendOtpModel> resendOtpRequest(@Body() body);

  @POST(Apis.forgot_password)
  Future<ForgotPasswordModel> forgotPasswordRequest(@Body() body);
}


