module BodyClassHelper
  def body_classes
    case "#{controller_name}##{action_name}"
    when "users#show"
      "min-h-full"
    when "questions#index"
      "h-screen"
    else
      "min-h-screen"
    end
  end
end