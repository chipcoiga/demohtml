#!/usr/bin/perl

use strict;
use warnings;
#use 5.010;
#デバッグ用
use Data::Dumper 'Dumper';

use module::db;
use module::logger;
use module::mail;
use DBI;
#use Time::Piece;
use File::Basename;


#############
# 初期設定  #
#############

#環境変数の設定
$ENV{'NLS_LANG'}='Japanese_Japan.JA16SJISTILDE';

my $USAGE =
"
./ph3_n2m2h.pl EXECUTE_MODE
EXECUTE_MODE
    TEST  :　DB接続テスト
    DAILY  :　日次処理
    HOUZIN_N2M : 提携法人マスタ(ナビDB->中間DB)
    BUKKEN_N2M : 物件データ(ナビDB->中間DB)
    HOUZIN_M2H : 提携法人マスタ(中間DB->ハウスDB)
    BUKKEN_M2H : 物件データ(中間DB->ハウスDB)
    MASTER_M2H : 法人マスタ(中間DB->ハウスDB)
    BUKKEN_UPDATE : 物件データのSTOPフラグ更新
    PREMIUMROOM_UPDATE : 物件データの先行案内物件フラグ更新
";

######################################################################

#引数が入力されていなければ、は文法をコマンドラインに出力
my $execute_mode = $ARGV[0];
die "USAGE: $USAGE" unless $execute_mode;

#設定ファイルロード
my $conf_file = "app.config";
my $conf = do $conf_file
  or die "Can't load config file \"$conf_file\": $!$@";

my $NAVI_DB_ROOM = $conf->{NAVI_DB_ROOM};
my $NAVI_DB_COOP = $conf->{NAVI_DB_COOP};
my $MID_DB = $conf->{MID_DB};
my $HOUSE_DB = $conf->{HOUSE_DB};

my $LOG_INFO = $conf->{LOG_INFO};
my $MAIL_INFO = $conf->{MAIL_INFO};

my $MASTER_TABLE_LIST = $conf->{MASTER_TABLE_LIST};
my $BUKKEN_TABLE_LIST = $conf->{BUKKEN_TABLE_LIST};
my $HOUZIN_TABLE_LIST = $conf->{HOUZIN_TABLE_LIST};
my $UPDATE_BUKKEN_INFO = $conf->{UPDATE_BUKKEN_INFO};
my $UPDATE_PREMIUMROOM_INFO = $conf->{UPDATE_PREMIUMROOM_INFO};

my $CHINTAI_ROOM_POP_INFO = $conf->{CHINTAI_ROOM_POP_INFO};
my $NAVI_ROOM_POP_INFO = $conf->{NAVI_ROOM_POP_INFO};

my $NAVI_FACILITY_POP_INFO = $conf->{NAVI_FACILITY_POP_INFO};
my $CHINTAI_MST_POP_INFO = $conf->{CHINTAI_MST_POP_INFO};

my @time = localtime;
my $date = sprintf("%04d%02d%02d_%02d%02d%02d", $time[5]+1900, $time[4]+1, $time[3], $time[2], $time[1], $time[0]);

&module::logger::init($LOG_INFO->{dir} , $LOG_INFO->{header} . "$date.log");
#ログローテーション
#更新日が30日以上前のファイルは削除
&module::logger::delete_logfile($LOG_INFO->{dir},30);

#メイン処理
&module::logger::write_log("START PROGRAM : main.pl " . join(' ',@ARGV));

#多重起動の禁止
my $script_name = basename(__FILE__);
my $cmd = "ps aux | grep  perl | grep $script_name | grep -v grep |  wc -l";
my $process_cnt =  `$cmd`;
#プロセスが2以上存在すれば停止
if(int($process_cnt) > 1){
    print STDERR "2重起動です\n";
    &module::logger::write_log("2重起動です\n",'WARNING');
}
else{
    #異常終了時のみメール送信
    main() or &module::mail::send_mail(
        $MAIL_INFO->{smtp_srv},
        $MAIL_INFO->{smtp_domain},
        $MAIL_INFO->{sender},
        $MAIL_INFO->{recipient},
        $MAIL_INFO->{recipient_cc},
        $MAIL_INFO->{subject},
        &module::logger::get_log()
    );
}

&module::logger::write_log("END PROGRAM");
#ログファイルを閉じる
&module::logger::end();

