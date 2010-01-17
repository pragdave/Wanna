Wanna::Helpers.for("Tracing and logging") do
  def say(*msg)
    Wanna::Log.info(*msg)
  end
  
  def error(*msg)
    Wanna::Log.error(*msg)
  end
  
end