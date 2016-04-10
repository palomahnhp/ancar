module SettingsHelper
  def setting
    @all_settings ||= Hash[ Setting.all.map{|s| [s.key, s.value.presence]} ]
  end
end
