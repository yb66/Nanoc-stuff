class Link_reffing < Nanoc3::Filter
  identifier :linkreffing
  
  UNITS = ['&#8304;', '&#185;', '&#178;', '&#179;', '&#8308;', '&#8309;', '&#8310;', '&#8311;', '&#8312;', '&#8313;']
  
  MKDN = ->(lnk, num){ %Q![#{lnk}](##{num} "Jump to reference")! }
 
  def run(content, params={})
    
    cur = 0 #current number
    links = [ ] #to store the matches
    
    blk = ->(m) do  #block to pass to gsub
      links << [$1, $2] # add to the words list
      mags = cur.divmod(10) #get magnitude of number
      ref_tag = mags.first >= 1 ? UNITS[mags.first] : '' #sort out tens
      ref_tag += UNITS[mags.last] #units
      
      
      format = params[:format].nil? ? MKDN : params[:format] # markdown is the default format
      retval = format.(ref_tag,cur)
      cur = cur + 1 #increase current number
  
      retval
    end
    
    r = /             # [[link|description]]
          \[\[        # opening square brackets
            (\S+)     # link
              \|      # separator
            ([^\[]+)  # description
          \]\]        # closing square brackets
        /x 
    
    replacement = content.gsub( r, &blk ) + '\n'
    replacement + format_links(links) unless links.empty?
    
  end
  
  def format_links( links )
    text = "********\n"
    cur = 0
    links.each do |lnk|
      text += %Q!<a name="#{cur}"></a>[#{cur}] [#{lnk.first[0,45]}](#{lnk.first} "#{lnk.first}") #{lnk.last}\n\n!
      cur += 1
    end
    text + "- - -"
  end

end