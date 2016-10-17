Updated by Tuan Pham (MV) 4 months ago

Description updated (diff)
#2 Updated by Le Quang Thai (GCS) 3 months ago

File DLV_CR_Navi4427_Estimation.xlsx added
Due date changed from 2016-07-06 to 2016-07-12
Assignee changed from Le Quang Thai (GCS) to Tuan Pham (MV)
Comment Edit
Dear Tuân,

Anh gửi file báo giá. Em check nha.

Thanks,
Thai

#3 Updated by Thai Thach Bao (MJ) 3 months ago

File 仕様検討資料_20160712.xlsx added
Assignee changed from Tuan Pham (MV) to Le Quang Thai (GCS)
Comment Edit
Dear Thai,

Cảm ơn em gửi file báo giá.
Bên SS vừa mới thông báo có một chút thay đổi ở requirement mà anh có gửi kèm file.
Cụ thể là ở Shinsa lần 2 không chia ra 2 loại : học sinh (sinh viên) và other nữa.

Sorry em vừa mới gửi, nhưng nhờ em update lại file estimation.

Best regards,
Bao

#4 Updated by Le Quang Thai (GCS) 3 months ago

File DLV_CR_Navi4427_Estimation.xlsx added
Assignee changed from Le Quang Thai (GCS) to Thai Thach Bao (MJ)
Comment Edit
Dear a.Bao,

Em gửi lại file báo giá cho note#3. Anh check nha.

BR,
Thai Le

#5 Updated by Thai Thach Bao (MJ) 3 months ago

Assignee changed from Thai Thach Bao (MJ) to Le Quang Thai (GCS)
Comment Edit
Dear Thái,

Số effort anh thấy hơi ít nên nhờ em confirm lại một số chỗ bên này nghĩ là sẽ tốn effort,
xem có hiểu đầy đủ chưa.

５）強制項目新規設定に関して (Về việc config new forced item)
Không biết mình định design thế nào, nhưng chỗ này phải đem ra config file nào đó chứ không viết trong code.
=> Phải design phần này và sửa file config list (?).

８）重回帰分析トランＴａｂｌｅに関して (Về bảng NMS_TRN_JUKAIKI)
Như có chat trên Skype, định thêm column để lưu kết quả lần 2, vẫn lưu kết quả lần 1 ở column cũ.
=> Không biết có trong estimation chưa, và việc sửa lại sreen spec (tách ra file mới) cũng cần effort.

９）新ロジック実装時の過去の審査データに関して (Về kết quả Shinsa của những record trước khi release logic mới)
Có tính effort investigate affected range chỗ này chưa ?

１０）テストに関して (Về việc test)
Bên DLV sẽ test ở view người dùng nghiệp vụ, còn bên GCS sẽ thực hiện program test.
Như đã chat ở Skype, mặc dù không thể test hết các cases theo matrix các parameter,
nhưng anh nghĩ nên test theo một số pattern tiêu biểu, mà hiện tại effort test ít quá.

Others）
Như có giải thích, nhờ GCS tách phần design document của Shinsa logic ra khỏi screen spec.
Chỗ này phải viết thêm detail flow xử lý nên sẽ tốn effort.

Nhờ em confirm lại những điểm trên.

Best regards,
Bao

#6 Updated by Le Quang Thai (GCS) 3 months ago

File DLV_CR_Navi4427_Estimation.xlsx added
Due date changed from 2016-07-12 to 2016-07-15
Assignee changed from Le Quang Thai (GCS) to Thai Thach Bao (MJ)
Comment Edit
Dear a.Bảo,

Cảm ơn anh Bảo đã feedback.

Về điểm này:

５）強制項目新規設定に関して (Về việc config new forced item)
Không biết mình định design thế nào, nhưng chỗ này phải đem ra config file nào đó chứ không viết trong code.
=> Phải design phần này và sửa file config list (?).

