module ResourcesHelper
  def get_file_info(full_path, is_upload = true)
    #is_upload is true(upload) or false(cache...tmp/cache to be exact)
    results = {}

    #find uploads directory
    is_upload ? full_path =~ /\/uploads\// : full_path =~ /\/cache\//
    post_match = $~.post_match

    #find folder
    folder_index = post_match.index('/')
    folder = post_match[0..(folder_index-1)]
    results[:folder] = folder

    #find extension
    extension_index = post_match =~ /\.[a-z]+\Z/
    extension = post_match[(extension_index + 1)..post_match.length]
    results[:extension] = extension

    #find basename
    base_name = post_match[(folder_index+1)..(extension_index-1)]
    results[:base_name] = base_name

    #find identifier
    identifier = post_match[(folder_index+1)..post_match.length]
    results[:identifier] = identifier

    results
  end
end