#処理の正常終了
exit;

sub main{

    my $result_flag = 1;

    my $navi_room_dbh;
    my $navi_coop_dbh;
    my $mid_dbh;
    my $house_dbh;

    #DBへの接続
    eval{

        &module::logger::write_log("CONNECT -> NAVI_DB_ROOM");
        &module::db::connect_db($navi_room_dbh,$NAVI_DB_ROOM->{host},$NAVI_DB_ROOM->{ora_sid},$NAVI_DB_ROOM->{user},$NAVI_DB_ROOM->{passwd});
        &module::logger::write_log("CONNECT -> NAVI_DB_COOP");
        &module::db::connect_db($navi_coop_dbh,$NAVI_DB_COOP->{host},$NAVI_DB_COOP->{ora_sid},$NAVI_DB_COOP->{user},$NAVI_DB_COOP->{passwd});
        &module::logger::write_log("CONNECT -> MID_DB");
        &module::db::connect_db($mid_dbh,$MID_DB->{host},$MID_DB->{ora_sid},$MID_DB->{user},$MID_DB->{passwd});
        &module::logger::write_log("CONNECT -> HOUSE_DB");
        &module::db::connect_db($house_dbh,$HOUSE_DB->{host},$HOUSE_DB->{ora_sid},$HOUSE_DB->{user},$HOUSE_DB->{passwd});

    #引数に応じた処理
        if ($execute_mode eq 'TEST') {
            &module::logger::write_log("START -> TEST  :　DB接続テスト");
            print STDOUT "テスト\n";
            &module::logger::write_log("END -> TEST  :　DB接続テスト");
        }
        elsif ($execute_mode eq 'DAILY') {
            &module::logger::write_log("START -> DAILY  :　日次処理");
            #ナビDB→中間DB
            &module::logger::write_log("　START ナビDB→中間DB");
            sync_tables($BUKKEN_TABLE_LIST,$navi_room_dbh,$mid_dbh,1);
            sync_tables($HOUZIN_TABLE_LIST,$navi_coop_dbh,$mid_dbh,0);
            &module::logger::write_log("　END ナビDB→中間DB");
            #中間DB→ハウスDB
            &module::logger::write_log("　START 中間DB→ハウスDB");
            sync_tables($MASTER_TABLE_LIST,$mid_dbh,$house_dbh,0);
            sync_tables($HOUZIN_TABLE_LIST,$mid_dbh,$house_dbh,0);
            sync_tables($BUKKEN_TABLE_LIST,$mid_dbh,$house_dbh,1);
            &module::logger::write_log("　END 中間DB→ハウスDB");
            &module::logger::write_log("EMD -> DAILY  :　日次処理");
        }
        elsif ($execute_mode eq 'HOUZIN_N2M') {
            &module::logger::write_log("START -> HOUZIN_N2M : 提携法人マスタ(ナビDB->中間DB)");
            &module::logger::write_log("　START ナビDB→中間DB");
            sync_tables($HOUZIN_TABLE_LIST,$navi_coop_dbh,$mid_dbh,0);
            &module::logger::write_log("　END ナビDB→中間DB");
            &module::logger::write_log("END -> HOUZIN_N2M : 提携法人マスタ(ナビDB->中間DB)");
        }
        elsif ($execute_mode eq 'BUKKEN_N2M') {
            &module::logger::write_log("START -> BUKKEN_N2M : 物件データ(ナビDB->中間DB)");
            &module::logger::write_log("　START ナビDB→中間DB");
            sync_tables($BUKKEN_TABLE_LIST,$navi_room_dbh,$mid_dbh,1);
            &module::logger::write_log("　END ナビDB→中間DB");
            &module::logger::write_log("END -> BUKKEN_N2M : 物件データ(ナビDB->中間DB)");
        }
        elsif ($execute_mode eq 'HOUZIN_M2H') {
            &module::logger::write_log("START -> HOUZIN_M2H : 提携法人マスタ(中間DB->ハウスDB)");
            &module::logger::write_log("　START 中間DB→ハウスDB");
            sync_tables($HOUZIN_TABLE_LIST,$mid_dbh,$house_dbh,0);
            &module::logger::write_log("　END 中間DB→ハウスDB");
            &module::logger::write_log("END -> HOUZIN_M2H : 提携法人マスタ(中間DB->ハウスDB)");
        }
        elsif ($execute_mode eq 'BUKKEN_M2H') {
            &module::logger::write_log("START -> BUKKEN_M2H : 物件データ(中間DB->ハウスDB)");
            &module::logger::write_log("　START 中間DB→ハウスDB");
            sync_tables($BUKKEN_TABLE_LIST,$mid_dbh,$house_dbh,1);
            &module::logger::write_log("　END 中間DB→ハウスDB");
            &module::logger::write_log("END -> BUKKEN_M2H : 物件データ(中間DB->ハウスDB)");
        }
        elsif ($execute_mode eq 'MASTER_M2H') {
            &module::logger::write_log("START -> MASTER_M2H : 法人マスタ(中間DB->ハウスDB)");
            &module::logger::write_log("　START 中間DB→ハウスDB");
            sync_tables($MASTER_TABLE_LIST,$mid_dbh,$house_dbh,0);
            &module::logger::write_log("　END 中間DB→ハウスDB");
            &module::logger::write_log("END -> MASTER_M2H : 法人マスタ(中間DB->ハウスDB)");
        }
        elsif ($execute_mode eq 'BUKKEN_UPDATE') {
            &module::logger::write_log("START -> BUKKEN_UPDATE : 物件データのSTOPフラグ更新");
            &module::logger::write_log("　START ナビDB→中間DB");
            sync_stop_flag($UPDATE_BUKKEN_INFO->{table},$UPDATE_BUKKEN_INFO->{columns},$UPDATE_BUKKEN_INFO->{pk},$navi_room_dbh,$mid_dbh);
            &module::logger::write_log("　END ナビDB→中間DB");
            &module::logger::write_log("　START 中間DB→ハウスDB");
            sync_stop_flag($UPDATE_BUKKEN_INFO->{table},$UPDATE_BUKKEN_INFO->{columns},$UPDATE_BUKKEN_INFO->{pk},$mid_dbh,$house_dbh);
            &module::logger::write_log("　END 中間DB→ハウスDB");
            &module::logger::write_log("END -> BUKKEN_UPDATE : 物件データのSTOPフラグ更新");
        }
        elsif ($execute_mode eq 'PREMIUMROOM_UPDATE') {
            &module::logger::write_log("START -> PREMIUMROOM_UPDATE : 物件データの先行案内物件フラグ更新");
            &module::logger::write_log("　START ナビDB→中間DB");
            sync_premium_flag($UPDATE_PREMIUMROOM_INFO->{table},$UPDATE_PREMIUMROOM_INFO->{columns},$UPDATE_PREMIUMROOM_INFO->{pk},$navi_room_dbh,$mid_dbh);
            &module::logger::write_log("　END ナビDB→中間DB");
            &module::logger::write_log("　START 中間DB→ハウスDB");
            sync_premium_flag($UPDATE_PREMIUMROOM_INFO->{table},$UPDATE_PREMIUMROOM_INFO->{columns},$UPDATE_PREMIUMROOM_INFO->{pk},$mid_dbh,$house_dbh);
            &module::logger::write_log("　END 中間DB→ハウスDB");
            &module::logger::write_log("END -> PREMIUMROOM_UPDATE : 物件データの先行案内物件フラグ更新");
        }
		elsif ($execute_mode eq 'ROOM_POP') {
			&module::logger::write_log("START -> SYNC ROOM POP INFO");
	    	&module::logger::write_log("　START SYNC FROM NAVI TO CHINTAI");
			sync_room_pop_info($navi_room_dbh, $house_dbh, $NAVI_ROOM_POP_INFO, $CHINTAI_ROOM_POP_INFO);
			&module::logger::write_log("　END SYNC FROM NAVI TO CHINTAI");
		} 
		elsif ($execute_mode eq 'CLEAN_UP') {
			&module::logger::write_log("START CLEAN UP DATA");
			clean_up($navi_room_dbh, $house_dbh, $NAVI_ROOM_POP_INFO, $CHINTAI_ROOM_POP_INFO);
			&module::logger::write_log("　END CLEAN UP DATA");
		}
        else {
            die "$execute_mode: 引数が無効です";
        }
    };

    #実行結果をログファイルに保存
    if( $@ ){  # $@ にエラーメッセージが入っている
        &module::logger::write_log($@,'ERR');
        $result_flag = 0;
    }

    &module::logger::write_log("DISCONNECT -> NAVI_DB_ROOM");
    &module::db::disconnect_db($navi_room_dbh);
    &module::logger::write_log("DISCONNECT -> NAVI_DB_COOP");
    &module::db::disconnect_db($navi_coop_dbh);
    &module::logger::write_log("DISCONNECT -> MID_DB");
    &module::db::disconnect_db($mid_dbh);
    &module::logger::write_log("DISCONNECT -> HOUSE_DB");
    &module::db::disconnect_db($house_dbh);

    return $result_flag;
}

