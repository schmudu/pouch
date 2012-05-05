module ResourcesHelper
  def get_file_info full_path
    results = {}

    #find uploads directory
    full_path =~ /\/uploads\//
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
    results
  end

  def get_cache_file_info full_path
    results = {}

    #find uploads directory
    full_path =~ /\/cache\//
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
    results
  end
end
