guard 'livereload', :apply_css_live => true, :apply_js_live => false do
  watch(%r{(public/).+\.(css|js)})
  watch(%r{(views/).+\.(jade)})
  watch(%r{(routes/).+\.(coffee|js)})
end

guard 'compass' do
  watch(/^sass\/(.*)\.s[ac]ss/)
end

guard 'coffeescript', :input => 'coffeescript', :output => 'public/js', :bare => %w{}
