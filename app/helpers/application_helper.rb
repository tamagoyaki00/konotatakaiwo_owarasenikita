module ApplicationHelper
  def current_user_reaction_for(opinion)
    current_user.opinion_reactions.find_by(opinion: opinion)
  end

  def current_user_liked?(opinion)
    current_user.liked_opinions.include?(opinion)
  end


  def default_meta_tags
    {
      site: "この戦いを終わらせに来た！！～究極の2択～",
      title: "",
      reverse: true,
      separator: "|",
      description: "究極の2択問題を作成・回答できる掲示板アプリです。ここで論争を終結させましょう。",
      keywords: "究極,究極の2択,究極の二択,戦い,投票",
      canonical: request.original_url,
      noindex: !Rails.env.production?,
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: "website",
        url: request.original_url,
        image: image_url("konotatakaiwo_owarasenikita_ogp.png"),
        locale: "ja_JP"
      },
      twitter: {
        card: "summary_large_image",
        image: image_url("konotatakaiwo_owarasenikita_ogp.png")
      }
    }
  end
end
