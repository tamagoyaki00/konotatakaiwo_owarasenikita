module FlashHelper
  def turbo_stream_flash
    turbo_stream.update "flash", partial: "shared/flash"
  end

  def flash_class_for(type)
    case type.to_sym
    when :notice then "bg-green-100 border border-green-400 text-green-700"
    when :alert, :error then "bg-red-100 border border-red-400 text-red-700"
    end
  end
end
