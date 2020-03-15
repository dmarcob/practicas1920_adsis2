#! /usr/bin/ruby -w

path = ARGV[0]
fail "necesito un nombre de fichero" unless path
File.open(path, "w") { |f| f.puts "#!/usr/bin/ruby -w"}
File.chmod(0755, path)
system "vi", path
