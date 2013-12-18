# Dir.glob("sass/vendor/font-awesome/4.0.3/**/*.scss") do |file|

# 	puts "open => "+file

# 	file_name = file.split('/').pop
# 	curr_dir = file.split('/')
# 	curr_dir = curr_dir[0...-1].join('/')

# 	new_file_name = "_new"+file_name

# 	File.open(curr_dir+"/"+new_file_name, "w") do |new_file|
# 		File.open(file, "r") do |old_file|
# 			old_file.each_line do |line|
# 				path = /url\(['"][^\)]*['"]\)/
# 				path_string = path.match(line).to_s
# 				path_string = path_string.match(/['"](.*)['"]/).to_s.split('/')

# 				regex_path = path_string[-2].to_s.gsub(/['"]/,"")+"/"+path_string[-1].to_s.gsub(/['"]/,"")
# 				new_path = "../"+curr_dir+"/"+regex_path

# 				new_file.puts line.gsub(path, "url('"+new_path+"')")
# 			end
# 		end
# 	end

# 	File.rename(file, curr_dir+"/"+"_copy"+file_name)
# 	File.rename(curr_dir+"/"+new_file_name, curr_dir+"/"+file_name)

# 	puts "close => "+file
# end

Dir.glob("themes/**/sass/vendor/**/*.scss") do |file|

	file_name = file.split('/').pop
	curr_dir = file.split('/')
	curr_dir = curr_dir[0...-1].join('/')

	new_file_name = "_new"+file_name

	File.open(curr_dir+"/"+new_file_name, "w") do |new_file|
		File.open(file, "r") do |old_file|
			old_file.each_line do |line|
				path = /url\([^\)]*\)/
				path_string = path.match(line).to_s.gsub("url(","").gsub(")","").gsub(/['"]/,"").to_s
				new_path = "../"+curr_dir+"/"+path_string
				new_file.puts line.gsub(path, "url('"+new_path+"')")
			end
		end
	end

	File.rename(file, curr_dir+"/"+"_copy"+file_name)
	File.rename(curr_dir+"/"+new_file_name, curr_dir+"/"+file_name)
end