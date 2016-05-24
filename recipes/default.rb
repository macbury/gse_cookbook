include_recipe 'apt'

include_recipe 'gse::ruby'
include_recipe 'gse::db'
include_recipe 'gse::application'
include_recipe 'gse::web'