Như confirm của a.Bảo trên chat group, mình sẽ hard-code, không dùng config file cho đơn giản hơn.
Tuy nhiên, do requirement chỗ này chưa clear lắm (không biết dạng logic của khách là đơn giản hay phức tạp như thế nào), nên tạm thời team assume như sau:
- sẽ check tối đa 10 logic trong code (hard-coding) để force rank tương ứng
- ứng với từng logic (câu lệnh IF):
+ có tối đa 23 conditions (ứng với 23 hệ số dưới DB). mình sẽ quy định điều kiện 1 là column nào dưới DB, điều kiện 2 là column nào dứoi DB...
+ chỉ support các toán tử cơ bản này: >, <, =, >=, <=, +, -, *, /, ! (khác)
+ do hard-coding nên không phải validate gì cả

Về điểm này:

８）重回帰分析トランＴａｂｌｅに関して (Về bảng NMS_TRN_JUKAIKI)
Như có chat trên Skype, định thêm column để lưu kết quả lần 2, vẫn lưu kết quả lần 1 ở column cũ.
=> Không biết có trong estimation chưa, và việc sửa lại sreen spec (tách ra file mới) cũng cần effort.
Others）
Như có giải thích, nhờ GCS tách phần design document của Shinsa logic ra khỏi screen spec.
Chỗ này phải viết thêm detail flow xử lý nên sẽ tốn effort.

Bên em cũng có tính rồi, nhưng giờ nghĩ lại thấy chỗ đó có vẻ hơi ít, nên tăng lên tí. Phần screenspec, bên em thiếu việc tách logic của Shinsa lần 1 (sau đó phải chỉnh lại flow như Shinsa lần 2) ra file mới luôn. Cảm ơn anh Bảo.

Về điểm này:

９）新ロジック実装時の過去の審査データに関して (Về kết quả Shinsa của những record trước khi release logic mới)
Có tính effort investigate affected range chỗ này chưa ?

Với ticket này, bên em invest công investigate.

Về điểm này:

１０）テストに関して (Về việc test)
Bên DLV sẽ test ở view người dùng nghiệp vụ, còn bên GCS sẽ thực hiện program test.
Như đã chat ở Skype, mặc dù không thể test hết các cases theo matrix các parameter,
nhưng anh nghĩ nên test theo một số pattern tiêu biểu, mà hiện tại effort test ít quá.

Effort cũ cũng không đến nỗi anh. Tuy nhiên, do effort coding có tăng lên, nên bên em vừa tăng effort test lên chút.

Em gửi lại file estimate được update. Anh Bảo check và feedback nếu có issues gì nha.

BR,
Thai Le

#7 Updated by Tuan Pham (MV) 3 months ago

File スケジュール.xlsx added
File スケジュール_VN.xlsx added
Assignee changed from Thai Thach Bao (MJ) to Le Quang Thai (GCS)
Comment Edit
Chào anh Thái

Để làm hợp đồng với DLV, SS có đề xuất master schedule như file đính kèm.
Nhờ anh xem schedule như vậy GCS có đáp ứng được không.
Lưu ý: Chừa thêm cho MB 2 ngày để review và dịch thiết kế.

Tuân

#8 Updated by Le Quang Thai (GCS) 3 months ago

Assignee changed from Le Quang Thai (GCS) to Tuan Pham (MV)
Comment Edit
Chào Tuân,

Như có confirm trên chat group, bên anh dự định schedule như sau (shift 3 ngày):
- khâu thiết kế bắt đầu từ 4 tháng 8
- release source code vào 17 tháng 8
- 5 tháng 9 mới lên production được

BR,
Thái

#9 Updated by Le Quang Thai (GCS) 3 months ago

File スケジュール_VN_GCS.xlsx added
Comment Edit
Chào a.Bảo,

Em gửi file master schedule cho note#8 (shift 3 ngày so với master schedule ban đầu của khách)

BR,
Thái

#10 Updated by Le Quang Thai (GCS) 3 months ago

Comment Edit
Dear a.Bảo, Tuân,

Nhờ anh Bảo và Tuân giúp push khách để bên GCS có thể start làm thiết kế vào ngày mai (4 tháng 8) như đã plan nha. Với lại, để bên GCS kịp check xem là khách có change requirement nhiều không? có phải update schedule lại không nha.

BR,
Thái Lê

#11 Updated by Thai Thach Bao (MJ) 2 months ago

