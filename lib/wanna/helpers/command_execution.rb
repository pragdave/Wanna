Wanna::Helpers.for("Command invocation") do
  require 'rbconfig'
  
  RUBY = File.join(::Config::CONFIG["bindir"], ::Config::CONFIG["ruby_install_name"])

  def sh(cmd, *args)
    if Wanna::Options[:show_commands]
      Wanna::Log.log_with_timestamp(:command, "sh #{cmd}")
    end
    unless system(cmd)
      report_failure(cmd, args)
    end
  end
  
  def ruby(*args)
    sh("#{RUBY} #{args.flatten.join(' ')}")
  end
  
  def report_failure(cmd, args)
    Wanna::Log.error("Command failed: #{cmd}")
    exit 1
  end
end