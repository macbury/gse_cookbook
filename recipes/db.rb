postgresql_version      = node['gse']['db']['version']
postgresql_cluster_name = node['gse']['db']['cluster']

apt_repository 'pgdg' do
  uri 'http://apt.postgresql.org/pub/repos/apt/'
  components ['main']
  distribution 'trusty-pgdg'
  key 'https://www.postgresql.org/media/keys/ACCC4CF8.asc'
  action :add
  deb_src true
end

include_recipe 'postgresql::default'
include_recipe 'postgresql::server'
include_recipe 'postgresql::ruby'

databases = data_bag('gse_db')

postgres_connection = {
  host: '127.0.0.1',
  username: 'postgres',
  password: node['postgresql']['password']['postgres']
}

databases.each do |database_name|
  database = data_bag_item('gse_db', database_name)

  postgresql_database database_name do
    connection(postgres_connection)
    action :create
  end

  postgresql_database_user database['user'] do
    password database['password']
    database_name database_name
    privileges    [:all]
    action        :grant
  end
end
