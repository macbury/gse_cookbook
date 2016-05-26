package 'git'

rails_env = node['gse']['env']

group node['gse']['group']

user node['gse']['user'] do
  gid node['gse']['group']
  shell '/bin/bash'
  system true
  supports manage_home: true
end

user_home    = File.join('/home', node['gse']['user'])

directory user_home do
  owner node['gse']['user']
  group node['gse']['group']
end

lxmx_oh_my_zsh_user node['gse']['user'] do
  plugins        %w{git ruby}
  autocorrect    false
  case_sensitive true
  theme 'robbyrussell'
end

rsa_key       = search(:gse_git_keys, "id:#{rails_env}").first
temp_key_path = '/tmp/id_rsa'

if rsa_key
  ssh_keys_dir = File.join(user_home, '.ssh')

  directory ssh_keys_dir do
    owner node['gse']['user']
    group node['gse']['group']
    mode '0700'
    action :create

    not_if "test -e #{ssh_keys_dir}"
  end

  file File.join(ssh_keys_dir, 'id_rsa.pub') do
    owner node['gse']['user']
    group node['gse']['group']
    mode '0600'
    content rsa_key['public_key']
  end

  file File.join(ssh_keys_dir, 'id_rsa') do
    owner node['gse']['user']
    group node['gse']['group']
    mode '0600'
    content rsa_key['private_key'].join("\n")
  end

  known_hosts_path = File.join(ssh_keys_dir, 'known_hosts')

  execute "authorize_github" do
    command "ssh-keyscan -t rsa github.com >> #{known_hosts_path}"
    not_if "test -e #{known_hosts_path}"
  end
else
  throw "No rsa key found for #{rails_env} in gse_git_keys databag"
end

app_directory    = File.join(user_home, 'current')
shared_directory = File.join(user_home, 'shared')

git app_directory do
  repository node['gse']['repo']
  revision 'master'
  user node['gse']['user']
  group node['gse']['group']
end

directory shared_directory do
  owner node['gse']['user']
  group node['gse']['group']
end

shared_database_config_path = File.join(shared_directory, 'database.yml')

database_config = data_bag('gse_db').inject({}) do |config, database_name|
  database = data_bag_item('gse_db', database_name)
  config[database['env']] = {
    'adapter'  => 'postgresql',
    'encoding' => 'unicode',
    'database' => database_name,
    'username' => database['user'],
    'password' => database['password'],
    'encoding' => 'utf8',
    'host' => 'localhost'
  }

  config
end

file shared_database_config_path do
  owner node['gse']['user']
  group node['gse']['group']

  content database_config.to_yaml
end

link File.join(app_directory, 'config/database.yml') do
  owner node['gse']['user']
  group node['gse']['group']
  to shared_database_config_path
end
