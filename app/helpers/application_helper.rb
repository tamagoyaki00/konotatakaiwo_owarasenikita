module ApplicationHelper
  def turbo_stream_flash
    turbo_stream.update "flash", partial: "shared/flash"
  end


  def flash_class_for(type)
    case type.to_sym
    when :notice then "bg-green-100 border border-green-400 text-green-700"
    when :alert, :error then "bg-red-100 border border-red-400 text-red-700"
    else "bg-blue-100 border border-blue-400 text-blue-700"
    end
  end

  def user_voted?(user, question)
    return false unless user
    user.votes.joins(:option).where(options: { question_id: question.id }).exists?
  end

  def current_user_vote(user, question)
    return nil unless user
    user.votes.joins(:option).find_by(options: { question_id: question.id })
  end
end
