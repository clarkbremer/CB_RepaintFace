module CB_PluginInfo
  base_name = File.dirname(__FILE__).split("/").last
  const_set("#{base_name}_VERSION", "1.1.2")
  const_set("#{base_name}_DATE", "1/7/2016")
end
