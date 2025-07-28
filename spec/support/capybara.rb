Capybara.register_driver :remote_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('no-sandbox')
  options.add_argument('headless')
  options.add_argument('disable-gpu')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('window-size=1680,1050')
  Capybara::Selenium::Driver.new(app, browser: :remote, url: ENV['SELENIUM_DRIVER_URL'], capabilities: options)
end

if ENV['GITHUB_ACTIONS']
  Capybara.default_driver = :remote_chrome
  Capybara.javascript_driver = :remote_chrome
  Capybara.server_host = '0.0.0.0'
  Capybara.server_port = 3000
end
