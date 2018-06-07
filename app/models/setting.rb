class Setting < ActiveRecord::Base
  validates :key, presence: true, uniqueness: true

  default_scope { order(id: :asc) }

  TYPES = %w(imported_sources_editable
             validations.lower_staff
             rpt.only_grtit
             rpt.vacancy
             supervisor.email
             send_email.change_staff
             main_process_organization)

  def type
    type  = TYPES.select { |type| key.include?(type) }
    return type[0] if type.present?
    'common'
  end

  def to_s
    key_i18n
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

