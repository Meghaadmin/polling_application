class UserMailer < ActionMailer::Base
  default :from => 'Admin'

  def send_password(user)
     @user = user
     @to = user.email_id
     mail :to => @to, @from=> 'Admin',:subject => 'Approved'
  end

  def final_candidates_mail(user,first_candidate,second_candidate,election)
    @user = user
    @to = user.email_id
    @first_candidate = first_candidate
    @second_candidate = second_candidate
    @election = election
    mail :to => @to, @from=> 'Admin',:subject => 'Voting Time and candidates'
  end

  def result(user,winner)
    @user = user
    @to = user.email_id
    @winning_candidate = winner
    mail :to => @to, @from=> 'Admin',:subject => 'Result Declaration'
  end
end