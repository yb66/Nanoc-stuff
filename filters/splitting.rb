class Splitting < Nanoc3::Filter
  identifier :splitting
  def run(content, params={})
    
    retval = content.split( /\<\!\-\-more\-\-\>/ )
    
    if retval.length > 1
      retval.first + ' ' + link_to('&hellip;keep reading &rarr;', @item.path)
    else
      retval.first
    end
    
  end

end