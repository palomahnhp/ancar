class Setting < ActiveRecord::Base

  validates :key, presence: true, uniqueness: true

  default_scope { order(id: :asc) }

  def type
    if imported_source?
      'imported_source'
    elsif validations?
      'validation'
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

