include_recipe 'postgresql::server'
include_recipe 'postgresql::client'
include_recipe 'database::postgresql'
postgres_connection = {
  host: '127.0.0.1',
  username: 'postgres',
  password: node['postgresql']['password']['postgres']
}

data_bag('gse_db').each do |database_name|
  database = data_bag_item('gse_db', database_name)

  postgresql_database_user database['user'] do
    connection(postgres_connection)
    password   database['password']
    action     :create
  end

  postgresql_database database_name do
    connection(postgres_connection)
    action :create
    owner database['user']
  end

  postgresql_database_user database['user'] do
    connection(postgres_connection)
    password database['password']
    database_name database_name
    privileges    [:all]
    action        :grant
  end
end
