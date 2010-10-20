class Resize_filter < Nanoc3::Filter

#from the helpful nanoc docs

  identifier :resize
  type :binary

  def run(filename, params={})
    system(
      'sips',
      '--resampleWidth', params[:width].to_s,
      '--out', output_filename,
      filename
    )
  end
end