class Embedding_music < Nanoc3::Filter
  identifier :embedding_music
  
  def run(content, params={})
    
    html = ->(link,desc){ <<END
{::nomarkdown}<div class="music"><h3>#{desc}</h3>
  <embed src="/music/#{link}"
    height="60"
    width="145"
    autostart="false"
    loop="false"
    width="0"
    height="0">
  </embed>
</div>{:/nomarkdown}
END
    }
    
    # [music[link|name]]
    r_link = /             # [music[url|description]]
      \[music\[        # opening square brackets
        ([^\|]+)     # link
          \|      # separator
        ([^\[]+)  # description
      \]\]        # closing square brackets
    /x
    
    content.gsub( r_link ) { |m|
      url,desc = $1,$2
      html.(url,desc)
    }
    
  end

end