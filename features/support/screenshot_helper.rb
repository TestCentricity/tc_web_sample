def screen_shot_and_save_page(scenario)
  timestamp = Time.now.strftime('%Y%m%d%H%M%S')
  scenario.nil? ? filename = "Screenshot-#{timestamp}" : filename = "Screenshot-#{scenario.__id__}-#{timestamp}"
  path = File.join Dir.pwd, 'reports/screenshots/', filename
  save_screenshot "#{path}.png"
  puts "Screenshot saved at #{path}.png"
  if scenario.nil?
    screen_shot = { :path => path, :filename => filename }
    Environ.save_screen_shot(screen_shot)
  else
    embed("#{path}.png", 'image/png', filename)
  end
end


begin
  After do |scenario|
    screen_shots = Environ.get_screen_shots
    if screen_shots.count > 0
      screen_shots.each do |row|
        path = row[:path]
        filename = row[:filename]
        embed("#{path}.png", 'image/png', filename)
      end
    else
      screen_shot_and_save_page(scenario) if scenario.failed?
    end
    Environ.reset_contexts
  end
rescue Exception => e
  puts 'Snapshots not available for this environment. Have you enabled the javascript driver?'
end
