include_recipe 'build-essential'

ruby_version = node['gse']['ruby']

apt_repository 'ruby-ng' do
  uri 'ppa:brightbox/ruby-ng'
  distribution 'trusty'
  components ['main']
end

package 'libxslt-dev'
package 'libxml2-dev'
package 'build-essential'
package 'libpq-dev'
package 'libsqlite3-dev'
package 'software-properties-common'

package "ruby#{ruby_version}"
package "ruby#{ruby_version}-dev"
gem_package 'bundler' do
  options '--no-ri --no-rdoc'
end