File 仕様検討資料_20160727.xlsx added
Assignee changed from Tuan Pham (MV) to Le Quang Thai (GCS)
Comment Edit
Dear Thái,

Anh mới nhận được file trả lời câu hỏi về forced setting rank như file đính kèm.

(1) Kết quả Shinsa lần 1 là rank E thì coi như NG (không thực hiện Shinsa lần 2) đúng không ?
=> E3, E4 thì phán đoán là NG

(2) Nhờ cho biết nội dung cụ thể các forced setting item
=> Xem sheet 強制10項目
(Chú ý 10 mục này chưa fix)

Best regards,
Bao

#12 Updated by Le Quang Thai (GCS) 2 months ago

File 4427 screen spec.xlsx added
#13 Updated by Tuan Pham (MV) 2 months ago

File 4427 screen spec_TuanReviewed_0808.xlsx added
Comment Edit
Tuân gửi bản review.
Vẫn chưa review xong, nhưng cách viết hơi khó hiểu nên cần voice để giải thích, và thống nhất lại cách viết dễ hiểu hơn.

#14 Updated by Tuan Pham (MV) 2 months ago

File deleted (4427 screen spec_TuanReviewed_0808.xlsx)
#15 Updated by Tuan Pham (MV) 2 months ago

File 4427 screen spec_TuanReviewed_0808.xlsx added
#16 Updated by Tuan Pham (MV) 2 months ago

File 仕様検討資料_20160809.xlsx added
Comment Edit
Khách hàng gửi 10 mục đặc biệt
Tham khảo file đính kèm.

#17 Updated by Nguyen Van Bi (GCS) 2 months ago

Assignee changed from Le Quang Thai (GCS) to Tuan Pham (MV)
Comment Edit
Dear a.Tuân,

Đối với 10 mục đặc biệt. Có một số mục bên em vẫn chưa rõ. Xin nhờ khách hàng confirm lại những gì mà bên em đã hiểu, sẽ implement và giải thích thêm về những mục mà bên em chưa hiểu.

Nếu thoả một trong 10 điều kiện dưới đây thì kết quả shinsa là rank C. Các điều kiện này chỉ được kiểm tra khi kết quả shinsa lần 2 sau tính toán ban đầu là rank A hoặc rank B, đối với kết quả là các rank còn lại thì sẽ không kiểm tra 10 điều kiện này. Các chữ ở trong dấu ngoặc vuông [] là text đúng của các field đang hiển thị trên màn hình approve đăng ký vào ở.

1. ご職業: [職業] có một trong các giá trị: 自営業, 自由業, パート, アルバイト, 派遣, 学生, その他
2. 事業内容: [業種] có một trong các giá trị: 建設業, 飲食店, 宿泊業
3. 勤務開始年月: [勤続年数] < 1
4. 転居理由: [転居理由] có một trong các giá trị: 離婚, 独立
5. 未成年者: Tính ra số tuổi từ [生年月日]. Số tuổi <= 19
6. 運転免許証番号: [運転免許証番号]. GCS chưa hiểu rõ requirement của mục này. Xin vui lòng giải thích thêm.
7. 名前欄に「アルファベット・カタカナ」が入っている人: [氏名] có giá trị là alphabet hay katakana
8. 年収: [年収] <= 200万円
9. 居住開始年月: GCS chưa hiểu rõ requirement của mục này và cũng không xác định được field nào trên màn hình. Xin vui lòng giải thích thêm.
10. 年齢70歳以上: Tính ra số tuổi từ [生年月日]. Số tuổi >= 70

Nhờ SS kiểm tra lại xem 10 điều kiện trên hiểu như vậy đã đúng chưa. Hiện tại có 2 nhóm chứa các field này là: 個人契約申込者情報 và 緊急連絡先. GCS assume là sẽ sử dụng các thông tin trong nhóm 個人契約申込者情報. Như vậy có đúng không?
Các giá trị dùng trong 10 điều kiện trên sẽ được lưu vào file application.properties để khách tiện chỉnh sửa. Bên GCS sẽ khởi tạo các giá trị đúng như các giá trị trong file requirement mà khách gửi. Ví dụ:

