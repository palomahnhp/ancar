class Setting < ActiveRecord::Base

  validates :key, presence: true, uniqueness: true

  default_scope { order(id: :asc) }

  def type
    if imported_source?
      'imported_source'
    elsif validations?
      'validation'
    elsif rpt_vacancy?
      'rpt.vacancy'
    elsif rpt_only_grtit?
      'rpt.only_grtit'
    elsif rpt_political?
      'rpt.political'
    elsif send_email_change_staff?
      'send_email.change_staff'
    else
      'common'
    end
  end

  def imported_source?
    key.start_with?('imported_sources_editable.')
  end

  def validations?
    key.start_with?('validations.')
  end

  def rpt_only_grtit?
    key.start_with?('rpt.only_grtit.')
  end

  def rpt_political?
    key.start_with?('rpt.political.')
  end

  def rpt_vacancy?
    key.start_with?('rpt.vacancy.')
  end

  def send_email_change_staff?
    key.start_with?('send_email.change_staff.')
  end

  def enabled?
    value.present? && (value.downcase  == 'true' ?  true : false)
  end

  class << self
    def [](key)
      where(key: key).pluck(:value).first.presence
    end

    def []=(key, value)
      setting = where(key: key).first || new(key: key)
      setting.value = value.presence
      setting.save!
      value
    end
  end
end

