# https://github.com/jtrupiano/timecop/issues/25

Zip::DOSTime.instance_eval do
  def now
    Zip::DOSTime.new(Time.now.to_s)
  end
end
