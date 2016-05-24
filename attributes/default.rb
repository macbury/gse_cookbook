
default['gse'] = {
  ruby: '2.3',
  repo: 'git@github.com:macbury/gse.git',
  user: 'gse',
  group: 'gse',
  env: 'development',
  db: {
    version: '9.3',
    cluster: 'gse-main'
  }
}

default['postgresql']['enable_pgdg_apt']   = true
default['postgresql']['version']           = '9.3'
default['apt']['compile_time_update']      = true
default['build-essential']['compile_time'] = true
