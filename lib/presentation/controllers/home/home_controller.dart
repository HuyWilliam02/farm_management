import 'dart:math';

import 'package:get/get.dart';
import 'package:itfsd/base/base_controller.dart';
import 'package:itfsd/data/model/editprofile/edit_profile.dart';
import 'package:itfsd/data/model/login/login_model.dart';
import 'package:itfsd/data/model/news/news_model.dart';
import 'package:itfsd/data/network/api/edit_profile/editprofile.dart';
import 'package:itfsd/presentation/page/home/harvested_crop_list_view.dart';
import 'package:itfsd/presentation/page/home/notification/notification_Item.dart';
import 'package:itfsd/presentation/page/viewlandfull/tab_viewland/lands_detail.dart';
import 'package:timezone/timezone.dart' as tz;

class HomeController extends BaseController {
  //TODO: Implement HomeController
  Rx<String> avatar = "".obs;
  Rx<bool> isLoading = false.obs;
  String accessToken = "";
  Rx<LoginModel?> loginModel = Rx<LoginModel?>(null);
  int _notificationId = 0;
  final List<AgriculturalNotification> agriculturalNotificationList = [
    AgriculturalNotification(
      id: 1,
      title: "Cảnh báo mưa lớn",
      content:
          "Dự kiến có mưa lớn vào ngày mai. Hãy chuẩn bị biện pháp cần thiết.",
      timestamp:
          DateTime.now().add(Duration(days: 1, hours: Random().nextInt(24))),
      imageUrl: "assets/images/weather.jpg",
    ),
    AgriculturalNotification(
      id: 2,
      title: "Nhắc nhở về mùa thu hoạch",
      content: "Mùa thu hoạch lúa bắt đầu vào tuần sau. Chuẩn bị sẵn sàng!",
      timestamp:
          DateTime.now().add(Duration(days: 7, hours: Random().nextInt(24))),
      imageUrl: "lib/app/resources/ai/avatars/bot.jpg",
    ),
    AgriculturalNotification(
      id: 3,
      title: "Cảnh báo giảm nhiệt độ",
      content:
          "Nhiệt độ sẽ giảm đáng kể trong những ngày tới. Bảo vệ cây trồng của bạn.",
      timestamp:
          DateTime.now().add(Duration(days: 3, hours: Random().nextInt(24))),
      imageUrl: "assets/images/weather.jpg",
    ),
    AgriculturalNotification(
      id: 4,
      title: "Thông báo về sâu bệnh",
      content:
          "Phát hiện sâu bệnh trong vườn rau của bạn. Sử dụng thuốc phòng trị ngay.",
      timestamp:
          DateTime.now().add(Duration(days: 5, hours: Random().nextInt(24))),
      imageUrl: "assets/images/iot.jpg",
    ),
    AgriculturalNotification(
      id: 5,
      title: "Dự báo nắng nóng",
      content:
          "Dự kiến có đợt nắng nóng kéo dài. Hãy tăng cường tưới nước cho cây trồng.",
      timestamp:
          DateTime.now().add(Duration(days: 2, hours: Random().nextInt(24))),
      imageUrl: "assets/images/weather.jpg",
    ),
    AgriculturalNotification(
      id: 6,
      title: "Nhắc nhở về phân bón",
      content:
          "Đến lúc bổ sung phân bón cho đồng lúa của bạn. Sử dụng phân hữu cơ để tăng chất lượng.",
      timestamp:
          DateTime.now().add(Duration(days: 10, hours: Random().nextInt(24))),
      imageUrl: "lib/app/resources/ai/avatars/bot.jpg",
    ),
    AgriculturalNotification(
      id: 6,
      title: "Dự báo cơn bão",
      content:
          "Cơn bão dự kiến sẽ ảnh hưởng đến khu vực của bạn. Hãy chuẩn bị sẵn sàng.",
      timestamp:
          DateTime.now().add(Duration(days: 15, hours: Random().nextInt(24))),
      imageUrl: "assets/images/weather.jpg",
    ),
    AgriculturalNotification(
      id: 7,
      title: "Nhắc nhở về kiểm tra hạt giống",
      content:
          "Kiểm tra hạt giống trước khi gieo. Chọn hạt giống chất lượng để đảm bảo mùa vụ thành công.",
      timestamp:
          DateTime.now().add(Duration(days: 4, hours: Random().nextInt(24))),
      imageUrl: "lib/app/resources/ai/avatars/bot.jpg",
    ),
    AgriculturalNotification(
      id: 8,
      title: "Dự báo đợt lạnh kéo dài",
      content: "Dự kiến có đợt lạnh kéo dài. Bảo vệ cây trồng nhạy cảm.",
      timestamp:
          DateTime.now().add(Duration(days: 8, hours: Random().nextInt(24))),
      imageUrl: "assets/images/weather.jpg",
    ),
    AgriculturalNotification(
      id: 9,
      title: "Thông báo về chất lượng đất",
      content:
          "Kiểm tra chất lượng đất trước khi gieo. Bổ sung chất dinh dưỡng nếu cần thiết.",
      timestamp:
          DateTime.now().add(Duration(days: 6, hours: Random().nextInt(24))),
      imageUrl: "lib/app/resources/ai/avatars/bot.jpg",
    ),
    AgriculturalNotification(
      id: 10,
      title: "Dự báo tình trạng nước",
      content:
          "Kiểm tra tình trạng nước tưới cho cây trồng. Đảm bảo có đủ nguồn nước cho mùa vụ.",
      timestamp:
          DateTime.now().add(Duration(days: 11, hours: Random().nextInt(24))),
      imageUrl: "assets/images/iot.jpg",
    ),
    AgriculturalNotification(
      id: 11,
      title: "Nhắc nhở về thuốc trừ sâu tự nhiên",
      content:
          "Sử dụng thuốc trừ sâu tự nhiên để bảo vệ cây trồng mà không gây hại cho môi trường.",
      timestamp:
          DateTime.now().add(Duration(days: 13, hours: Random().nextInt(24))),
      imageUrl: "assets/images/iot.jpg",
    ),
    AgriculturalNotification(
      id: 12,
      title: "Thông báo về lịch trình tưới cây",
      content:
          "Lịch trình tưới cây sẽ thay đổi từ tuần sau. Hãy điều chỉnh lịch của bạn.",
      timestamp:
          DateTime.now().add(Duration(days: 9, hours: Random().nextInt(24))),
      imageUrl: "lib/app/resources/ai/avatars/bot.jpg",
    ),
    AgriculturalNotification(
      id: 13,
      title: "Dự báo ngày hỗ trợ nông dân",
      content:
          "Ngày hỗ trợ nông dân sẽ diễn ra vào thứ Bảy tuần tới. Hãy tham gia để có cơ hội học hỏi và nhận hỗ trợ.",
      timestamp:
          DateTime.now().add(Duration(days: 12, hours: Random().nextInt(24))),
      imageUrl: "assets/logo/logo.png",
    ),
    AgriculturalNotification(
      id: 14,
      title: "Cảnh báo về sương mù",
      content:
          "Cảnh báo về sương mù dày đặc sáng sớm. Hạn chế hoạt động ngoài trời trong thời gian này.",
      timestamp:
          DateTime.now().add(Duration(days: 14, hours: Random().nextInt(24))),
      imageUrl: "assets/images/weather.jpg",
    ),
  ];
  var newsArticles = <NewsArticle>[
    NewsArticle(
      title:
          "Hệ sinh thái ITFSD đạt giải Á quân tại cuộc thi “DESIGN THINKINGS OPEN INNOVATION 2023 COMPETITION” Cuộc thi do Làng Tư duy Thiết kế – Techfest VN (Design Thinking Village) tổ chức theo chủ trương của Bộ KHCN về ĐMST",
      description:
          "“HỆ SINH THÁI ITFSD” đạt giải Á quân tại cuộc thi “DESIGN THINKINGS OPEN INNOVATION 2023 COMPETITION” Cuộc thi do Làng Tư duy Thiết kế – Techfest VN (Design Thinking Village) tổ chức theo chủ trương của Bộ KHCN về ĐMST, dưới sự chỉ đạo của Cục Phát triển Thị trường, Doanh Nghiệp Khoa học và Công Nghệ, Trung tâm Hỗ trợ KN Sáng tạo Quốc Gia (NSSC) Sau hơn 6 tháng tranh tài tại Design Thinking – Open Innovation 2023, ITFSD xuất sắc mang về giải Á quân chung cuộc tại chung kết cuộc thi Design Thinking – Open Innovation tại 2023 diễn ra tại Trường ĐH Nguyễn Tất Thành vào sáng ngày 09/09/2023. Đây là “sân chơi học thuật” do Trường ĐH Nguyễn Tất Thành phối hợp cùng Làng Tư duy thiết kế Đổi mới Sáng tạo cùng tổ chức với mục đích thúc đẩy tinh thần đổi mới sáng tạo và tìm kiếm, lựa chọn các dự án có ý tưởng sáng tạo, có tính khả thi để tư vấn hỗ trợ, ươm tạo, những giá trị và lợi ích cho cộng đồng, qua đó thúc đẩy tinh thần đam mê khởi nghiệp cho các thanh niên và sinh viên ngay từ khi còn ngồi trên ghế nhà trường. Hệ sinh thái ITFSD và ý tưởng chính của dự án Hệ sinh thái ITFSD (Information Technology for Sustainable Development) là một dự án tập trung vào giải quyết các vấn đề liên quan đến cơ sở hạ tầng, cơ sở vật chất kỹ thuật và ứng dụng công nghệ để nâng cao hiệu suất và chất lượng. Dự án này cung cấp một hệ thống quản lý toàn diện cho doanh nghiệp, đơn vị dịch vụ, người tiêu dùng, nông trại và những người có nhu cầu sử dụng sản phẩm. Mục tiêu của sản phẩm: Giảm thiểu rủi ro trong quá trình sản xuất và cảnh báo kịp thời để tránh sự cố không mong muốn. Tiết kiệm thời gian và chi phí trong quá trình vận chuyển hàng hóa. Hỗ trợ quản lý lưu kho và vận chuyển. Tạo ra một nơi mà người dùng có thể trao đổi thông tin, chia sẻ kinh nghiệm và mua bán sản phẩm chất lượng. Truy xuất nguồn gốc sản phẩm một cách chính xác để đảm bảo sự yên tâm của người tiêu dùng. Các giải pháp của hệ thống ITFSD Dự án ITFSD cung cấp nhiều giải pháp khác nhau để giải quyết các vấn đề liên quan đến doanh nghiệp, nông trại và các lĩnh vực khác. Một số ví dụ về các giải pháp của hệ thống ITFSD bao gồm: 1. Quản lý nông trại: Hệ thống giúp quản lý thông tin về nông trại, bao gồm quản lý công việc sản xuất, cảnh báo kịp thời về các sự cố, quản lý lưu trữ và truy xuất nguồn gốc sản phẩm nông nghiệp. 2. Quản lý kho và xe: Hệ thống hỗ trợ quản lý thông tin về kho bãi và xe vận chuyển, bao gồm quản lý thông tin xe, quản lý lô hàng, gửi thông báo thời gian di chuyển dự kiến và thời gian lô hàng tới điểm nhận. 3. Truy xuất nguồn gốc: Hệ thống giúp truy xuất nguồn gốc sản phẩm một cách chính xác, đảm bảo người tiêu dùng có thể yên tâm về chất lượng và nguồn gốc của sản phẩm mình mua. 4. Sàn thương mại điện tử: Hệ thống cung cấp một nền tảng thương mại điện tử cho người dùng, nơi họ có thể mua bán những mặt hàng chất lượng và trao đổi thông tin với nhau. 5. Diễn đàn: Hệ thống cung cấp một diễn đàn cho mọi người có thể trao đổi thông tin, chia sẻ kinh nghiệm và hỗ trợ nhau trong việc sử dụng các giải pháp công nghệ. Tại giai đoạn giải Design Thinking, dự án ITFSD của chúng tôi là niềm tự hào của cả đội cũng như khoa CNTT-LHU. Mọi nỗ lực của chúng tôi, tất cả những góp ý từ phía các giảng viên LHU, các mentor đã đồng hành cùng chúng tôi tại cuộc thi đã góp phần nào vào công cuộc phát triển và đổi mới hệ sinh thái Techfesh Việt Nam. Nhận giải á quân trong cuộc thi là một thành tựu đáng tự hào. Chúng tôi sẽ tiếp tục phát triển thêm và có thêm những thành tựu khác tại những sân chơi công nghệ khác. Chúc mừng chúng ta.",
      url:
          "https://i.ex-cdn.com/nongnghiep.vn/files/content/2023/11/20/dsc00045-144033_703-144034-141751.jpg",
      source: Source(
        name: "admin",
      ),
      publishedAt: DateTime.now(),
      content:
          "Để ngành NN-PTNT phát triển bền vững, cần những cơ chế, chính sách chiến lược, căn cơ, lâu dài nhằm phát triển nguồn nhân lực khoa học công nghệ phù hợp thực tiễn.",
      urlToImage: "https://lhu.edu.vn/Data/News/166/images/2023/IMG_1304.JPG",
    ),
    NewsArticle(
      title: "Chuyến tham quan công ty Long An: Nông nghiệp và thực phẩm",
      description:
          "Chuyến đi Long An để lấy ý tưởng và tham quan công ty trong lĩnh vực nông nghiệp và thực phẩm là một trải nghiệm thú vị và bổ ích. Long An là một tỉnh nằm ở khu vực Đồng bằng Sông Cửu Long, với nhiều tiềm năng phát triển nông nghiệp và công nghiệp. Chúng tôi đã có cơ hội tham quan một số công ty tại đây để tìm hiểu thêm về nhu cầu và mong muốn của khách hàng trong lĩnh vực nông nghiệp và thực phẩm, và áp dụng vào sản phẩm công nghệ của chúng tôi. Đầu tiên, chúng tôi tham quan một trang trại nuôi tôm sạch. Trang trại này sử dụng công nghệ tiên tiến để nuôi tôm sạch và đảm bảo chất lượng cao. Chúng tôi được giới thiệu về quy trình nuôi tôm và được thực hiện một số thử nghiệm sản phẩm. Điều này giúp chúng tôi hiểu rõ hơn về xu hướng sử dụng sản phẩm nông nghiệp sạch và nhu cầu của khách hàng về thực phẩm sạch và an toàn cho sức khỏe. Tiếp theo, chúng tôi đã tham quan một trang trại. Trang trại này sử dụng công nghệ tiên tiến  đảm bảo chất lượng cao. Chúng tôi được giới thiệu về quy trình nuôi gà và được thực hiện một số thử nghiệm sản phẩm. Điều này giúp chúng tôi hiểu rõ hơn về nhu cầu của khách hàng về thực phẩm sạch và an toàn cho sức khỏe. Cuối cùng, chúng tôi đã tham quan một công ty sản xuất thực phẩm từ các loại rau củ quả sạch. Công ty này sử dụng công nghệ tiên tiến để sản xuất các sản phẩm từ các loại rau củ quả đạt tiêu chuẩn chất lượng cao. Chúng tôi đã được giới thiệu về quy trình sản xuất và được thực hiện một số thử nghiệm sản phẩm. Điều này giúp chúng tôi hiểu rõ hơn về nhu cầu của khách hàng về thực phẩm sạch và an toàn cho sức khỏe. Chuyến đi Long An để lấy ý tưởng và tham quan các công ty của khách hàng trong lĩnh vực nông nghiệp và thực phẩm đã giúp chúng tôi hiểu rõ hơn về nhu cầu và mong muốn của khách hàng trong lĩnh vực này. Chúng tôi đã tìm thấy nhiều ý tưởng mới và đưa ra các giải pháp đáp ứng nhu cầu của khách hàng trong các lĩnh vực khác nhau. Chúng tôi hy vọng sẽ có cơ hội phát triển các sản phẩm công nghệ mới và đóng góp vào sự phát triển của ngành nông nghiệp và thực phẩm tại Long An.",
      url:
          "https://i.ex-cdn.com/nongnghiep.vn/files/content/2023/11/20/dsc00045-144033_703-144034-141751.jpg",
      source: Source(
        name: "admin",
      ),
      publishedAt: DateTime.now(),
      content:
          "Để ngành NN-PTNT phát triển bền vững, cần những cơ chế, chính sách chiến lược, căn cơ, lâu dài nhằm phát triển nguồn nhân lực khoa học công nghệ phù hợp thực tiễn.",
      urlToImage:
          "http://itfsd.com:8080/wp-content/uploads/2014/01/340fad987595a5cbfc84-768x576.jpg",
    ),
    NewsArticle(
      title:
          "Ứng dụng khoa học – công nghệ vào sản xuất nông nghiệp: Thành tựu, hạn chế và giải pháp tháo gỡ",
      description:
          "Ứng dụng khoa học – công nghệ (KHCN) hiện đại vào sản xuất nông nghiệp (SXNN) đang là xu hướng chủ đạo, là chìa khóa thành công của các nước có nền nông nghiệp phát triển trên thế giới hiện nay. Ở Việt Nam, kinh tế nông nghiệp đã có sự phát triển tích cực kể từ sau Đổi mới (năm 1986), góp phần nâng cao chất lượng cuộc sống của người nông dân, ổn định kinh tế – xã hội (KTXH) và tạo nền tảng vững chắc để đẩy nhanh quá trình công nghiệp hóa (CNH), hiện đại hóa (HĐH) đất nước. Tuy nhiên, trình độ phát triển kinh tế nông nghiệp nước ta còn rất thấp; sản xuất manh mún, nhỏ lẻ, năng suất, chất lượng chưa cao, giá trị gia tăng thấp. Cùng với đó, SXNN chủ yếu dựa vào các ưu thế về tự nhiên, thâm dụng đất đai và sức lao động nên dễ bị tổn thương trước thiên tai, dịch bệnh và để lại nhiều ảnh hưởng tiêu cực đến môi trường. Chìa khóa để giải quyết những tồn tại, hạn chế này là đẩy nhanh ứng dụng thành tựu KHCN vào SXNN. Nhận thức rõ vấn đề này, những năm qua Đảng, Nhà nước ta đã không ngừng bổ sung, hoàn thiện các chủ trương, chính sách phát triển KHCN, đưa KHCN thực sự là “quốc sách hàng đầu” trong quá trình phát triển KTXH của đất nước. Trong đó, các chủ trương, chính sách đẩy nhanh hoạt động nghiên cứu, chuyển giao, ứng dụng các thành tựu KHCN vào SXNN được quan tâm đặc biệt. Tại Đại hội XIII (năm 2021), trong bối cảnh tình hình mới, Đảng ta khẳng định chủ trương: “Phát triển mạnh mẽ khoa học – công nghệ và đổi mới sáng tạo để tạo bứt phá về năng suất, chất lượng, hiệu quả và sức cạnh tranh trong bối cảnh cuộc Cách mạng công nghiệp lần thứ tư”1. Đối với nông nghiệp, Đại hội đã chỉ rõ: “Đẩy mạnh cơ cấu lại nông nghiệp… phát triển nông nghiệp hàng hóa tập trung quy mô lớn theo hướng hiện đại, vùng chuyên canh hàng hóa chất lượng cao. Phát triển mạnh nông nghiệp ứng dụng công nghệ cao, nông nghiệp hữu cơ, nông nghiệp sinh thái, đạt tiêu chuẩn phổ biến về an toàn thực phẩm…”2. Những quan điểm, chủ trương của Đảng và chính sách, pháp luật của Nhà nước vừa có ý nghĩa định hướng, vừa tạo ra môi trường pháp lý thuận lợi thúc đẩy hoạt động nghiên cứu, ứng dụng KHCN vào SXNN ở nước ta. Một số kết quả đạt được trong ứng dụng khoa học – công nghệ vào sản xuất nông nghiệp thời gian qua Thực tiễn đã chứng minh, việc đẩy nhanh nghiên cứu, ứng dụng KHCN vào sản xuất đã đóng góp rất lớn đến sự phát triển của ngành Nông nghiệp Việt Nam. Theo đánh giá của Bộ Nông nghiệp và Phát triển nông thôn, KHCN và đổi mới sáng tạo đóng góp trên 30% giá trị gia tăng trong SXNN, trong lĩnh vực sản xuất giống cây trồng, vật nuôi đạt 38%. KHCN đã góp phần nâng cao năng suất, chất lượng và sức cạnh tranh của sản phẩm, hàng hóa nông sản trên thị trường trong nước và quốc tế. Trong giai đoạn 2016 – 2021, tổng kim ngạch xuất khẩu nông, lâm, thủy sản của Việt Nam tăng nhanh, đạt 238,81 tỷ USD, trung bình đạt hơn 39,8 tỷ USD/năm, riêng năm 2021 đạt 48,6 tỷ USD. Việc ứng dụng KHCN được thực hiện toàn diện, đồng bộ ở tất cả các lĩnh vực, các khâu của quá trình SXNN và đạt được một số kết quả cụ thể như sau: Một là, ứng dụng KHCN trong chuẩn bị đất, phân bón và ao chuồng chăn nuôi đạt nhiều kết quả tích cực. Đã có nhiều công trình nghiên cứu được ứng dụng vào cải tạo, nâng cao độ phì nhiêu của đất; các loại phân bón hữu cơ, phân vi sinh ứng dụng công nghệ sản xuất mới được sử dụng rất phổ biến đã góp phần cải thiện đáng kể chất lượng đất trồng. Tiêu biểu như nghiên cứu, ứng dụng than sinh học làm từ trấu và vỏ cà phê, sản xuất bằng phương pháp khí hóa nhằm nâng cao chất lượng đất và đánh giá hiệu quả trên các loại cây trồng của Trung tâm Công nghệ sinh học TP. Hồ Chí Minh (2016). Nghiên cứu, sử dụng chế phẩm vi sinh cải tạo đất của Viện Thổ nhưỡng Nông hóa đã được áp dụng vào thực tiễn và sản xuất ở quy mô công nghiệp nhằm cải thiện độ phì nhiêu của đất. Ứng dụng công nghệ nano để sản xuất một số loại phân bón thế hệ mới; sản xuất các chế phẩm ứng dụng làm thuốc bảo vệ thực vật; chế tạo máy phun hiệu năng cao… Việc áp dụng cơ giới hóa SXNN đã giúp cho nông dân giảm chi phí đầu vào, tăng chất lượng sản phẩm, góp phần tăng lợi nhuận khoảng 20 – 30% so với không áp dụng cơ giới hóa3.  Nhiều công trình nghiên cứu sử dụng vi sinh vật bản địa giúp phân hủy và hồi phục đất bị ô nhiễm các chất độc hại như dioxins, thuốc bảo vệ thực vật và kim loại nặng; nghiên cứu phát triển các nhóm vi sinh vật cộng sinh có lợi cho cây trồng trên các vùng đất bị nhiễm mặn, đất phèn… đã được ứng dụng vào thực tiễn. Các nghiên cứu, thiết kế, ứng dụng tiến bộ kỹ thuật (TBKT) hiện đại trong xây dựng ao chuồng cho các loại vật nuôi được thực hiện ngày càng phổ biến; đặc biệt, đã làm chủ công tác nghiên cứu, sản xuất và làm chủ quy trình sử dụng các loại chế phẩm sinh học trong xử lý ao chuồng, nguồn nước và chất thải trong chăn nuôi vừa đem lại hiệu quả kinh tế cao, vừa góp phần bảo vệ môi trường. Hai là, các thành tựu KHCN đã được ứng dụng phổ biến trong chọn tạo được nhiều cây, con giống mới có chất lượng cao, khả năng phòng trừ dịch bệnh, thích ứng tốt với các điều kiện tự nhiên khắc nghiệt. Trong giai đoạn (2013 – 2020), đã có 529 giống mới (trong đó 393 giống cây trồng, 12 giống thủy sản; 82 giống cây lâm nghiệp và 42 giống vật nuôi); 101 TBKT và 85 bằng phát minh sáng chế được công nhận và ứng dụng vào thực tiễn4. Nhiều cây, con giống được lai tạo, chọn lựa bằng công nghệ hiện đại, phương pháp, quy trình kỹ thuật mới đã đưa vào sản xuất đại trà trên quy mô lớn, góp phần làm tăng năng suất và chất lượng của nông phẩm Việt Nam. Nhiều giống cây công nghiệp, cây lâm nghiệp mới được chọn tạo và đưa vào sản xuất đại trà trên cơ sở ứng dụng các thành tựu KHCN hiện đại. Ảnh: Internet. Các công cụ công nghệ sinh học (sinh học phân tử, kỹ thuật di truyền, nuôi cấy mô, chỉ thị phân tử, lập bản đồ – giải trình tự gen, kết hợp các ngành khoa học “omics”…) được sử dụng phổ biến trong chọn tạo giống mới. Tiêu biểu là giống lúa do các nhà khoa học Việt Nam chọn tạocó với thuộc tính ưu việt như: kháng sâu bệnh, chịu hạn, chịu mặn, chịu phèn, cho năng suất, chất lượng cao. Bên cạnh đó, các loại giống cây trồng khác, như: ngô, rau, củ, nấm, hoa… đều ứng dụng phổ biến KHCN trong chọn tạo, đem lại nhiều giống mới ưu việt đưa vào sản xuất. Nhiều giống cây công nghiệp, cây lâm nghiệp mới được chọn tạo và đưa vào sản xuất đại trà trên cơ sở ứng dụng các thành tựu KHCN hiện đại, có gần 65% diện tích canh tác chè toàn quốc sử dụng các giống do Viện Khoa học Nông nghiệp Việt Nam nghiên cứu, chọn tạo5 và hàng trăm giống cây lâm nghiệp mới được công nhận, như: keo lai, keo tai tượng, keo lá tràm, keo lá liềm, sa nhân tím, đàn hương, dẻ ván ăn quả… Với ngành chăn nuôi, đã làm chủ quy trình sản xuất tinh đông lạnh gia súc (trâu, bò, dê, lợn), đồng thời nghiên cứu thành công công nghệ sản xuất phôi, cấy phôi tươi, phôi đông lạnh ở một số loại gia súc (bò, lợn nái sinh sản) và một số loại gà bản địa. Trong lai tạo, chọn giống thủy sản với các tiêu chí chính là tăng trưởng và tỷ lệ sống cao, giai đoạn 2016 – 2020 có 12 giống mới, 65 TBKT và 20 bằng sáng chế được công nhận và chuyển giao vào sản xuất. Việc ứng dụng KHCN mới đã nâng tỷ lệ sống trong giai đoạn ương nuôi cá tra đạt gần 50%, qua đó, từng bước đáp ứng đủ số lượng, chất lượng con giống, với khả năng tăng trưởng nhanh (tăng trên 20%)… Chất lượng con giống tốt đã góp phần nâng cao sản lượng nuôi trồng thủy sản của cả nước, năm 2019 đạt 4,38 triệu tấn, năm 2020 đạt trên 4,56 triệu tấn, năm 2021 đạt 4,75  triệu tấn, vượt mục tiêu đề ra6. Ba là, đã ứng dụng phổ biến các thành tựu KHCN trong chăm sóc cây trồng, vật nuôi và nuôi trồng thủy sản, góp phần nâng cao năng suất lao động. Việc ứng dụng phổ biến các TBKT, máy móc hiện đại, đẩy nhanh cơ giới hóa vừa góp phần giải phóng sức lao động của người nông dân, vừa bảo đảm tính thời vụ, tăng năng suất và giảm tổn thất sau thu hoạch. Số lượng máy móc được sử dụng trong nông nghiệp tăng nhanh, tính đến năm 2019 so với năm 2011 số lượng máy kéo tăng 48%, máy gặt đập liên hợp tăng 79%, máy sấy nông sản tăng 29%; máy chế biến thức ăn gia súc tăng 90,6%; máy chế biến thức ăn thủy sản tăng 2,2 lần; máy phun thuốc trừ sâu tăng 3,1 lần7… Các kỹ thuật canh tác mới trong sản xuất lúa được người nông dân áp dụng rất nhanh, bên cạnh đó, các quy trình kỹ thuật, giải pháp phòng, chống sinh vật gây hại cũng được áp dụng phổ biến. Trong đó, các giải pháp không gây tác hại tới môi trường, bằng việc sử dụng nấm xanh, nấm trắng, nấm Tricoderma, vi khuẩn Bacillus… được ưu tiên. Các mô hình sản xuất thân thiện với môi trường, ứng dụng TBKT mới được triển khai, nhân rộng đến nông dân, như chương trình “3 giảm 3 tăng”, “1 phải 5 giảm” và mô hình “công nghệ sinh thái”, chương trình gieo sạ né rầy… Đã xây dựng và áp dụng có hiệu quả các quy trình thâm canh theo tiêu chuẩn VietGAP đối với nhiều loại cây trồng đã góp phần giảm chi phí sản xuất, phát thải khí nhà kính, sản xuất sản phẩm an toàn so với canh tác truyền thống. Cùng với đó là việc ứng dụng công nghệ 4.0 trong công tác bảo vệ thực vật, như: phần mềm quản lý sinh vật gây hại trong toàn quốc; ứng dụng công nghệ trạm khí tượng tự động dự báo thời tiết và dự báo sinh vật gây hại; ứng dụng bẫy đèn kết nối camera giám sát; thiết bị phun thuốc điều khiển từ xa… Các mô hình SXNN ứng dụng công nghệ cao cũng ngày càng phát triển, đến nay, cả nước có 49 doanh nghiệp (DN) nông nghiệp ứng dụng công nghệ cao. Nhiều DN có trình độ tiên tiến ngang tầm khu vực và thế giới, như: TH Group (sữa), Dabaco (chăn nuôi), Nafoods (trồng, chế biến trái cây), Nam miền Trung (tôm), Vingroup (rau), Ba Huân, Lộc Trời… Trong hoạt động sản xuất, các DN này ứng dụng phổ biến các máy móc, thiết bị công nghệ hiện đại, tự động hóa trong chăm sóc, theo dõi sức khỏe, kiểm soát mọi hoạt động của cây trồng, vật nuôi. Việc vệ sinh chuồng trại chăn nuôi cũng áp dụng các công nghệ tiên tiến nhất, xử lý tự động hoặc sử dụng đệm lót sinh học bảo vệ môi trường… Ngoài ra, các thiết bị, quy trình công nghệ hiện đại đã được ứng dụng trong nghiên cứu, sản xuất và tiêm vắc xin phòng trừ dịch bệnh cho vật nuôi, qua đó, nâng cao năng suất và chất lượng thương phẩm, đồng thời, giảm thiểu chi phí và công sức lao động của bà con nông dân. Bốn là, ứng dụng KHCN trong trong thu hoạch, bảo quản nông phẩm đạt nhiều kết quả tích cực, góp phần hạn chế tổn thất, nâng cao giá trị hàng hóa. Hiện nay, nhiều TBKT, máy móc hiện đại, dây truyền công nghệ tiên tiến đã được sử dụng phổ biến trong thu hoạch và bảo quản nông sản, đặc biệt là ở các vùng SXNN quy mô lớn, tập trung, các DN nông nghiệp ứng dụng công nghệ cao. Trong khâu thu hoạch lúa, vùng đồng bằng sông Cửu Long hiện có mức độ cơ giới hóa đạt trên 82%, vùng Đông Nam Bộ đạt khoảng 70% và khu vực phía trung du miền núi phía Bắc đạt 25%. Tỷ lệ cơ giới hóa trong thu hoạch một số loại nông sản khác trên phạm vi cả nước cũng tăng nhanh: mía khoảng 20%; đốn, hái chè đạt 25%; sấy chủ động 55%8. Các quy trình công nghệ tiên tiến, các chế phẩm sinh học ưu việt, an toàn ngày cảng được sử dụng phổ biến trong bảo quản nông phẩm, như: công nghệ CAS (cells alive system), bảo quản thực phẩm đông lạnh của Nhật Bản; quy trình công nghệ bảo quản rau quả tươi bằng phương pháp khí quyển điều chỉnh CA (controlled atmosphere); bảo quản trái cây bằng màng MA (modified atmosphere); bảo quản bằng chế phẩm tạo màng; bảo quản quả trên cây bằng chế phẩm retaine (AVG)… Trong khâu giết mổ, bảo quản sản phẩm từ chăn nuôi, nhiều tiến bộ KHCN mới đã được sử dụng, vừa bảo đảm vệ sinh an toàn thực phẩm, vừa thể hiện tính nhân văn, nhân đạo với vật nuôi, tiêu biểu, như ở Công ty Cổ phần Masan Nutri-Science (MNS), Công ty Marel của Hà Lan, Công tyP&T… Bên cạnh đó, các quy trình công nghệ hiện đại, các phương pháp bảo quản nông phẩm cũng được sử dụng ở các quy mô và mục đích khác nhau, như: công nghệ đông lạnh CAS (Cells Alive Sytem) được tập đoàn ABI, Nhật Bản chuyển giao; công nghệ plasma lạnh; công nghệ làm mát, đông lạnh; phương pháp đóng gói cải tiến MAP (Modified Atmosphere Packaging) và phương pháp bao gói chân không… Về tồn tại và hạn chế trong ứng dụng khoa học – công nghệ Thứ nhất, quy mô ứng dụng KHCN còn nhỏ bé, số lượng sản phẩm KHCN ứng dụng vào SXNN còn khiêm tốn, chưa tương xứng với yêu cầu phát triển nông nghiệp nước nhà. Cơ bản việc chuyển giao, ứng dụng các thành tựu KHCN vào SXNN ở Việt Nam thời gian qua vẫn còn ở quy mô nhỏ, chủ yếu là quy mô hộ gia đình và các trang trại sử dụng ít lao động. Số doanh nghiệp nông nghiệp ứng dụng KHCN hiện đại vào sản xuất, nông nghiệp ứng dụng công nghệ cao còn rất ít, tính đến tháng 6/2021, mới có 49 DN được cấp giấy chứng nhận còn hiệu lực; có 12 vùng và 11 khu nông, lâm nghiệp ứng dụng công nghệ được Chính phủ và các địa phương công nhận9. Đây là rào cản không nhỏ trong phát triển nền nông nghiệp hàng hóa quy mô lớn trên cơ sở ứng dụng KHCN hiện đại. Do vậy, sản phẩm làm ra còn ít về số lượng và thiếu đồng nhất về chất lượng nên khả năng cạnh tranh thấp, khó tiếp cận với thị trường khó tính. Thậm chí, ngay cả với những đơn vị, mô hình nông nghiệp ứng dụng công nghệ cao ở một số địa phương thì quy mô của hoạt động nghiên cứu, ứng dụng vẫn còn khiêm tốn, chưa đủ lớn mạnh để làm đầu tàu thúc đẩy phát triển hoạt động nghiên cứu, chuyển giao, ứng dụng KHCN rộng rãi vào SXNN ở các địa bàn lân cận trong mỗi vùng. Ở khía cạnh khác, tuy số lượng sản phẩm KHCN phục vụ nông nghiệp được nghiên cứu đã được tăng lên (giai đoạn 2011 – 2020), Bộ Nông nghiệp và Phát triển nông thôn đã công nhận 529 giống mới, 273 tiến bộ kỹ thuật, 185 sáng chế, 440 quy trình kỹ thuật…)10, song số lượng thực tế được chuyển giao, ứng dụng vào SXNN một cách phổ biến, rộng rãi còn ít. Đặc biệt, trong khâu cơ giới hóa, bảo quản nông phẩm. Theo Trung tâm Khuyến nông quốc gia, trong giai đoạn 2016 – 2020 chỉ có 8 dự án cơ giới hóa, bảo quản chế biến nông phẩm được triển khai ở cấp bộ, gồm: 6 dự án mạ khay, máy cấy, máy sạ khóm; 1 dự án tưới tiết kiệm nước cho cây hồ tiêu và 1 dự án bảo quản, chế biến dược liệu11. Đây là một con số quá khiêm tốn đối với một quốc gia có tham vọng phấn đấu trở thành cường quốc về nông nghiệp. Số lượng các công trình nghiên cứu khoa học xã hội nhân văn phục vụ nông nghiệp chưa được quan tâm đúng mức; chưa phổ biến rộng rãi trong các địa phương trên phạm vi cả nước. Hạn chế này dẫn đến năng suất lao động ngành Nông nghiệp rất thấp. Theo số liệu từ Tổng cục Thống kê, bình quân năng suất lao động trong nông nghiệp giai đoạn 2015-2020 chỉ đạt khoảng 47,39 triệu đồng/lao động/năm. So với năng suất lao động chung của cả nước, theo giá thực tế trong cùng giai đoạn trên của ngành nông, lâm nghiệp và thủy sản đều thấp hơn mức tổng thể chung, bình quân luôn ở dưới mức 50% so với tổng thể12. Thứ hai, trình độ KHCN ứng dụng vào SXNN còn thấp. Theo kết quả nghiên cứu, tổng hợp từ nhiều công trình khác nhau và Báo cáo Tổng kết chiến lược phát triển KHCN ngành Nông nghiệp và Phát triển nông thôn giai đoạn 2013-2020 cho thấy, trình độ KHCN, nhất là máy móc, thiết bị được ứng dụng vào SXNN ở nước ta còn lạc hậu và thiếu đồng bộ; tính trung bình thường lạc hậu từ 2-3 thế hệ (tương đương 20-30 năm). Thậm chí có nơi trình độ công nghệ trong nông nghiệp lạc hậu từ 4 – 5 thế hệ (khoảng từ 50-70 năm so với các nước có nền nông nghiệp phát triển. Được thể hiện trên một số lĩnh vực SXNN, như: (1) Trong lĩnh vực cơ giới hóa, chủ yếu mới chỉ tập trung vào khâu làm đất (đạt khoảng 93%) và cũng chủ yếu tập trung vào cây lúa. Các khâu khác và các cây trồng khác mức độ cơ giới hóa còn rất thấp. Tuy nhiên, hầu hết trình độ máy móc, trang bị làm đất có công suất nhỏ, chỉ thích hợp với quy mô hộ và ruộng đất manh mún. (2) Trong khâu thu hoạch, bảo quản nông phẩm, phần lớn trình độ máy móc, thiết bị công nghệ đã lạc hậu từ 20- 30 năm so với thế giới. Trong khi đó, hệ số đổi mới thiết bị hàng năm còn thấp chỉ ở mức 7%/năm (bằng 1/2 đến 1/3 mức tối thiểu của các nước khác). Vì vậy, hầu hết nông sản được xuất khẩu dưới dạng thô hoặc mới qua sơ chế; công nghệ bảo quản các mặt hàng thịt, cá, rau, quả tươi còn lạc hậu, quy mô nhỏ, chi phí cao, thời gian ngắn nên khó tiếp cận hoặc không thể cạnh tranh được với nông sản của nước ngoài trên các thị trường khó tính như Mỹ, EU, Nhật Bản… Đây cũng là một trong những điểm hạn chế lớn của việc ứng dụng KHCN vào SXNN ở Việt Nam trong thời gian qua. Bên cạnh đó, việc ứng dụng KHCN trong nhiều lĩnh vực khác, như: thủy nông, điện khí hóa, hóa học hóa, tin học hóa… phục vụ SXNN nhìn chung còn ở trình độ thấp và thiếu đồng bộ, chưa đáp ứng được yêu cầu hiện đại hóa nông nghiệp. Công nghệ thông tin, số hóa mới chỉ được áp dụng trong các mô hình nông nghiệp công nghệ cao, các hợp tác xã, mô hình điểm là chủ yếu. Đa số nông dân vẫn chưa tiếp cận được với cách làm nông nghiệp hiện đại theo hướng bền vững. Thứ ba, quá trình ứng dụng KHCN vào SXNN chưa mang lại hiệu quả KTXH cao và thiếu tính bền vững. Nhiều sản phẩm KHCN, quy trình kỹ thuật được chuyển giao, ứng dụng vào sản xuất chưa đem lại kết quả như kỳ vọng; chưa giải quyết đồng thời được các yêu cầu về tăng năng suất, chất lượng, hiệu quả và an toàn vệ sinh thực phẩm. Chưa có những công trình nghiên cứu liên ngành mang tính tổng thể cả về kinh tế – xã hội và môi trường nhằm tìm ra một hệ giải pháp mang tính đồng bộ và toàn diện để giúp cho các địa phương trong trả nước thoát khỏi tình trạng manh mún, lạc hậu trong SXNN hiện nay. Mức độ đóng góp của KHCN và đổi mới sáng tạo chưa trở thành yếu tố chủ lực nâng cao giá trị gia tăng trong SXNN nước ta, mới chỉ đạt khoảng 30%. Hoạt động chuyển giao, ứng dụng KHCN vào sản xuất chưa thực sự trở thành nhân tố cơ bản trong phát triển nông nghiệp theo hướng hiện đại và bền vững. Hoạt động khai thác các nguồn lực của tự nhiên cho SXNN còn mang nặng tính tự phát; sử dụng công nghệ lạc hậu và lạm dụng phân hóa học cũng như các loại thuốc bảo vệ thực vật gây tác động xấu đến môi trường, làm tăng mức độ ô nhiễm và suy yếu nguồn tài nguyên trong nông nghiệp, nhất là hệ sinh thái. Ứng dụng KHCN vào sản xuất vẫn chưa đạt được an toàn về dinh dưỡng và an ninh lương thực… Hầu hết các mô hình ứng dụng KHCN vào lĩnh vực môi trường ở các địa phương mới chỉ tập trung giải quyết bề ngoài mà chưa tìm ra các giải pháp công nghệ tổng thể để giải quyết tận gốc rễ của vấn đề ô nhiễm môi trường nông nghiệp, nông thôn… Ứng dụng AI vào sản xuất nông nghiệp. Ảnh: Danviet.vn. Đề xuất những giải pháp, chính sách cơ bản nhằm đẩy nhanh ứng dụng khoa học-công nghệ vào sản xuất nông nghiệp những năm tiếp theo Một là, cần bổ sung, hoàn thiện cơ chế, chính sách về nghiên cứu, chuyển giao, ứng dụng KHCN vào SXNN. Đây là giải pháp rất quan trọng vừa tạo hành lang pháp lý, vừa tháo gỡ những nút thắt để khơi thông và huy động có hiệu quả các các nguồn lực, các lực lượng tham gia vào hoạt động này. Theo đó, cần đổi mới toàn diện công tác quản lý nhà nước đối với hoạt động nghiên cứu, chuyển giao, ứng dụng KHCN vào SXNN trên phạm vi cả nước và từng địa phương theo các nguyên tắc của thị trường; xây dựng cơ chế tài chính phù hợp, hỗ trợ cho hoạt động ứng dụng KHCN vào SXNN của địa phương; tiếp tục xây dựng và hoàn thiện cơ chế, chính sách về đất đai nhằm tạo điều kiện thuận lợi để triển khai công tác ứng dụng KHCN vào SXNN; bổ sung và hoàn thiện chính sách đầu tư nhằm khuyến khích, hỗ trợ các DN, chủ trang trại, hộ nông dân đẩy mạnh quá trình đổi mới, ứng dụng KHCN vào SXNN. Hai là, nâng cao chất lượng nguồn nhân lực trong nông nghiệp. Đây là giải pháp quan trọng hàng đầu, bởi người lao động trong nông nghiệp là lực lượng trực tiếp lựa chọn, tiếp nhận các thành tựu KHCN đưa vào sản xuất, họ cũng là người biết huy động, khai thác các nguồn lực cho sản xuất một cách hiệu quả nhất. Mặt khác, người lao động cũng chính là lực lượng thường xuyên đưa ra những phát minh, sáng kiến cải tiến những thiết bị, quy trình công nghệ phù hợp với thực tiễn SXNN. Do vậy, cần tiếp tục đa dạng hóa, đổi mới nội dung, hình thức, biện pháp giáo dục, đào tạo, bồi dưỡng để nâng cao trình độ tri thức, kỹ năng và đổi mới tuy duy cho người lao động trong nông nghiệp. Thực hiện tốt nội dung, biện pháp này sẽ có ý nghĩa quyết định đến việc đẩy nhanh tiến trình ứng dụng KHCN vào SXNN trên phạm vi cả nước, cũng như ở từng địa phương. Ba là, cần phát huy vai trò và nâng cao hiệu quả quản lý nhà nước trong ứng dụng KHCN vào SXNN. Thực hiện tốt giải pháp này không chỉ đẩy nhanh mà còn quyết định tính hiệu quả của quá trình ứng dụng KHCN vào SXNN ở nước ta hiện nay. Trên cơ sở chủ trương, chính sách của Đảng, Nhà nước, các bộ, ngành trung ương và địa phương về hoạt động KHCN, từng địa phương cần cụ thể hóa và triển khai thực hiện một cách linh hoạt, phù hợp với thực tiễn. Theo đó, cần phát huy vai trò, nâng cao trách nhiệm quản lý của hệ thống chính quyền các cấp, đặc biệt cần gắn trách nhiệm của người đứng đầu các sở, ban, ngành chuyên môn và đội ngũ cán bộ chuyên trách trong quản lý, hướng dẫn, kiểm tra việc ứng dụng KHCN vào SXNN từng địa bàn, các địa phương được phân công. Bốn là, tiếp tục nghiên cứu, học hỏi kinh nghiệm các nước để lựa chọn các mô hình SXNN phù hợp; đầu tư xây dựng hệ thống kết cấu hạ tầng nông nghiệp, nông thôn đồng bộ, hiện đại tạo nền tảng đẩy nhanh quá trình ứng dụng KHCN vào SXNN ở từng địa phương. Cần chuyển đổi nhanh mô hình sản xuất manh mún, nhỏ lẻ sang sản xuất hàng hóa lớn, tạo ra động lực bên trong thúc đẩy ứng dụng tiến bộ KHCN hiện đại vào SXNN. Ưu tiên phát triển mạnh các DN nông nghiệp ứng dụng công nghệ cao; các khu, vùng nông nghiệp ứng dụng công nghệ cao làm đầu tàu thúc đẩy hoạt động nghiên cứu, chuyển giao, ứng dụng tiến bộ KHCN mới vào SXNN. Cùng với đó, tiếp tục huy động và sử dụng có hiệu quả các nguồn lực đầu tư xây dựng kết cấu hạ tầng nông nghiệp, nông thôn đồng bộ, hiện đại, nhất là hệ thống giao thông, thủy lợi, hệ thống điện lực và thông tin. Năm là, đẩy mạnh phát triển thị trường và hợp tác về KHCN phục vụ trong nông nghiệp. Thực hiện tốt giải pháp này vừa tạo ra nguồn cung phong phú, tăng cơ hội cho các chủ thể trong nước lựa chọn được những các sản phẩm KHCN tiên tiến, hiện đại, phù hợp. Mặt khác, việc đẩy mạnh hợp tác trong nghiên cứu, chuyển giao, ứng dụng KHCN với các nước có nền nông nghiệp phát triển còn là giải pháp quan trọng để Việt Nam rút ngắn thời gian, nâng cao năng lực nghiên cứu và làm chủ KHCN phục vụ SXNN một cách nhanh nhất. Thứ sáu, đẩy mạnh SXNN theo chuỗi liên kết bền vững nhằm mở ra các cơ hội ứng dụng  KHCN vào SXNN ở nước ta. Đây là giải pháp có vị trí, vai trò rất quan trọng, không chỉ góp phần đẩy nhanh quá trình ứng dụng KHCN vào SXNN một cách toàn diện, đồng bộ mà còn tạo nền tảng để kinh tế nông nghiệp nước ta phát triển theo hướng hiện đại, bền vững. Kết luận Để sớm hiện thực hóa mục tiêu CNH HĐH nông nghiệp, nông thôn; phát triển nông nghiệp hàng hóa tập trung quy mô hớn theo hướng hiện đại, có năng suất, chất lượng, hiệu quả, khả năng cạnh tranh, đem lại giá trị gia tăng cao và phát triển bền vững; phấn đấu đến năm năm 2030, nông nghiệp Việt Nam sẽ đứng trong top 15 nước phát triển trên thế giới theo mục tiêu Đại hội Đảng lần thứ XIII đã xác định thì tất yếu phải đẩy nhanh ứng dụng KHCN vào sản xuất. Đảng, nhà nước, các bộ ngành và từng địa phương đã có nhiều chủ trương, chính sách để thúc đẩy phát triển hoạt động KHCN phục vụ nông nghiệp. Công tác chuyển giao, ứng dụng KHCN vào SXNN đã đạt nhiều kết quả tích cực, KHCN đã có đóng góp to lớn đối với sự tăng trưởng của ngành nông nghiệp, nâng cao giá trị giá trị nông phẩm Việt Nam… Tuy nhiên, hoạt động chuyển giao, ứng dụng KHCN vẫn còn bộc lộ những tồn tại, hạn chế, làm chậm tiến trình phát triển kinh tế nông nghiệp nước nhà theo những mục tiêu đã xác định. Do đó, để khắc phục những tồn tại, hạn chế này, cần phải có hệ thống các giải pháp cơ bản, đồng bộ, toàn diện; huy động sự tham gia của nhiều lực lượng cả ở trung ương và địa phương; kiên trì thực hiện trong thời gian dài, với quyết tâm cao, trong đó những giải pháp nêu trên có tính chất gợi mở, khái quát cao, cần tiếp tục được nghiên cứu, bổ sung, cụ thể hóa và vận dụng linh hoạt trong quá trình thực hiện.",
      url:
          "https://i.ex-cdn.com/nongnghiep.vn/files/content/2023/11/20/dsc00045-144033_703-144034-141751.jpg",
      source: Source(name: "http://www.google.com"),
      publishedAt: DateTime.now(),
      content:
          "Để ngành NN-PTNT phát triển bền vững, cần những cơ chế, chính sách chiến lược, căn cơ, lâu dài nhằm phát triển nguồn nhân lực khoa học công nghệ phù hợp thực tiễn.",
      urlToImage:
          "https://www.quanlynhanuoc.vn/wp-content/uploads/2022/08/0812_6.jpg",
    ),
    NewsArticle(
      title:
          "Hệ sinh thái ITFSD tham dự Bế mạc Tuần lễ Chuyển đổi số tỉnh Đồng Nai năm 2023.",
      description:
          "(CTT-Đồng Nai) – Tối ngày 15-10, UBND tỉnh đã tổ chức lễ bế mạc Tuần lễ Chuyển đổi số tỉnh Đồng Nai năm 2023. Tham dự buổi lễ có Ủy viên Ban TVTU, Chủ nhiệm Ủy ban Kiểm tra Tỉnh ủy Huỳnh Thành Bình; Phó Chủ tịch UBND tỉnh Nguyễn Sơn Hùng, Trưởng Ban tổ chức; lãnh đạo Sở TT-TT, Tỉnh đoàn cùng các sở, ngành, địa phương. Về phía Trung ương Đoàn có Trưởng Ban Công nhân và đô thị Trần Hữu. Phó Chủ tịch UBND tỉnh Nguyễn Sơn Hùng, Trưởng Ban tổ chức phát biểu tại lễ bế mạc Tuần lễ Chuyển đổi số tỉnh ​Đồng Nai năm 2023 Phát biểu tại buổi lễ, Phó Chủ tịch UBND tỉnh Nguyễn Sơn Hùng đánh giá, tuần lễ Chuyển đổi số tỉnh Đồng Nai năm 2023 đã đạt được mục tiêu, yêu cầu đề ra, tạo hiệu ứng lan tỏa sâu rộng tinh thần chuyển đổi số trong đời sống xã hội. “Sự hiện diện của đồng chí Bí thư Tỉnh ủy, các đồng chí Thường trực Tỉnh ủy và lãnh đạo các sở, ban, ngành, UBND các huyện, thành phố thể hiện quyết tâm chính trị cao của tỉnh Đồng Nai đối với công cuộc chuyển đổi số. Khẳng định sự chung tay, đồng lòng giữa người dân và chính quyền; cộng đồng trách nhiệm từ tỉnh đến các địa phương, lan tỏa đến người dân, nâng cao nhận thức về vai trò, ý nghĩa và lợi ích của chuyển đổi số, thúc đẩy phát triển chính quyền số, kinh tế số, xã hội số trên địa bàn tỉnh Đồng Nai đúng theo thông điệp của Chính phủ.” – Phó Chủ tịch UBND tỉnh Nguyễn Sơn Hùng nhấn mạnh. Lãnh đạo tặng Bằng khen của UBND tỉnh cho các đơn vị đã có đóng góp tích cực trong việc tổ chức Tuần lễ Chuyển đổi số Đồng Nai năm 2023. Tuần lễ chuyển đổi số tỉnh Đồng Nai năm 2023 diễn ra từ ngày 10 đến ngày 15-10 với chủ đề “ Chuyển đổi số – động lực tăng trưởng kinh tế – xã hội” đã diễn ra nhiều hoạt động phong phú, đa dạng, thiết thực, hiệu quả, thu hút đông đảo cán bộ, công chức, viên chức, người lao động và người dân tham gia với hơn 22 ngàn lượt khách đến tham quan, trải nghiệm thực tế triển lãm tại Tuần lễ Chuyển đổi số. Triển lãm đã có sự tham gia của hơn 70 cơ quan, đơn vị, doanh nghiệp giới thiệu về những mô hình khởi nghiệp đổi mới sáng tạo từ các tổ chức, doanh nghiệp; mô hình, ứng dụng, giải pháp chuyển đổi số; các sản phẩm nông nghiệp ứng dụng công nghệ cao, giải pháp công nghệ thúc đẩy nông nghiệp bền vững; giới thiệu các sản phẩm, dịch vụ và giải pháp số, hướng dẫn, đăng ký sử dụng VNeID; hướng dẫn sử dụng dịch vụ công trực tuyến, chứng thực điện tử, thanh toán trực tuyến; giới thiệu các dịch vụ ngân hàng số; giới thiệu robot AI; quảng bá du lịch, văn hóa, lịch sử Đồng Nai thông qua hình thức sử dụng mã QR code… Tuần lễ Chuyển đổi số cũng đã tổ chức nhiều hội thảo, tọa đàm như: Thúc đẩy Ứng dụng Chuyển đổi số trên địa bàn tỉnh, Phát huy truyền thông mạng xã hội, trách nhiệm công chức, viên chức tỉnh Đồng Nai năm 2023, các chuyên đề về An toàn thông tin, Nông nghiệp số, Chuyển đổi số cho doanh nghiệp vừa và nhỏ… Các buổi hội thảo, tọa đàm đã thu hút sự tham gia của gần 2.000 đại biểu, trong đó trao đổi, thảo luận các nội dung như: chia sẻ các kinh nghiệm triển khai và những bài học thực tế về chuyển đổi số của các đơn vị; thực trạng và giải pháp đảm bảo an toàn thông tin; các mô hình chuyển đổi số mang tính đổi mới, sáng tạo; cách sử dụng mạng xã hội an toàn, hiệu quả; giải pháp để xây dựng nhãn hiệu và thương hiệu tổ chức, cá nhân trên mạng xã hội… Phó Chủ tịch UBND tỉnh cũng yêu cầu, những ý kiến của các chuyên gia, thảo luận của các sở ngành, các hội, đoàn thể, nhất là chỉ đạo, định hướng của Thường trực Tỉnh ủy, Sở TT-TT tổng hợp và chọn lọc, tham mưu kế hoạch cụ thể để phát triển 3 trụ cột chuyển đổi số của tỉnh​. Một tiết mục văn nghệ tại buổi lễ bế mạc Lãnh đạo UBND tỉnh cũng cho rằng, chuyển đổi số là một hành trình liên tục để góp phần nâng cao hiệu lực, hiệu quả quản lý nhà nước, từng bước cắt giảm các thủ tục hành chính; xây dựng cơ chế thúc đẩy, khuyến khích người dân, doanh nghiệp khai thác, sử dụng, cung cấp các dịch vụ số trên địa bàn tỉnh. Tiếp nối các hoạt động của Tuần lễ chuyển đổi số, các cơ quan, đơn vị, doanh nghiệp sẽ tiếp tục có những hoạt động chuyển đổi số thiết thực, phục vụ cho người dân.",
      url:
          "https://i.ex-cdn.com/nongnghiep.vn/files/content/2023/11/20/dsc00045-144033_703-144034-141751.jpg",
      source: Source(name: "http://www.google.com"),
      publishedAt: DateTime.now(),
      content:
          "Để ngành NN-PTNT phát triển bền vững, cần những cơ chế, chính sách chiến lược, căn cơ, lâu dài nhằm phát triển nguồn nhân lực khoa học công nghệ phù hợp thực tiễn.",
      urlToImage:
          "https://www.dongnai.gov.vn/TinTucHinhAnh/dongnai/378d7da7db0298ddba72f08eab830f7c-2023-10-15.21-45-08.jpg",
    ),
    NewsArticle(
      title: "Đào tạo, phát triển nguồn nhân lực khoa học công nghệ",
      description:
          "Tại hội nghị khoa học về đào tạo phát triển nguồn nhân lực khoa học và công nghệ ngành nông nghiệp và phát triển nông thôn do Bộ NN-PTNT tổ chức ngày 18/11, các viện, trường, đơn vị đều cho rằng, thực trạng nguồn nhân lực khoa học công nghệ ngành NN-PTNT hiện nay, đặc biệt là nguồn nhân lực chất lượng cao đang thiếu và yếu, cung không đủ cầu; nguồn nhân lực chưa qua đào tạo, tay nghề thấp. Thực trạng tuyển sinh khối ngành nông nghiệp hiện gặp rất nhiều khó khăn. Dù lực lượng lao động ngành nông nghiệp chiếm khoảng 30% lực lượng lao động cả nước, nhưng sinh viên đăng ký học ngành nông nghiệp chiếm chưa đến 2% tổng sinh viên nhập học hàng năm. Kết quả thống kê từ các trường của Bộ NN-PTNT đã chỉ ra, giai đoạn 2016 - 2020, học sinh, sinh viên đăng ký các ngành, lĩnh vực nông nghiệp, lâm nghiệp, thủy lợi và thủy sản giảm trên 30% so với giai đoạn 2011 - 2015. Trong những năm gần đây, một số ngành nông nghiệp truyền thống có rất ít hoặc thậm chí không có sinh viên đăng ký học. Một số chuyên ngành như khoa học đất, nông hóa thổ nhưỡng, hay lĩnh vực thủy sản có khai thác, cơ khí… đều trong tình trạng khó tuyển sinh. PGS.TS Phan Xuân Hảo, Phó trưởng ban Quản lý đào tạo, Học Viện Nông nghiệp Việt Nam chia sẻ tại hội nghị. Ảnh: Nguyễn Thủy. PGS.TS Phan Xuân Hảo, Phó trưởng ban Quản lý đào tạo, Học Viện Nông nghiệp Việt Nam chia sẻ tại hội nghị. Ảnh: Nguyễn Thủy. Theo PGS.TS Phan Xuân Hảo, Phó trưởng ban Quản lý đào tạo (Học Viện Nông nghiệp Việt Nam), tổng chỉ tiêu từ năm 2021 - 2023 trên toàn quốc, trình độ tiến sĩ, thạc sĩ chính quy, liên thông tiếp tục giảm. Riêng các ngành môi trường, bảo vệ môi trường, đặc biệt là nông, lâm thủy sản giảm 0,86% (năm 2020, ngành nông lâm thủy sản giảm 44%, năm 2021 giảm 62%, đến năm 2022 giảm 49%. “Nếu Bộ, các cơ quan quản lý, các doanh nghiệp không quan tâm, quản lý, ưu đãi thì trong bối cảnh này, mức độ suy giảm ngày càng tăng”, PGS.TS Hảo nói. Lý giải về nguyên nhân nguồn nhân lực khoa học công nghệ chất lượng cao ngành NN-PTNT đang suy giảm, PGS.TS Trần Bá Hoằng, Viện trưởng Viện Khoa học Thủy lợi Miền Nam cho rằng, một trong những nguyên nhân là do chất lượng đầu vào của các trường hiện khó tuyển sinh. Riêng Đại học Thủy lợi tuyển sinh 4.000 - 5.000 sinh viên/năm nhưng sinh viên chuyên ngành thủy lợi lại chỉ tuyển được khoảng 200 - 300 sinh viên. “Nếu không có giải pháp căn cơ và lâu dài, không có những chính sách vĩ mô của nhà nước thì 10 - 20 năm nữa lực lượng nguồn nhân lực KHCN chất lượng cao của các viện sẽ rất khó khăn”, PGS.TS Hoằng nhận định. Phó Viện trưởng Viện Nghiên cứu Hải sản Nguyễn Văn Nguyên cũng nhìn nhận, các đơn vị đặc biệt là các viện, các địa phương có nhu cầu rất lớn đối với nguồn nhân lực chất lượng cao trong lĩnh vực thủy sản, tuy nhiên, người có chuyên môn hiện rất ít. Thực tế, khối ngành thủy sản chưa thu hút được người học, nhiều sinh viên học xong lại khó tìm được việc làm. Đặc biệt là lĩnh vực khai thác, khi ra trường hầu như đều khó tìm được việc làm nên không khuyến khích được người học. Mặt khác, những chương trình đào tạo không phải chuyên môn như chính trị, quân sự… chiếm quá nhiều thời gian. Do đó, theo TS Nguyên, cần giảm tải những chương trình này, cũng như phải có thêm các chính sách để thu hút người học. Đặc biệt, vị trí việc làm sau khi ra trường cần rõ ràng hơn, có những chính sách thu hút, khuyến khích, sử dụng nguồn nhân lực, đặc biệt nguồn nhân lực chất lượng cao một cách hiệu quả. “Hiện ngành thủy sản thu hút sinh viên chất lượng vừa phải, chưa thu hút được khối chất lượng cao. Đối với khung chương trình phải khắc phục nhược điểm thực tế. Tăng cường phối hợp, hợp tác quốc tế, hợp tác giữa các trường - viện - doanh nghiệp để tăng chất lượng giảng viên”, TS Nguyên nói. PGS.TS Trần Bá Hoằng, Viện trưởng Viện Khoa học Thủy lợi Miền Nam. Ảnh: Nguyễn Thủy. PGS.TS Trần Bá Hoằng, Viện trưởng Viện Khoa học Thủy lợi Miền Nam. Ảnh: Nguyễn Thủy. “Chảy máu chất xám” Một trong những vấn đề “đau đầu” của lãnh đạo các đơn vị viện, trường thuộc khối nghiên cứu khoa học công lập ngành NN-PTNT hiện nay là tình trạng “chảy máu chất xám”, nhất là trong bối cảnh phải tự chủ về tài chính. Nêu thực tế tại đơn vị mình, Viện trưởng Viện Khoa học Thủy lợi Miền Nam cho rằng, thu nhập của cán bộ khoa học so với các ngành nghề khác thấp, nên không thu hút được người tài. “Mặc dù chúng tôi cũng rất cố gắng, làm thêm các dịch vụ hợp đồng để tăng thu nhập cho anh em, nhưng so với mặt bằng bên ngoài thì thấp. Cán bộ làm tốt, cố gắng lắm chúng ta mới trả 15-20 triệu đồng, nhưng các tổ chức quốc tế sẵn sàng trả 2.000USD/tháng, do đó khó để giữ được cán bộ chất lượng cao”, Viện trưởng Viện Khoa học Thủy lợi Miền Nam nói. Tương tự Phó Viện trưởng Viện Nghiên cứu Hải sản Nguyễn Văn Nguyên cho biết, năm 2017 Viện có 140 người, nhưng hiện nay còn hơn 110 người. “Một cán bộ của chúng tôi với kinh nghiệm 10 năm, lương khoảng 6 triệu đồng, nhưng nếu ra bên ngoài thì 50 triệu đồng ngay lập tức. Giải pháp nòng cốt nhất vẫn là làm sao có những bước nhảy vọt về thu nhập, đảm bảo đời sống. Có những sinh viên tài năng chúng tôi thu hút về, xoay xở lắm mới trả được 8 triệu đồng nhưng họ nói: “Em không thể sống được với mức lương ấy”. Đó là lý do mà nguồn nhân lực hiện có ngày càng teo tóp”, TS Nguyên nêu thực tế. Tại Viện Khoa học Nông nghiệp Việt Nam (VAAS), nếu như năm 2021, đơn vị có tổng số 2.623 người lao động, trong đó có 27 giáo sư, phó giáo sư, 263 tiến sĩ thì đến tháng 6/2023, VAAS có 1.964 người lao động, trong đó 17 giáo sư, phó giáo sư; 252 tiến sĩ. Còn tại Viện Khoa học Lâm nghiệp Việt Nam (VAFS) đã có 94 người xin nghỉ, trong đó có trên 10 cán bộ học xong trình độ tiến sĩ ở nước ngoài nhưng không chịu về nước và xin nghỉ việc; 11 người đào tạo xong về nước nhưng làm việc “vật vờ” hoặc xin nghỉ không lương, chờ đến khi đủ thời gian thì nghỉ hẳn. GS.TS Võ Đại Hải, Giám đốc Viện Khoa học Lâm nghiệp Việt Nam. Ảnh: Nguyễn Thủy. GS.TS Võ Đại Hải, Giám đốc Viện Khoa học Lâm nghiệp Việt Nam. Ảnh: Nguyễn Thủy. Chiến lược thu hút, phát triển nguồn nhân lực KHCN chất lượng cao Là một trong những đơn vị đầu ngành về lĩnh vực lâm nghiệp, Viện Khoa học Lâm nghiệp Việt Nam (VAFS) đã có chiến lược rõ ràng, hướng đi thành công, phù hợp với xu thế. Từ đó, giúp VAFS đạt được những kết quả đáng kể trong bối cảnh khó khăn hiện nay như số lượng nhiệm vụ tăng 1,43 lần; nguồn kinh phí tăng 1,2 lần. Đặc biệt, công tác cán bộ, đào tạo cán bộ là một trong những nhiệm vụ quan trọng giúp VAFS có thể đứng vững trong cơ chế thị trường. Trong đó, ưu tiên đào tạo cán bộ quản lý, cán bộ khoa học chuyên sâu. 5 năm qua, số cán bộ có trình độ giáo sư, phó giáo sư, tiến sĩ tại VAFS tăng 57,5%. Để thực hiện tốt chủ trương gắn kết các nhà khoa học với các nhà sản xuất; cũng như tạo thêm việc làm, thu nhập cho người lao động, VAFS ký kết các chương trình hợp tác với UBND các tỉnh, các sở, chi cục, từ đó có thêm nhiều nguồn kinh phí, chuyển giao được các kết quả nghiên cứu vào thực tiễn sản xuất. “Có những tỉnh, một năm VAFS ký được hàng chục tỷ đồng. Đây là hướng đi thành công và là xu hướng mà VAFS tiếp tục mở rộng. Đặc biệt, chúng tôi cố gắng tạo điều kiện để các cán bộ làm chủ nhiệm, thực hiện tốt nhiệm vụ”, GS.TS Võ Đại Hải nói. Trước các ý kiến đóng góp của các viện, trường, đơn vị, ông Nguyễn Hữu Ninh, Phó Vụ trưởng Vụ Khoa học, Công nghệ và Môi trường cho biết, năm 2024, nguồn kinh phí nghiên cứu KHCN để chi cho việc trả lương thường xuyên cho 11 viện trực thuộc Bộ NN-PTNT tiếp tục giảm. Trong khi đó, mức lương cơ bản tăng, đây sẽ là gánh nặng cho những người đứng đầu các đơn vị sự nghiệp công lập. Ông Ninh cho biết, về phía Bộ, tới đây cũng sẽ xây dựng kế hoạch phát triển nguồn nhân lực, trong đó có nguồn nhân lực KHCN, có những chế độ chính sách phù hợp để hỗ trợ nguồn nhân lực KHCN. Về phía Vụ Khoa học, Công nghệ và Môi trường, sẽ xây dựng lại quy định để góp phần công tác đào tạo nguồn nhân lực ngày một tốt hơn. Tuy nhiên, để thay đổi một cơ chế chính sách không hề đơn giản. Ngày 16/1/2023, Bộ NN-PTNT đã ban hành Chiến lược phát triển KHCN và đổi mới sáng tạo ngành NN-PTNT đến năm 2030. Theo Phó Vụ trưởng Vụ Tổ chức cán bộ Nguyễn Xuân Ân, mục tiêu phát triển KHCN đổi mới sáng tạo trở thành động lực quan trọng để xây dựng nền nông nghiệp có năng suất chất lượng đạt hiệu quả và khả năng cạnh tranh cao, bền vững thuộc nhóm dẫn đầu khu vực và quốc tế gắn với nền NN-PTNT hiện đại; Xây dựng hệ thống các tổ chức KHCN nông nghiệp đủ tiềm lực, tạo ra các trường độ có luận cứ và các sản phẩm khoa học có giá trị công nghệ cao. Tiếp thu và chọn lọc làm chủ công nghệ tiên tiến của thế giới, chuyển giao, ứng dụng và nhân rộng thực tiễn sản xuất, góp phần nâng cao thu nhập, cải thiện đời sống của nông dân, bảo vệ môi trường, ứng phó biến đổi khí hậu và giảm phát thải khí nhà kính.",
      url:
          "https://i.ex-cdn.com/nongnghiep.vn/files/content/2023/11/20/dsc00045-144033_703-144034-141751.jpg",
      source: Source(name: "http://www.google.com"),
      publishedAt: DateTime.now(),
      content:
          "Để ngành NN-PTNT phát triển bền vững, cần những cơ chế, chính sách chiến lược, căn cơ, lâu dài nhằm phát triển nguồn nhân lực khoa học công nghệ phù hợp thực tiễn.",
      urlToImage:
          "https://i.ex-cdn.com/nongnghiep.vn/files/content/2023/11/20/dsc00045-144033_703-144034-141751.jpg",
    ),
    NewsArticle(
      title: "Ương dưỡng giống thủy sản: Chuẩn hóa để tránh hệ lụy xấu",
      description:
          "Để phục vụ nhu cầu phát triển nuôi trồng thủy sản, hiện cả nước có 764 cơ sở sản xuất, cung ứng thức ăn, trong đó có 645 cơ sở trong nước và 119 cơ sở có vốn đầu tư nước ngoài. Bên cạnh đó, có 8.100 cơ sở sản xuất, ương dưỡng giống thủy sản. Tuy nhiên, ngày 17/11, tại Hội nghị tập huấn “Nâng cao kỹ năng quản lý, kiểm tra, đánh giá, cấp giấy chứng nhận cơ sở đủ điều kiện sản xuất và ương dưỡng giống, thức ăn, sản phẩm xử lý môi trường nuôi trồng thủy sản” do Cục Thủy sản (Bộ NN-PTNT) tổ chức ở TP Cần Thơ, ông Trần Đình Luân, Cục trưởng Cục Thủy sản nhận định, hiện vẫn còn nhiều cơ sở chưa được cấp chứng nhận đủ điều kiện sản xuất, ương dưỡng giống. Điều này khiến người dân không nắm được những cơ sở giống nào uy tín, chất lượng. Ông Trần Đình Luân, Cục trưởng Cục Thủy sản (Bộ NN-PTNT) cho biết, đơn vị sẽ thống kê, lập danh sách và triển khai hoạt động đánh giá, cấp giấy chứng nhận đủ điều kiện đối với các cơ sở sản xuất giống, thức ăn và sản phẩm xử lý môi trường thủy sản. Ảnh: Kim Anh. Ông Trần Đình Luân, Cục trưởng Cục Thủy sản (Bộ NN-PTNT) cho biết, đơn vị sẽ thống kê, lập danh sách và triển khai hoạt động đánh giá, cấp giấy chứng nhận đủ điều kiện đối với các cơ sở sản xuất giống, thức ăn và sản phẩm xử lý môi trường thủy sản. Ảnh: Kim Anh. Nguyên nhân của thực trạng xuất phát từ vấn đề, Luật Thủy sản năm 2017 có hiệu lực thi hành kể từ ngày 1/1/2019, sau 1 năm triển khai lại gặp phải một số khó khăn, do ảnh hưởng của dịch Covid-19, khủng hoảng kinh tế. Dẫn đến quá trình áp dụng, triển khai ở các địa phương còn hạn chế, vướng mắc, chưa thống nhất trong công tác quản lý, kiểm tra, đánh giá, cấp giấy chứng nhận cơ sở đủ điều kiện sản xuất, ương dưỡng giống thủy sản; cơ sở đủ điều kiện sản xuất thức ăn thủy sản, sản phẩm xử lý môi trường nuôi trồng thủy sản. Thông tin từ Phòng Giống và Thức ăn thủy sản (Cục Thủy sản), 10 tháng năm 2023, cả nước chỉ có trên 2.000 cơ sở được cấp chứng nhận đủ điều kiện sản xuất, ương dưỡng giống thủy sản. Số lượng sản phẩm thức ăn thủy sản đăng ký mã số là 36.414. Từ những số liệu này, ông Luân đặt câu hỏi về nguồn gốc đăng ký và chất lượng của trên 36.400 mã sản phẩm thức ăn thủy sản được thống kê ở trên. Để không xảy ra thực trạng buông lỏng quản lý, ảnh hưởng đến hoạt động sản xuất thủy sản, năm 2024, Cục Thủy sản sẽ tăng cường thanh tra và siết chặt hoạt động sản xuất, cung ứng thức ăn, sản xuất, ương dưỡng giống thủy sản. Bên cạnh đó, lãnh đạo ngành thủy sản khẳng định, tạo điều kiện thông thoáng cho các doanh nghiệp tự công bố, tự chịu trách nhiệm với sản phẩm. Đồng thời, cơ quan quản lý Nhà nước sẽ lấy mẫu kiểm tra, xem xét, đánh giá, giám sát quá trình hậu kiểm sản phẩm và những doanh nghiệp đủ điều kiện. Việc cung cấp và làm rõ các thông tin, vướng mắc liên quan đến vấn đề kiểm tra, đánh giá, cấp giấy chứng nhận cơ sở đủ điều kiện sản xuất và ương dưỡng giống, thức ăn, sản phẩm xử lý môi trường nuôi trồng thủy sản rất quan trọng. Qua đó, giúp các địa phương, doanh nghiệp hiểu và thống nhất cách làm. Trước yêu cầu siết chặt quản lý về nuôi trồng thủy sản, thông qua chương trình tập huấn lần này, các đơn vị chuyên môn có liên quan ở các địa phương, doanh nghiệp, HTX sẽ được cập nhật, cung cấp các thông tin về tình hình phát triển nuôi trồng thủy sản, công tác quản lý giống, thức ăn thủy sản. Đồng thời, quán triệt các văn bản quy phạm pháp luật, những nội dung, quy định mới trong việc quản lý sản xuất giống, sản xuất thức ăn và sản phẩm xử lý môi trường nuôi trồng thủy sản. Từ đó, tạo ra kênh dữ liệu công khai, minh bạch cho người dân và các cơ sở sản xuất thức ăn, cơ sở nuôi trồng thủy sản, tránh bị vi phạm. Bên cạnh đó, các cán bộ địa phương cũng nắm rõ nhiệm vụ, trách nhiệm, hướng dẫn doanh nghiệp làm đúng, minh bạch sản phẩm giúp hoạt động nuôi trồng thủy sản đạt hiệu quả cao nhất. Sản xuất an toàn thực phẩm, truy xuất nguồn gốc Ông Trần Công Khôi, Trưởng phòng Giống và Thức ăn thủy sản (Cục Thủy sản) cho biết, về phân công quản lý giống thủy sản, Cục Thủy sản sẽ quản lý điều kiện, chất lượng sản xuất giống tôm bố mẹ, cơ sở sản xuất thức ăn và sản phẩm xử lý môi trường nuôi trồng thủy sản có vốn đầu tư nước ngoài. Về phía các địa phương sẽ quản lý về điều kiện, chất lượng giống; chất lượng sản xuất thức ăn và sản phẩm xử lý môi trường nuôi trồng thủy sản trên địa bàn. Tập trung quản lý chặt chẽ các điều kiện, đảm bảo tuân thủ các quy định nâng cao chất lượng và an toàn trong lĩnh vực nuôi trồng thủy sản, là nhiệm vụ trọng tâm của ngành thủy sản. Ảnh: Kim Anh. Tập trung quản lý chặt chẽ các điều kiện, đảm bảo tuân thủ các quy định nâng cao chất lượng và an toàn trong lĩnh vực nuôi trồng thủy sản, là nhiệm vụ trọng tâm của ngành thủy sản. Ảnh: Kim Anh. Tuy nhiên, sau khi Phòng Giống và Thức ăn thủy sản tiến hành khảo sát, kiểm tra ở 18 tỉnh, thành phố, vẫn còn nhiều vấn đề còn thiếu trong công tác quản lý giống và thức ăn thủy sản. Điển hình, nhiều địa phương vẫn chưa thực hiện truy xuất nguồn gốc thủy sản, trong khi đây là trong những khâu quan trọng ảnh hưởng trực tiếp đến vấn đề xuất khẩu sản phẩm thủy sản. Hay trong khâu sản xuất và ương dưỡng giống thủy sản, phải thực hiện chứng nhận cơ sở sản xuất và kiểm tra quy trình. Vấn đề này được các địa phương thực hiện khá tốt trên những đối tượng nuôi chủ lực, tuy nhiên với những đối tượng khác lại khá hiếm, thậm chí là chưa thực hiện. Ngoài ra, hiện nay tại một số địa phương xuất hiện tình trạng các cơ sở mua đi bán lại tôm giống, nguồn gốc nhập từ nhiều nguồn khác nhau, gây khó khăn trong công tác quản lý. Đặc biệt làm tăng nguy cơ chất lượng tôm giống không đảm bảo cung cấp ra thị trường. “Nếu không để ý và cho rằng sản phẩm thủy sản xuất ra đã đảm bảo, nhưng khi truy xuất lại nguyên liệu lại có những vấn đề phức tạp, như lô nguyên liệu nhập lậu, sản xuất từ cơ sở không đủ điều kiện sẽ rất khó khăn”, ông Khôi nhấn mạnh. Một số điều kiện sản xuất thủy sản cơ bản được Cục Thủy sản đưa ra là cơ sở vật chất, trang thiết bị phục vụ sản xuất phải phù hợp với từng loài thủy sản, có nơi cách ly theo dõi sức khỏe giống thủy sản mới nhập. Khu chứa trang thiết bị, nguyên vật liệu bảo đảm yêu cầu bảo quản của nhà sản xuất, nhà cung cấp. Khu sinh hoạt bảo đảm tách biệt với khu sản xuất, ương dưỡng. Về trang thiết bị sản xuất cần bảo đảm yêu cầu về kiểm soát chất lượng, an toàn sinh học, có thiết bị thu gom và xử lý chất thải không để ảnh hưởng xấu đến khu vực sản xuất, ương dưỡng. Bên cạnh đó, các cơ sở sản xuất, doanh nghiệp phải xây dựng và áp dụng hệ thống kiểm soát chất lượng, an toàn sinh học cho từng loại sản phẩm thủy sản. Mỗi loại sản phẩm có chế độ kiểm soát khác nhau, bao gồm: nước; nguyên liệu bao bì thành phẩm; quá trình sản xuất; tái chế, lưu mẫu, kiểm định, hiệu chuẩn, hiệu chỉnh thiết bị; kiểm soát động vật gây hại; vệ sinh nhà xưởng, thu gom và xử lý chất thải. Cả nước hiện có 8.100 cơ sở sản xuất, ương dưỡng giống thủy sản. Ảnh: Kim Anh. Cả nước hiện có 8.100 cơ sở sản xuất, ương dưỡng giống thủy sản. Ảnh: Kim Anh. Trong Chiến lược phát triển thủy sản Việt Nam đến năm 2030, tầm nhìn đến năm 2045 đã được Thủ tướng Chính phủ phê duyệt, tổng sản lượng thủy sản sản xuất trong nước phấn đấu đạt 9,8 triệu tấn. Trong đó, sản lượng nuôi trồng thủy sản là 7 triệu tấn và sản lượng khai thác thủy sản là 2,8 triệu tấn vào năm 2030. Do đó, việc chấn chỉnh, kiểm tra chất lượng vật tư đầu vào trong nuôi trồng thủy sản cùng với các hoạt động giám sát điều kiện cơ sở hạ tầng, quy chuẩn, tiêu chuẩn… phải được thực hiện nghiêm ngặt. “Thà làm 1 - 2 sản phẩm tốt, chất lượng để phát triển thị trường. Nếu làm tràn lan, không kiểm soát được chất lượng sẽ khiến người dân hoang mang, không biết lựa chọn sản phẩm nào. Tôi đề nghị cơ quan quản lý Nhà nước phải kiểm tra để minh bạch, công khai, chuẩn hóa để người dân không bị hệ lụy”, ông Trần Đình Luân nhấn mạnh. Theo ông Luân, trước đây xuất khẩu thủy sản sang thị trường Trung Quốc được đánh giá dễ tính, nhưng hiện nay hoạt động này trở nên rất khó khăn. Quốc gia này thường xuyên bắt buộc đàm phán về thủy sản được nuôi và khai thác. Vì thế, thời gian tới, nếu những cơ sở sản xuất thức ăn, con giống hay vùng nuôi không tuân thủ quy định hoặc thiếu công khai, minh bạch sẽ rất khó khăn khi đàm phán xuất khẩu thủy sản.",
      url:
          "https://i.ex-cdn.com/nongnghiep.vn/files/content/2023/11/20/dsc00045-144033_703-144034-141751.jpg",
      source: Source(name: "http://www.google.com"),
      publishedAt: DateTime.now(),
      content:
          "Thà làm 1 - 2 sản phẩm tốt, chất lượng để phát triển thị trường. Nếu làm tràn lan, không kiểm soát được chất lượng sẽ khiến người dân hoang mang...', ông Trần Đình Luân nói.",
      urlToImage:
          "https://i.ex-cdn.com/nongnghiep.vn/files/content/2023/11/19/anh-3-153516_651-144347.jpg",
    ),
  ].obs;

