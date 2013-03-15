#-*- coding: utf-8 -*-

module AccountManager

  # APIを叩く際の共通フォーマット．Deferredを返す．
  def self.call_api(url, hash = {})
    deferred = nil
    begin
      deferred = (Service.primary.twitter/url).message(hash)
    rescue Exception => e
      Plugin.call(:update, nil, [Message.new(message: e.to_s, system: true)])
      e.backtrace
    end
    deferred
  end

  #
  # = GET関連
  #

  # 設定を取得
  def self.settings
    call_api('account/settings')
  end

  # 認証情報を取得
  def self.verify_credentials
    call_api('account/verify_credentials')
  end


  #
  # = POST関連
  #

  # 基本設定変更
=begin
<Parameters>
  | key                  | content                                 | condition                | require? |
  |----------------------+-----------------------------------------+--------------------------+----------|
  | trend_location_woeid | トレンド表示に使用するWhere On Earth ID | cf. GET trends/available | optional |
  | sleep_time_enabled   | 就寝時間中の通知をオフにする            | true,t,1                 | optional |
  | start_sleep_time     | 何時から寝るか                          | 00-23                    | optional |
  | end_sleep_time       | 何時に起きるか                          | 00-23                    | optional |
  | time_zone            | TimeZone設定                            | Rails TimeZone names     | optional |
  | lang                 | 言語設定                                | cf. GET help/languages   | optional |
=end
  def self.settings(hash)
    call_api('account/settings', hash)
  end

  # 通知設定
=begin
<Parameters>
  | key              | content          | condition   | require? |
  |------------------+------------------+-------------+----------|
  | device           | 通知のON/OFF設定 | sms or none | required |
  | include_entities |                  | true,t,1    | optional |
=end
  def self.update_delivery_device(hash)
    call_api('update_delivery_device', hash)
  end

  # 背景画像変更
=begin
<Parameters>
  | key              | content                        | condition          | require? |
  |------------------+--------------------------------+--------------------+----------|
  | image            | Base64エンコードされた背景画像 | GIF,JPG,PNG,<800kB | optional |
  | tile             | タイル状にするか               | true,t,1           | optional |
  | include_entities |                                | true,false         | optional |
  | skip_status      |                                | true,t,1           | optional |
  | use              | 背景画像色を使用するかどうか   | true,t,1           | optional |
=end
  def self.update_profile_background_image(hash)
    call_api('account/update_profile_background_image', hash)
  end

  # プロフィールの色設定
=begin
<Parameters>
  | key                          | content                    | condition  | require? |
  |------------------------------+----------------------------+------------+----------|
  | profile_background_color     | プロフィール背景色         | 3 or 6文字 | optional |
  | profile_link_color           | リンクの色                 | 3 or 6文字 | optional |
  | profile_sidebar_border_color | サイドバーのborder色       | 3 or 6文字 | optional |
  | profile_sidebar_fill_color   | サイドバーの背景色         | 3 or 6文字 | optional |
  | profile_text_color           | プロフィールのテキストの色 | 3 or 6文字 | optional |
  | include_entities             |                            | true,false | optional |
  | skip_status                  |                            | true,t,1   | optional |
=end
  def self.update_profile_colors(hash)
    call_api('account/update_profile_colors', hash)
  end

  # プロフィール変更
=begin
<Parameters>
  | key              | content      | condition   | require? |
  |------------------+--------------+-------------+----------|
  | name             | 名前         | 20文字まで  | optional |
  | url              | ホームページ | 100文字まで | optional |
  | location         | 場所         | 30文字まで  | optional |
  | description      | 自己紹介     | 160文字まで | optional |
  | include_entities |              | true,false  | optional |
  | skip_status      |              | true,t,1    | optional |

  Example:
    AccountManager::update_profile({name: "ぺんぎんさん", location: "研究室"})
=end
  def self.update_profile(hash)
    call_api('account/update_profile', hash)
  end

  # アイコン変更
=begin
<Parameters>
  | key              | content                            | condition          | require? |
  |------------------+------------------------------------+--------------------+----------|
  | image            | Base64エンコードされた画像ファイル | GIF,JPG,PNG,<700kB | required |
  | include_entities |                                    | true,false         | optional |
  | skip_status      |                                    | true,t,1           | optional |

  Example:
    AccountManager::update_profile_image({image: Base64.encode64(open("path/to/image.png").read)})
=end
  def self.update_profile_image(hash)
    call_api('account/update_profile_image', hash)
  end

  # アップロード済みのバナー画像を削除する
  def self.remove_profile_banner
    call_api('account/remove_profile_banner')
  end

  # バナー画像の設定
=begin
<Parameters>
  | key         | content                        | condition                                   | require? |
  |-------------+--------------------------------+---------------------------------------------+----------|
  | banner      | Base64エンコードされた画像     | <5MB                                        | required |
  | width       | 画像を切り抜く際の幅           | require       height,offset_left,offset_top | optional |
  | height      | 画像を切り抜く際の高さ         | require width,       offset_left,offset_top | optional |
  | offset_left | 画像を切り抜く際の左オフセット | require width,height,            offset_top | optional |
  | offset_top  | 画像を切り抜く際の上オフセット | require width,height,offset_left            | optional |
=end
  def self.update_profile_banner(hash)
    call_api('account/update_profile_banner', hash)
  end

end