sub sync_tables{

    my $ref_table_list = $_[0];
    my $ref_from_dbh = \$_[1];    # リファレンス
    my $ref_to_dbh = \$_[2];    # リファレンス
    my $bukken_flag = $_[3];    # ADD:2014/06/23 物件データフラグ

    eval{
        &module::logger::write_log("　　更新テーブル：" .join(',',@$ref_table_list));
        my $table_size = @$ref_table_list;
        my @data;
        for(my $i = 0; $i < $table_size; $i++){
            sync_table($$ref_table_list[$i],$$ref_from_dbh,$$ref_to_dbh,$bukken_flag);
        }
    };
    #例外処理
    if( $@ ){  # $@ にエラーメッセージが入っている
        $$ref_to_dbh->rollback;
        &module::logger::write_log("--- ROLLBACK ---");
        die "$@";
    }else{
        $$ref_to_dbh->commit;
        &module::logger::write_log("　　COMMIT");
    }
}

sub sync_table{

    my $table_name = $_[0];
    my $ref_from_dbh = \$_[1];    # リファレンス
    my $ref_to_dbh = \$_[2];    # リファレンス
    my $bukken_flag = $_[3];    # ADD:2014/06/23 物件データフラグ

    &module::logger::write_log("　　START $table_nameの同期");
    eval{
        my $from_hSt;
        my $to_hSt;

        #同期元のデータを取得
        &module::logger::write_log("　　　同期元のデータをSELECT");
        $from_hSt = $$ref_from_dbh->prepare(&module::db::make_select($table_name));
        $from_hSt->execute();

        #同期先のデータを削除
        &module::logger::write_log("　　　同期先のデータをDELETE");
        if ($bukken_flag) {
            $to_hSt = $$ref_to_dbh->prepare(&module::db::make_delete_bukken($table_name));
        } else {
            $to_hSt = $$ref_to_dbh->prepare(&module::db::make_delete($table_name));
        }
        $to_hSt->execute();
        $to_hSt->finish;

        my $first_flag = 1;
        my @columns;
        my $sql;
        &module::logger::write_log("　　　同期先のデータINSERT");
        while(my $record = $from_hSt->fetchrow_hashref){

            if($first_flag){
                @columns = sort keys %$record;
                $sql = &module::db::make_insert($table_name,\@columns);
                $first_flag = 0;
            }

            my @data;
            for(my $i = 0; $i <= $#columns; $i++){
                push @data, $record->{$columns[$i]};
            }
            # INSERTの実行
            $to_hSt = $$ref_to_dbh->prepare($sql);
            $to_hSt->execute(@data);
            $to_hSt->finish;
        }
        $from_hSt->finish;
    };

    #例外検知
    if( $@ ){  # $@ にエラーメッセージが入っている
        &module::logger::write_log("　　FAIL $table_nameの同期");
        die "$@";
    }else{
        &module::logger::write_log("　　END $table_nameの同期");
    }
}