sinsa.rankc.conditions.yearincomeubound = 20000
sinsa.rankc.conditions.work = 自営業,自由業,パート,アルバイト,派遣,学生,その他
sinsa.rankc.conditions.business = 建設業,飲食店,宿泊業
sinsa.rankc.conditions.agelbound = 70
sinsa.rankc.conditions.continuousworkingyears = 1 
sinsa.rankc.conditions.movingreason = 離婚,独立
sinsa.rankc.conditions.juvenileage = 19

Nhờ a.Tuân review và gửi khách confirm càng sớm càng tốt giúp em.
Cám ơn anh.

Best regards,
Long

#18 Updated by Le Quang Thai (GCS) 2 months ago

File sinsa-code.zip added
Comment Edit
Dear Tuân,

Anh gửi các file code liên quan đến sinsa mà em yêu cầu Thành gửi.

BR,
Thái

#19 Updated by Tuan Pham (MV) 2 months ago

File 4427_screen_spec_business_detail_trans.xlsx added
Comment Edit
Hi Thanh

Anh gửi sheet business detail đã dịch ý nghĩa của các chỗ tiếng Nhật.

Tuân

#20 Updated by Tuan Pham (MV) 2 months ago

Assignee changed from Tuan Pham (MV) to Nguyen Van Bi (GCS)
Comment Edit
Chào Long

Anh trả lời trước các mục có thể trả lời.

Nếu thoả một trong 10 điều kiện dưới đây thì kết quả shinsa là rank C. Các điều kiện này chỉ được kiểm tra khi kết quả shinsa lần 2 sau tính toán ban đầu là rank A hoặc rank B, đối với kết quả là các rank còn lại thì sẽ không kiểm tra 10 điều kiện này.

Đúng rồi

1. ご職業: [職業] có một trong các giá trị: 自営業, 自由業, パート, アルバイト, 派遣, 学生, その他

Đúng rồi

2. 事業内容: [業種] có một trong các giá trị: 建設業, 飲食店, 宿泊業

Đúng rồi

3. 勤務開始年月: [勤続年数] < 1

勤続年数=0 hoặc 1

4. 転居理由: [転居理由] có một trong các giá trị: 離婚, 独立

Chỉ có 1 giá trị 独立(離婚 thì không xử lí force)

9. 居住開始年月: GCS chưa hiểu rõ requirement của mục này và cũng không xác định được field nào trên màn hình. Xin vui lòng giải thích thêm.

Mục này không cần xử lí force nữa(Nên tổng cộng chỉ còn 9 force item)

10. 年齢70歳以上: Tính ra số tuổi từ [生年月日]. Số tuổi >= 70

Nhờ SS kiểm tra lại xem 10 điều kiện trên hiểu như vậy đã đúng chưa. Hiện tại có 2 nhóm chứa các field này là: 個人契約申込者情報 và 緊急連絡先. GCS assume là sẽ sử dụng các thông tin trong nhóm 個人契約申込者情報. Như vậy có đúng không?

Assume như vậy là đúng rồi.

Các giá trị dùng trong 10 điều kiện trên sẽ được lưu vào file application.properties để khách tiện chỉnh sửa. Bên GCS sẽ khởi tạo các giá trị đúng như các giá trị trong file requirement mà khách gửi. Ví dụ:

sinsa.rankc.conditions.yearincomeubound = 20000
sinsa.rankc.conditions.work = 自営業,自由業,パート,アルバイト,派遣,学生,その他
sinsa.rankc.conditions.business = 建設業,飲食店,宿泊業
sinsa.rankc.conditions.agelbound = 70
sinsa.rankc.conditions.continuousworkingyears = 1 
sinsa.rankc.conditions.movingreason = 離婚,独立
sinsa.rankc.conditions.juvenileage = 19

Về cách làm thì đúng rồi. Nhưng sao chỉ có 7 item config vậy?

#21 Updated by Nguyen Van Bi (GCS) 2 months ago

Assignee changed from Nguyen Van Bi (GCS) to Tuan Pham (MV)
Comment Edit
Dear a.Tuân,

4. 転居理由: [転居理由] có một trong các giá trị: 離婚, 独立

