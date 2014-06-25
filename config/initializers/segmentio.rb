Analytics = Segment::Analytics.new({
    write_key: Settings[Rails.env][:write_key],
    on_error: Proc.new { |status, msg| print msg }
})