sub sync_stop_flag{

    my $table_name = $_[0];
    my $ref_columns = $_[1];
    my $pk_name = $_[2];
    my $ref_from_dbh = \$_[3];    #リファレンス
    my $ref_to_dbh = \$_[4];    #リファレンス

    &module::logger::write_log("　　$table_nameの更新");
    eval{
        my $from_hSt;
        my $to_hSt;

        my @columns = @$ref_columns;
        my $column_cnt = @$ref_columns;
        push @columns, $pk_name;

        &module::logger::write_log("　　同期元のデータをSELECT");
        $from_hSt = $$ref_from_dbh->prepare(&module::db::make_select($table_name,\@columns));
        $from_hSt->execute();
        #差分確認用のハッシュを作成(同期元)
        my %from_data;
        while(my $record = $from_hSt->fetchrow_hashref){
            $from_data{$record->{$pk_name}} = $record->{$$ref_columns[0]};
        }
        $from_hSt->finish;

        &module::logger::write_log("　　同期先のデータをSELECT");
        $to_hSt = $$ref_to_dbh->prepare(&module::db::make_select($table_name,\@columns));
        $to_hSt->execute();
        #差分確認用のハッシュを作成(同期先)
        my %update_info;
        while(my $record = $to_hSt->fetchrow_hashref){
            #TODO: 比較は数値としてで大丈夫か確認する
            if(exists($from_data{$record->{$pk_name}}) and ($record->{$$ref_columns[0]} != $from_data{$record->{$pk_name}})){
                $update_info{$record->{$pk_name}} = $from_data{$record->{$pk_name}};
            }
        }
        $to_hSt->finish;

        &module::logger::write_log("　　同期先のデータUPDATE");
        #更新SQLの作成
        my $sql = &module::db::make_update_by_pk($table_name,$ref_columns,$pk_name);
        foreach my $pk (keys(%update_info)){

            my @data;
            push @data, $update_info{$pk};
            push @data, $pk;

            #更新情報の記録
            &module::logger::write_log('　　　' . $pk . " -> " . $update_info{$pk});
            # UPDATEの実行
            $to_hSt = $$ref_to_dbh->prepare($sql);
            $to_hSt->execute(@data);
            $to_hSt->finish;
        }
    };

    #例外処理
    if( $@ ){  # $@ にエラーメッセージが入っている
        print($@);
        $$ref_to_dbh->rollback;
        &module::logger::write_log("--- ROLLBACK ---");
        die "$@";
    }else{
        $$ref_to_dbh->commit;
        &module::logger::write_log("　　COMMIT");
    }
}


