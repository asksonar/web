class GeoIpUtility
  include Singleton

  def db
    @db ||= MaxMindDB.new('./vendor/assets/GeoLite2-City.mmdb')
  end

  # sample .to_hash
  # { "city"=>
  #   {"geoname_id"=>5375480, "names"=>{"de"=>"Mountain View", "en"=>"Mountain View", "fr"=>"Mountain View", "ja"=>"マウンテンビュー", "ru"=>"Маунтин-Вью", "zh-CN"=>"芒廷维尤"}},
  #   "continent"=>{"code"=>"NA", "geoname_id"=>6255149, "names"=>{"de"=>"Nordamerika", "en"=>"North America", "es"=>"Norteamérica", "fr"=>"Amérique du Nord", "ja"=>"北アメリカ", "pt-BR"=>"América do Norte", "ru"=>"Северная Америка", "zh-CN"=>"北美洲"}},
  #   "country"=>{"geoname_id"=>6252001, "iso_code"=>"US", "names"=>{"de"=>"USA", "en"=>"United States", "es"=>"Estados Unidos", "fr"=>"États-Unis", "ja"=>"アメリカ合衆国", "pt-BR"=>"Estados Unidos", "ru"=>"Сша", "zh-CN"=>"美国"}},
  #   "location"=>{"latitude"=>37.419200000000004, "longitude"=>-122.0574, "metro_code"=>807, "time_zone"=>"America/Los_Angeles"},
  #   "postal"=>{"code"=>"94043"},
  #   "registered_country"=>{"geoname_id"=>6252001, "iso_code"=>"US", "names"=>{"de"=>"USA", "en"=>"United States", "es"=>"Estados Unidos", "fr"=>"États-Unis", "ja"=>"アメリカ合衆国", "pt-BR"=>"Estados Unidos", "ru"=>"Сша", "zh-CN"=>"美国"}},
  #   "subdivisions"=>[{"geoname_id"=>5332921, "iso_code"=>"CA", "names"=>{"de"=>"Kalifornien", "en"=>"California", "es"=>"California", "fr"=>"Californie", "ja"=>"カリフォルニア州", "pt-BR"=>"Califórnia", "ru"=>"Калифорния", "zh-CN"=>"加利福尼亚州"}}]
  # }
  def lookup_ip_address(ip_address)
    ret = db.lookup(ip_address)
    return ret.subdivisions[-1].try(:name), ret.country.name
  end
end
