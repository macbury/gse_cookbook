postgresql_version      = node['gse']['db']['version']
postgresql_cluster_name = node['gse']['db']['cluster']

postgresql postgresql_cluster_name do
  cluster_version postgresql_version
  cluster_create_options( locale: 'pl_PL.UTF-8' )
end

databases = data_bag('gse_db')

databases.each do |database_name|
  database = data_bag_item('gse_db', database_name)

  postgresql_user database['user'] do
    in_version postgresql_version
    in_cluster postgresql_cluster_name
    unencrypted_password database['password']
  end

  postgresql_database database_name do
    in_version postgresql_version
    in_cluster postgresql_cluster_name
    owner database['user']
  end
end