sub sync_premium_flag{

    my $table_name = $_[0];
    my $ref_columns = $_[1];
    my $pk_name = $_[2];
    my $ref_from_dbh = \$_[3];    #リファレンス
    my $ref_to_dbh = \$_[4];    #リファレンス

    &module::logger::write_log("　　$table_nameの更新");
    eval{
        my $from_hSt;
        my $to_hSt;

        my @columns = @$ref_columns;
        my $column_cnt = @$ref_columns;
        push @columns, $pk_name;

        &module::logger::write_log("　　同期元のデータをSELECT");
        $from_hSt = $$ref_from_dbh->prepare(&module::db::make_select($table_name,\@columns));
        $from_hSt->execute();
        #差分確認用のハッシュを作成(同期元)
        my %from_data;
        while(my $record = $from_hSt->fetchrow_hashref){
            $from_data{$record->{$pk_name}} = $record->{$$ref_columns[0]};
        }
        $from_hSt->finish;

        &module::logger::write_log("　　同期先のデータをSELECT");
        $to_hSt = $$ref_to_dbh->prepare(&module::db::make_select($table_name,\@columns));
        $to_hSt->execute();
        #差分確認用のハッシュを作成(同期先)
        my %update_info;
        while(my $record = $to_hSt->fetchrow_hashref){
            #TODO: 比較は数値としてで大丈夫か確認する
            if(exists($from_data{$record->{$pk_name}}) and ($record->{$$ref_columns[0]} != $from_data{$record->{$pk_name}})){
                $update_info{$record->{$pk_name}} = $from_data{$record->{$pk_name}};
            }
        }
        $to_hSt->finish;

        &module::logger::write_log("　　同期先のデータUPDATE");
        #更新SQLの作成
        my $sql = &module::db::make_update_by_pk($table_name,$ref_columns,$pk_name);
        foreach my $pk (keys(%update_info)){

            my @data;
            push @data, $update_info{$pk};
            push @data, $pk;

            #更新情報の記録
            &module::logger::write_log('　　　' . $pk . " -> " . $update_info{$pk});
            # UPDATEの実行
            $to_hSt = $$ref_to_dbh->prepare($sql);
            $to_hSt->execute(@data);
            $to_hSt->finish;
        }
    };

    #例外処理
    if( $@ ){  # $@ にエラーメッセージが入っている
        print($@);
        $$ref_to_dbh->rollback;
        &module::logger::write_log("--- ROLLBACK ---");
        die "$@";
    }else{
        $$ref_to_dbh->commit;
        &module::logger::write_log("　　COMMIT");
    }
}

