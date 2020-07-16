require 'warning'

[File.dirname(__dir__), *Gem.path].each do |path|
  Warning.ignore %i[missing_ivar method_redefined], path
end
