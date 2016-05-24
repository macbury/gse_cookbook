include_recipe 'postgresql::server'
include_recipe 'postgresql::client'
include_recipe 'database::postgresql'

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

  postgresql_database_user database['user']do
    connection(postgres_connection)
    password   database['password']
    action     :create
  end

  postgresql_database_user database['user'] do
    connection(postgres_connection)
    password database['password']
    database_name database_name
    privileges    [:all]
    action        :grant
  end
end
