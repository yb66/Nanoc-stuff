class No_link_reffing < Nanoc3::Filter
  identifier :no_link_reffing
 
  def run(content, params={})
    
    r = /             # [[link|description]]
          \[(?:\w+)?\[        # opening square brackets
            \S+     # link
              \|      # separator
            ([^\[]+)  # description
          \]\]        # closing square brackets
        /x 
    
    replacement = content.gsub( r, '' )
    
  end


end