sub sync_room_pop_info{
	my $ref_from_dbh = \$_[0];	
	my $ref_to_dbh = \$_[1];
	my $navi_table = $_[2];
	my $chintai_table = $_[3];
	&module::logger::write_log("　　START SYNC DATA");
	eval{
		my $from_hSt;
		my $insert_stm;
		my $delete_stm;
		my $update_stm;
		my $correct_sync_mode;
		# Select all the records that need to be synced
		&module::logger::write_log("SELECT RECORDS THAT NEED TO BE SYNCED");
		$from_hSt = $$ref_from_dbh->prepare(&module::db::make_select_room_pop_info($navi_table));
		$from_hSt->execute();
		# Bind output columns
		my ($id, $room_id, $pop_id, $sync_mode);
		$from_hSt->bind_columns(\($id, $room_id, $pop_id, $sync_mode));
		&module::logger::write_log("BEGIN SYNC DATA");
		while($from_hSt->fetch){
			# Get all the record from ROOM_POP_INFO table
			if ($sync_mode == 1) {
				# Insert correspond records into destination table (CHINTAI)
				$insert_stm = $$ref_to_dbh->prepare(&module::db::make_insert_room_pop_info($chintai_table, $id, $room_id, $pop_id));
				$insert_stm->execute;
				# Update current record in NAVI (set SYNC_MODE = 0)
				$correct_sync_mode = $$ref_from_dbh->prepare(&module::db::make_update_sync_mode($navi_table ,$room_id, $pop_id, $sync_mode));
				$correct_sync_mode->execute;
			}
			elsif ($sync_mode == 2) {
				# Delete correspond records in destination table (CHINTAI)
				$delete_stm = $$ref_to_dbh->prepare(&module::db::make_delete_room_pop_info_ref_db($chintai_table, $room_id, $pop_id));
				$delete_stm->execute;
				# Update current record in NAVI (set SYNC_MODE = 0)
				$correct_sync_mode = $$ref_from_dbh->prepare(&module::db::make_delete_room_pop_info_from_db($navi_table, $room_id, $pop_id, $sync_mode));
				$correct_sync_mode->execute;
			}
		}
	};
	if ($@) {
		# Rollback transaction if there are errors
		$$ref_from_dbh->rollback;
		$$ref_to_dbh->rollback;
		&module::logger::write_log("Error: $@");
		&module::logger::write_log("--- ROLLBACK ---");
	} 
	else {
		# End transaction
		$$ref_from_dbh->commit;
		$$ref_to_dbh->commit;
		&module::logger::write_log("　　COMMIT");
	}
	&module::logger::write_log("END SYNC DATA");
}

sub clean_up{
	my $ref_from_dbh = \$_[0];	
	my $ref_to_dbh = \$_[1];
	my $navi_table = $_[2];
	my $chintai_table = $_[3];
	eval{
		my $navi_cleanup;
		my $chintai_cleanup;
		# Delete redundant records at NAVI side
		&module::logger::write_log("NAVI: START DELETE REDUNDANT RECORDS");
		$navi_cleanup = $$ref_from_dbh->prepare(&module::db::make_navi_clean_up($navi_table, $NAVI_FACILITY_POP_INFO));
		$navi_cleanup->execute;
		&module::logger::write_log("NAVI: END DELETE REDUNDANT RECORDS");
		# Delete redundant records at CHINTAI side
		&module::logger::write_log("CHINTAI: START DELETE REDUNDANT RECORDS");
		$chintai_cleanup = $$ref_to_dbh->prepare(&module::db::make_chintai_clean_up($chintai_table, $CHINTAI_MST_POP_INFO));
		$chintai_cleanup->execute;
		&module::logger::write_log("CHINTAI: END DELETE REDUNDANT RECORDS");
	};
	if ($@) {
		# Rollback transaction if there are errors
		$$ref_from_dbh->rollback;
		$$ref_to_dbh->rollback;
		&module::logger::write_log("Error: $@");
		&module::logger::write_log("--- ROLLBACK ---");
	} 
	else {
		# End transaction
		$$ref_from_dbh->commit;
		$$ref_to_dbh->commit;
		&module::logger::write_log("　　COMMIT");
	}
}