Chỉ có 1 giá trị 独立(離婚 thì không xử lí force)

Như vậy mục này nếu [転居理由] = 独立 thì mới là rank C, còn 離婚 thì mình không xử lý trong việc forced item nữa phải không anh?

Về cách làm thì đúng rồi. Nhưng sao chỉ có 7 item config vậy?

Chỗ này em chỉ ghi ví dụ thôi. Hơn nữa là 3 item còn lại chưa có nắm rõ requirement nên không có ghi vào.

Em cũng đưa 2 câu hỏi thêm lên đây luôn để tiện theo dõi:
1. Ở chỗ 10 forced item, phần liên quan đến tuổi tính từ ngày tháng năm sinh thì mình sẽ tính theo năm hay tính chính xác luôn theo ngày? Lấy ví dụ hôm nay là 11/08/2016, người có ngày sinh là 25/09/1966 thì mình tính tuổi là 50 (tính theo năm) hay là 49 (chưa đến sinh nhật)?
2. Nếu tên của người đang xét vừa có Hiragana (hoặc Kanji) vừa có Katana (hoặc alphabet) luôn thì mình có xét là người ngoại quốc (hay lưu học sinh) hay không?
Nhờ anh hỏi giúp em thêm 2 câu này.

Cám ơn anh Tuân.

Best regards,
Long

#22 Updated by Tuan Pham (MV) 2 months ago

Assignee changed from Tuan Pham (MV) to Nguyen Van Bi (GCS)
Comment Edit
4. 転居理由: [転居理由] có một trong các giá trị: 離婚, 独立
Như vậy mục này nếu [転居理由] = 独立 thì mới là rank C, còn 離婚 thì mình không xử lý trong việc forced item nữa phải không anh?

Đúng rồi

5. 未成年者: Tính ra số tuổi từ [生年月日]. Số tuổi <= 19
1. Ở chỗ 10 forced item, phần liên quan đến tuổi tính từ ngày tháng năm sinh thì mình sẽ tính theo năm hay tính chính xác luôn theo ngày? Lấy ví dụ hôm nay là 11/08/2016, người có ngày sinh là 25/09/1966 thì mình tính tuổi là 50 (tính theo năm) hay là 49 (chưa đến sinh nhật)?

<= 19 là đúng rồi.
Còn về cách tính tuổi, khách hàng nói trên màn hình đăng kí application form đã có xử lí tính tuổi rồi

6. 運転免許証番号: [運転免許証番号]. GCS chưa hiểu rõ requirement của mục này. Xin vui lòng giải thích thêm.

Ý nghĩa là chữ số cuối cùng trong giá trị nhập = 2 thì force thành rank C
Ví dụ: Trong các trường hợp bên dưới thì chỉ có 4322 là thực hiện force thành rank C
　・4320
　・4322
　・4323
　・4329

7. 名前欄に「アルファベット・カタカナ」が入っている人: [氏名] có giá trị là alphabet hay katakana

2. Nếu tên của người đang xét vừa có Hiragana (hoặc Kanji) vừa có Katana (hoặc alphabet) luôn thì mình có xét là người ngoại quốc (hay lưu học sinh) hay không?

Cứ có katakana hoặc alphabet là tính là người nước ngoài hoặc lưu học sinh.
Do đó vừa nhập katakana vưa hiragana, hoặc vừa katakana vừa kanji thì vẫn tính là người nước ngoài.
Ví dụ: マック鈴木 --> Người nước ngoài --> Force thành rank C

8. 年収: [年収] <= 200万円

Đúng rồi

10. 年齢70歳以上: Tính ra số tuổi từ [生年月日]. Số tuổi >= 70

Đúng rồi

#23 Updated by Tuan Pham (MV) 2 months ago

File Shinsa1_2_data_mapping.xlsx added
Comment Edit
Chào anh Thái, Thành

Tuân có thử suy nghĩ cách tạo dữ liệu cho các parameter của shinsa lần 2.
Có tập hợp vào file đính kèm. Anh Thái và Thành xem trước rồi mình voice để Tuân giải thích xem có ảnh hưởng gì tới coding không nha.
Tham khảo sheet số 1 và số 2. Trong đó sheet số 2 là đề xuất cách đăng kí data.

