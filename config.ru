require "tempfile"
require "ferrum"
require_relative "lib/dashboard"

SETTINGS = {
  browser_options: {
    "disable-dev-shm-usage" => nil,
    "disable-gpu" => nil,
    "hide-scrollbar" => nil,
    "no-sandbox" => nil,
    "enable-local-file-accesses" => nil
  },
  js_errors: true
}.freeze
VIEWPORT = { width: 1600, height: 1200, scale_factor: 1 }.freeze

map "/content" do |env|
  run do |env|
    [200, {'Content-Type' => 'text/html'}, [Dashboard.new.render]]
  end
end

map "/" do |env|
  run do |env|
    bin = ""
    size = ""

    Tempfile.open do |f|
      Ferrum::Browser.new(SETTINGS).then do |instance|
        instance.create_page
        instance.set_viewport(**VIEWPORT)
        instance.disable_javascript
        instance.go_to("http://localhost:3000/content")
        instance.network.wait_for_idle
        instance.screenshot path: f.path, format: :png, quality: 100

        instance.quit
      end

      bin = File.binread(f.path)
      size = File.size(f.path).to_s
    end

    [
      200,
      {
        'Content-Type'   => 'image/png',
        'Content-Length' => size
      },
      [bin]
    ]
  end
end
