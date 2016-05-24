
node.default['gse'] = {
  ruby: '2.3',
  repo: 'git@github.com:macbury/gse.git',
  user: 'gse',
  group: 'gse',
  env: 'development',
  db: {
    version: '9.5',
    cluster: 'gse-main'
  }
}