Tuân

#24 Updated by Tuan Pham (MV) 2 months ago

File WayToCreateData.xlsx added
Comment Edit
Chào Thành

Anh có tổng hợp lại cách tạo dữ liệu test cho Shinsa lần 2(đã confirm với khách hàng)
Còn một số chỗ màu vàng khách hàng đang confirm lại, trễ nhất ngày mai họ sẽ trả lời cho mình.
File này anh đã giải thích cho em, có gì không rõ em liên lạc với anh nha.
★Lưu ý: Khi release mình cũng phải nộp DDL tạo table, và data test cho khách hàng.

Tuân

#25 Updated by Tuan Pham (MV) about 1 month ago

File 4427 screen spec_0817_mb_reviewed.xlsx added
Comment Edit
Chào Thành

Anh có review tài liệu screen spec mà em viết.
 Em tham khảo file đính kèm.
 Ngoài ra em đổi lại tên tài liệu như sau: NAVI0201601_入居申込審査（重回帰分析）ロジック設計.xlsx
Tuân

#26 Updated by Tuan Pham (MV) about 1 month ago

Comment Edit
Chào anh Thái, Thành

Tuân đính chính lại một điểm như bên dưới:

(1) Kết quả Shinsa lần 1 là rank E thì coi như NG (không thực hiện Shinsa lần 2) đúng không ?
=> E3, E4 thì phán đoán là NG

Kết quả shinsa lần 1 là E(bao gồm E1,E2,E3,E4) đều là NG và không thực hiện shinsa lần 2.

Tổng hợp lại sẽ là như sau:
■Kết quả shinsa1 là E、F、G thì coi là NG và không thực hiện shinsa2
　Trên màn hình nhấn button đăng kí thì hiển thị messsage 「審査結果がE・F・Gのため登録できません」 và không cho đăng kí。

■Ngược lại ở trên、Kết quả shinsa1 là A, B, C, D thì coi là OK và thực hiện tiếp shinsa2
　・Kết quả shinsa2 là F、G(không có E) thì coi là NG
　　Trên màn hình nhấn button đăng kí thì hiển thị messsage 「審査結果がE・F・Gのため登録できません」 và không cho đăng kí。
　・Ngược lại ở trên、Kết quả shinsa2 là A、B、C、D、E thì coi là OK
　　⇒Trong trường hợp kết quả A、B thì thực hiện xử lí force, nếu thỏa điều kiện thì set rank là C

★Chú ý: 
Hiện tại trong tài liệu requirement sheet 31_判定基準 thì chưa có dữ liệu cho rank F và G
Vì vậy mình tự tạo dữ liệu để test. SS cũng đang confirm với DLV.

Ngoài ra hiển thị rank trên màn hình thì chỉ cần hiển thị SEGMENT_GROUP là được.(không cần tới mức SEGMENT)

Tuân

#27 Updated by Tuan Pham (MV) about 1 month ago

File SEGMENT_DATA.xlsx added
Comment Edit
★Chú ý: 
Hiện tại trong tài liệu requirement sheet 31_判定基準 thì chưa có dữ liệu cho rank F và G
Vì vậy mình tự tạo dữ liệu để test. SS cũng đang confirm với DLV.

Khách hàng confirm lại như sau:
Sửa E3 thành F
Sửa E4 thành G

Cụ thể xem file đính kèm.

#28 Updated by Tuan Pham (MV) about 1 month ago

File Data_Confirm_1.xlsx added
Comment Edit
Khách hàng có trả lời 1 số confirm về data như file đính kèm.

#29 Updated by Tuan Pham (MV) about 1 month ago

File 審査2次のスコア問題.xlsx added
Comment Edit
Chào Thành

Anh gửi lại file đang confirm với khách hàng về hệ số Thu nhập năm của lần 1 và lần 2 khác nhau nhiều.
Ngoài ra、để tránh việc bị dừng test do lỗi java over flow thì hãy lấy hệ số của Năm thu nhập/1000 rồi tiếp tục test.
(Cái này /1000 là để test được, chứ không phải spec. Spec thì khách hàng đang confirm lại)

