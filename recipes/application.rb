package 'git'

group node['gse']['group']

user node['gse']['user'] do
  gid node['gse']['group']
  shell '/bin/bash'
  system true
  supports manage_home: true
end

user_home = File.join('/home', node['gse']['user'])

directory user_home do
  owner node['gse']['user']
  group node['gse']['group']
end

if node['gse']['env'] != 'development'
  git File.join(user_home, 'current') do
    repository node['gse']['repo']
    action :checkout
    user node['gse']['user']
    group node['gse']['group']
  end
end
