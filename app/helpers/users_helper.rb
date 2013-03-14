module UsersHelper

  def youtube_embed(youtube_url,width,height)
    youtube = true
    if youtube_url[/youtu\.be\/([^\?]*)/]
      youtube_id = $1
    elsif
      # Regex from # http://stackoverflow.com/questions/3452546/javascript-regex-how-to-get-youtube-video-id-from-url/4811367#4811367
    youtube_url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
      youtube_id = $5
    else
      youtube_url[/https?:\/\/(?:www\.)?vimeo.com\/(?:channels\/|groups\/([^\/]*)\/videos\/|album\/(\d+)\/video\/|)(\d+)(?:$|\/|\?)/]
      youtube_id = $3
      youtube = false
    end

    if(youtube)
      %Q{<iframe title="YouTube video player" width="#{ width }" height="#{ height }" src="http://www.youtube.com/embed/#{ youtube_id }" frameborder="0" allowfullscreen></iframe>}
    else
      %Q{<iframe title="Vimeo video player" width="#{ width }" height="#{ height }" src="http://player.vimeo.com/video/#{ youtube_id }?color=C6091C" frameborder="0" allowfullscreen></iframe>}
    end

    end

end