Ngoài ra, khách hàng có một yêu cầu như sau:
Vì xử lí tính rank thì mang tính blackbox(xử lí ngầm bên dưới không thấy được)
Nên hãy ghi các nội dung dưới đây xuống file log（Dùng để test và khi vận hành trên production）

■Nội dung cần ghi trong log file
　①Ghi thông tin start xử lí shisa（Để có thể search）【Log Level：info】
　①Ghi thông tin input từ những màn hình có liên quan tới shinsa【Log Level：debug】
　②Ghi các giá trị sau khi hiệu chỉnh【Log Level：debug】
　③Ghi các giá trị hệ số của các parameter đã get【Log Level：debug】
　④Ghi kết quả tính score【Log Level：debug】
　⑤Ghi kết quả tính rank【Log Level：info】

Tuân

#30 Updated by Tuan Pham (MV) about 1 month ago

File 家賃保証審査モデル更改 パラメータ 修正版.xlsx added
Comment Edit
Anh gửi trả lời 1 số ý của khách hàng(bản JP)

#31 Updated by Tuan Pham (MV) about 1 month ago

File 仕様検討資料_20160901.xlsx added
File 仕様検討資料_20160901_VN.xlsx added
Comment Edit
Chào Thành, anh Thái

Khách hàng có update tài liệu mới nhất dựa vào các câu hỏi của mình.
Tham khảo file đính kèm: 仕様検討資料_20160901_VN.xlsx, các sheet có đánh màu đỏ.
Ngoài ra, Tuân có gửi kèm luôn bản tiếng Nhật để tham khảo.

■Dưới đây là một số request của khách
　〆Nhờ báo giá lại theo 2 pattern dưới đây:
　　①Estimate lại cho trường hợp thực hiện theo phương thức như file đính kèm
　　②Những việc có thể làm trong phạm vi estimate hiện tại
　　　Ví dụ）Không làm cho việc tính toán các mục 町会費<Phí hội đồng thành phố>、上下水道代<Phí cấp thoát nước>, etc
　〆Spec trong file đính kèm có vấn đề gì thì hãy liên lạc lại

Tuân

#32 Updated by Tuan Pham (MV) about 1 month ago

Comment Edit
Chào anh Thái

Khi gửi estimation, nhờ anh gửi thêm thông tin đã dùng bao nhiêu cost cho ticket này rồi, và đã làm được những phần nào giúp em nhé.

Tuân

#33 Updated by Nguyen Van Bi (GCS) about 1 month ago

Comment Edit
Tuan Pham (MV) wrote:

Chào Thành, anh Thái

Khách hàng có update tài liệu mới nhất dựa vào các câu hỏi của mình.
Tham khảo file đính kèm: 仕様検討資料_20160901_VN.xlsx, các sheet có đánh màu đỏ.
Ngoài ra, Tuân có gửi kèm luôn bản tiếng Nhật để tham khảo.

■Dưới đây là một số request của khách
　〆Nhờ báo giá lại theo 2 pattern dưới đây:
　　①Estimate lại cho trường hợp thực hiện theo phương thức như file đính kèm
　　②Những việc có thể làm trong phạm vi estimate hiện tại
　　　Ví dụ）Không làm cho việc tính toán các mục 町会費<Phí hội đồng thành phố>、上下水道代<Phí cấp thoát nước>, etc
　〆Spec trong file đính kèm có vấn đề gì thì hãy liên lạc lại

Tuân

Chào anh Tuân,

Về những việc có thể làm trong phạm vi estimate hiện tại thì hiện tại bên em đã hoàn thành xong (những parameter và assumption trước khi có câu trả lời của khách hàng). 
Chỉ có những điểm chưa được khách hàng trả lời ở đợt trước là còn đang pending lại thôi anh. Cụ thể gồm các parameter:
+ Thu nhập năm
+ Tỉ lệ giá nhà / thu nhập năm
+ Mối quan hệ với người vào ở

File estimation của các parameter thay đổi hoặc mới đợt này em đang nhờ anh Thái đính kèm lên giúp
