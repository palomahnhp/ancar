module ApprovalsActions
  extend ActiveSupport::Concern

  def get_approval(period, unit)
    Approval.by_period_and_unit(period, unit)
  end

  def set_approval(period, unit, comment, user)
    return Approval.add(period, unit, comment, user)
  end

  def delete_approval(period, unit)
    if Approval.delete(period, unit)
      return nil
    end

  end

end