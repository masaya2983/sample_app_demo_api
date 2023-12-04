Dir[Rails.root.join('lib/refile/*.rb')].sort.each do |file|
  require file
end

Refile.backends['store'] = Refile::Backend::FileSystem.new('public/uploads/')