  @override
  Future<void> onInit() async {
    getEditUser();
    super.onInit();
  }

  Future<void> getEditUser() async {
    isLoading.value = true;
    try {
      loginModel.value = await EditProfilelApi.getDataUser(accessToken);
      avatar.value = loginModel.value!.avatar ?? "";
    } catch (e) {
      print("Error fetching user data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  final List<LandArea> landAreas = [
    LandArea(
      name: 'Vùng sản xuất dưa lưới',
      description: 'Khu sản xuất thực phẩm',
      acreage: 500,
      images: [
        'https://api.ampf.vn/uploads/category/5211cd56-9495-4fcc-9b7f-d17be3a5c6b0.jpg',
        'https://image.baobackan.com.vn/w1400/file/4028eaa46735a26101673a4df345003c/fb9e3a03797dbe54017982845735320d/062022/z3529237756598_4606688b97d870f7b52e4a9437b4a9ab_20220629164833.jpg',
      ],
      locations: [
        Location(latitude: 10.56102, longitude: 106.3565233),
        Location(latitude: 10.5609, longitude: 106.3564),
        Location(latitude: 10.5608, longitude: 106.3565),
        Location(latitude: 10.560845, longitude: 106.3565533),
      ],
      code: 'ABC123',
      type: 'Rau củ',
      representative: 'Nguyễn Văn An',
      phoneNumber: '0901234567',
      email: 'nguyenvana@gmail.com',
      region: 'Miền Nam',
      address: '173 , Quận 7, Thành phố HCM',
      production: 1000.0,
      businessType: 'Tư nhân',
    ),
    LandArea(
      name: 'Vùng sản xuất cà phê',
      description: 'Khu sản xuất cà phê arabica',
      acreage: 1200,
      images: [
        'https://crowncoffeevietnam.com/wp-content/uploads/2020/12/c%C3%A0-ph%C3%AA..gif',
      ],
      locations: [
        Location(latitude: 12.3456, longitude: 98.7654),
        Location(latitude: 12.3457, longitude: 98.7653),
        Location(latitude: 12.3458, longitude: 98.7652),
        Location(latitude: 12.3459, longitude: 98.7651),
      ],
      code: 'DEF789',
      type: 'Cà phê Arabica',
      representative: 'Phạm Văn Cơ',
      phoneNumber: '0923456789',
      email: 'phamvanc@gmail.com',
      region: 'Tây Nguyên',
      address: '789 Đường , Quận GHI, Thành phố DăK laK',
      production: 1500.0,
      businessType: 'Tổ chức',
    ),
    LandArea(
      name: 'Vùng sản xuất hạt tiêu',
      description: 'Khu sản xuất tiêu đen',
      acreage: 600,
      images: [
        'https://hattieumyloc.com/upload/images/coc-trong-tieu.gif',
      ],
      locations: [
        Location(latitude: 11.1111, longitude: 99.9999),
        Location(latitude: 11.1112, longitude: 99.9998),
        Location(latitude: 11.1113, longitude: 99.9997),
        Location(latitude: 11.1114, longitude: 99.9996),
      ],
      code: 'GHI012',
      type: 'Tiêu đen',
      representative: 'Lê Thị Nhi',
      phoneNumber: '0934567890',
      email: 'lethid@gmail.com',
      region: 'Miền Nam',
      address: '012 Đường , Quận 12, Thành phố HCM',
      production: 800.0,
      businessType: 'Cá nhân',
    ),
    LandArea(
      name: 'Vùng sản xuất cà chua',
      description: 'Khu sản xuất cà chua đỏ',
      acreage: 700,
      images: [
        'https://vuonsinhthai.com.vn/wp-content/uploads/2022/05/trong-ca-chua-trai-vu.jpg',
      ],
      locations: [
        Location(latitude: 15.6789, longitude: 105.4321),
        Location(latitude: 15.6788, longitude: 105.4322),
        Location(latitude: 15.6787, longitude: 105.4323),
        Location(latitude: 15.6786, longitude: 105.4324),
      ],
      code: 'JKL345',
      type: 'Cà chua đỏ',
      representative: 'Võ Văn Em',
      phoneNumber: '0945678901',
      email: 'vovane@gmail.com',
      region: 'Miền Bắc',
      address: '345 Đường , Quận 4, Thành phố Hồ Chí Minh',
      production: 900.0,
      businessType: 'Tổ chức',
    ),
    LandArea(
      name: 'Vùng sản xuất cây lúa',
      description: 'Khu sản xuất lúa gạo',
      acreage: 800,
      images: [
        'https://snnptnt.thuathienhue.gov.vn/UploadFiles/TinTuc/2014/10/29/02.jpg',
      ],
      locations: [
        Location(latitude: 10.56102, longitude: 106.3565233),
        Location(latitude: 10.5609, longitude: 106.3564),
        Location(latitude: 10.5608, longitude: 106.3565),
        Location(latitude: 10.560845, longitude: 106.3565533),
      ],
      code: 'XYZ456',
      type: 'Lúa gạo',
      representative: 'Trần Thị Bình',
      phoneNumber: '0912345678',
      email: 'tranthib@gmail.com',
      region: 'Miền Trung',
      address: '456 Đường, Thành phố Long An',
      production: 1200.0,
      businessType: 'Doanh nghiệp',
    ),
  ];

  List<HarvestedCrop> harvestedCrops = [
    HarvestedCrop(
      name: 'Dưa lưới',
      type: 'Quả',
      quantity: 150.0,
      unit: 'kg',
      origin: 'Nông trại Thạch hội',
      farmerName: 'Anh Huy',
      harvestDate: '2023-06-10',
      location: 'Miền Nam, Việt Nam',
      price: 25.0,
      qualityRating: 4,
      notes: 'Ghi chú về dưa lưới...',
      isOrganic: true,
      certification: 'Chứng nhận hữu cơ  ',
      storageConditions: 'Bảo quản ở nhiệt độ 5°C - 10°C',
      imageUrls: [
        'https://cdn.tgdd.vn/Files/2020/06/20/1264372/cong-dung-cua-dua-luoi-cac-loai-tren-thi-truong-v-11.jpg',
        'https://dateh.lamdong.dcs.vn/Portals/10/media/newsimage/d/u/a/dualuoi.jpg',
      ],
      processingDetails:
          'Dưa lưới được chế biến theo quy trình truyền thống. Sau khi thu hoạch, quả dưa lưới được lựa chọn và làm sạch. Sau đó, chúng được đóng gói cẩn thận để bảo quản chất lượng và hương vị tốt nhất. Quy trình chế biến này đảm bảo sản phẩm cuối cùng là sạch, ngon và an toàn cho sức khỏe.',
    ),
    HarvestedCrop(
      name: 'Cà chua',
      type: 'Quả cầu',
      quantity: 300.0,
      unit: 'kg',
      origin: 'Nông trại Thị',
      farmerName: 'Nguyễn Thị B',
      harvestDate: '2023-02-20',
      location: 'Miền Trung, Việt Nam',
      price: 8.0,
      qualityRating: 5,
      notes: 'Ghi chú về cà chua...',
      isOrganic: true,
      certification: 'Chứng nhận hữu cơ ',
      storageConditions: 'Bảo quản ở nhiệt độ 5°C - 10°C',
      imageUrls: [
        'https://cdn.tgdd.vn/Files/2017/10/30/1037058/loi-ich-cua-ca-chua-doi-voi-suc-khoe-cach-an-ca-chua-an-toan-202102241033594001.jpg',
        'https://cdn.tgdd.vn/Files/2017/10/30/1037058/loi-ich-cua-ca-chua-doi-voi-suc-khoe-cach-an-ca-chua-an-toan-202102241107338545.jpg',
      ],
      processingDetails: 'Chi tiết về quy trình chế biến...',
    ),
    HarvestedCrop(
      name: 'Bí đỏ',
      type: 'Quả lớn',
      quantity: 150.0,
      unit: 'kg',
      origin: 'Nông trại KLM',
      farmerName: 'Trần Văn C',
      harvestDate: '2023-03-10',
      location: 'Miền Nam, Việt Nam',
      price: 12.5,
      qualityRating: 4,
      notes: 'Ghi chú về bí đỏ...',
      isOrganic: false,
      certification: '',
      storageConditions: 'Bảo quản ở nhiệt độ 8°C - 12°C',
      imageUrls: [
        'https://img.dantocmiennui.vn/t620/uploaddtmn//2017/5/15/bn-1.jpg',
      ],
      processingDetails: 'Chi tiết về quy trình chế biến...',
    ),
    HarvestedCrop(
      name: 'Cà rốt',
      type: 'Rau củ',
      quantity: 200.0,
      unit: 'kg',
      origin: 'Nông trại PQR',
      farmerName: 'Lê Thị D',
      harvestDate: '2023-04-05',
      location: 'Miền Bắc, Việt Nam',
      price: 15.0,
      qualityRating: 3,
      notes: 'Ghi chú về cà rốt...',
      isOrganic: true,
      certification: 'Chứng nhận hữu cơ ',
      storageConditions: 'Bảo quản ở nhiệt độ 3°C - 8°C',
      imageUrls: [
        'https://cdn.tgdd.vn/2021/09/content/Khongtieude(5)-800x450-14.jpg',
        'https://bazaarvietnam.vn/wp-content/uploads/2023/03/harper-bazaar-ca-rot-ky-voi-cai-gi-nick-fewings-unsplash-e1678891534667.jpg',
      ],
      processingDetails: 'Chi tiết về quy trình chế biến...',
    ),
    HarvestedCrop(
      name: 'Dưa hấu',
      type: 'Quả lớn',
      quantity: 250.0,
      unit: 'kg',
      origin: 'Nông trại JKL',
      farmerName: 'Vũ Văn F',
      harvestDate: '2023-06-25',
      location: 'Miền Nam, Việt Nam',
      price: 18.0,
      qualityRating: 4,
      notes: 'Ghi chú về dưa hấu...',
      isOrganic: false,
      certification: '',
      storageConditions: 'Bảo quản ở nhiệt độ 6°C - 11°C',
      imageUrls: [
        'https://giathe.vn/wp-content/uploads/2023/01/Kinh-nghiem-va-mot-so-luu-y-khi-cham-soc-cay-dua-hau-cho-nang-suat-cao-1.jpg',
        'https://giathe.vn/wp-content/uploads/2023/01/Kinh-nghiem-va-mot-so-luu-y-khi-cham-soc-cay-dua-hau-cho-nang-suat-cao-2.jpg',
      ],
      processingDetails: '',
    ),
  ];
}
