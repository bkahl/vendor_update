require 'fileutils'

# arguments: theme, global
def init(which_vendor_path)

	puts "which_vendor_path #{which_vendor_path}"

	if which_vendor_path == "theme"
		vendor_path = "sass/vendor/**/*.scss"
		update_vendor(vendor_path)
	elsif which_vendor_path == "global"
		vendor_path = "../../sass/vendor/**/*.scss"
		update_vendor(vendor_path)
	else
		puts ""
		puts "*******************************************************"
		puts "ARGV '#{which_vendor_path}' dosen't exist. Please"
		puts "choose one of the following options below."
		puts ""
		puts "1) theme, ~> ruby vendor.rb theme"
		puts "2) global, ~> ruby vendor.rb global"
		puts ""
		puts "*******************************************************"
		puts ""
	end

end

def update_vendor(vendor_path)

	updated_path = vendor_path.gsub("/**/*.scss","/updated")
	# If updated directory exists within vendor_path, then remove it before updating
	if File.directory?(updated_path)
		FileUtils.rm_rf(updated_path)
		puts "deleted #{updated_path}"
	end

	# Add/Copy all /vendor files to the /updated directory to keep a backup copy of the original
	# vendor files
	vendor_path = vendor_path.gsub("/**/*.scss","/*")
	files = Dir.glob(vendor_path)
	FileUtils.mkdir updated_path
	FileUtils.cp_r files, updated_path
	puts "create #{updated_path}"

	vendor_path = updated_path+"/**/*.scss"

	Dir.glob(vendor_path) do |file|

		file_name = file.split('/').pop	
		curr_dir = file.split('/')
		curr_dir = curr_dir[0...-1].join('/')

		rename_file = curr_dir+"/_copy"+file_name
		File.rename(file, rename_file)

		# Make sure 'global' and 'theme' curr_dir path is correct
		if ARGV[0] == "global"
			curr_dir = curr_dir.gsub("../../","")
		elsif ARGV[0] == "theme"
			pwd = Dir.pwd.split("/")
			curr_dir = pwd[-2].to_s + "/" + pwd[-1].to_s + "/" + curr_dir
		end	

		File.open(file, "w") do |new_file|
			File.open(rename_file, "r") do |old_file|
				old_file.each_line do |line|
					path = /url\([^:\)]*\)/
					path_string = path.match(line).to_s.gsub("url(","").gsub(")","").gsub(/['"]/,"").to_s
					new_path = "../"+curr_dir+"/"+path_string
					new_file.puts line.gsub(path, "url('"+new_path+"')")
				end
			end
		end

		FileUtils.rm_rf(rename_file)

	end

end

argument = ARGV[0]
init(argument)