# Preview all emails at http://localhost:3000/rails/mailers/supervisor_mailer
class SupervisorMailerPreview < ActionMailer::Preview
  def change_staff_email

    SupervisorMailer.change_staff_email(change: 'open',
                                        period: Period.find(7),
                                        unit: Unit.find(1),
                                        user: User.first)
  end
end
