module CB_PluginInfo
  base_name = File.dirname(__FILE__).split("/").last
  const_set("#{base_name}_VERSION", "1.1.1")
  const_set("#{base_name}_DATE", "12/31/2014")
end
