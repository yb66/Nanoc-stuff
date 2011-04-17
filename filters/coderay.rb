# encoding: UTF-8

require 'hpricot' 
require 'coderay'

# A filter for Coderay
# It finds text already wrapped with pre and code tags, adds the Coderay CSS class to them, strips out the inner html and codifies it and then puts it back in. The language is either set by using the options hash, or by adding ::::LANGUAGE_NAME to the first line of the code text e.g. ::::ruby
# If the language is not supported then you can add ::::skip or leave it off completely and the filtering will be skipped.
# I've not tested this with Nanoc but I use it with Sinatra and markdown, minus the Nanoc3 bits.
# Many thanks to Rob Emerson, I got some code of his and changed it to get this working
# see http://www.remerson.plus.com/articles/nanoc-coderay/
class Coderay_Filter  < Nanoc3::Filter

    identifier :coderay_filter
  
    def run(content, options={}) 
      doc = Hpricot(content) 
      
      code_blocks = (doc/"pre/code").map do |code_block|
        #un-escape as Coderay will escape it again
        inner_html = code_block.inner_html
        
        # following the convention of Rack::Codehighlighter
        if inner_html.start_with?("::::") 
          lines = inner_html.split("\n")
          options[:lang] = lines.shift.match(%r{::::(\w+)})[1].to_sym
          inner_html = lines.join("\n")
        end
        
        if (options[:lang] == :skip) || (! options.has_key? :lang )
          code_block.inner_html = inner_html
        else         
          code = codify(html_unescape(inner_html), options[:lang]) 
          code_block.inner_html = code   
           
          code_block["class"] = "Coderay"  
        end      
                
      end#block

      doc.to_s
    end#def
    
    private
      
    def html_unescape(a_string) 
      a_string.gsub('&amp;', '&').gsub('&lt;', '<').gsub('&gt;', 
      '>').gsub('&quot;', '"') 
    end#def
    
    def codify(str, lang) 
      %{#{CodeRay.scan(str, lang).html}} 
    end#def
    
   
   
end#class 