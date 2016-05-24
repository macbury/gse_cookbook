include_recipe 'build-essential::default'
include_recipe 'ruby_build'

package 'libssl-dev'
package 'libreadline-dev'
package 'zlib1g-dev'

ruby_build_ruby node['gse']['ruby'] do
  prefix_path '/usr/local/'
  action :install
end

gem_package 'bundler' do
  options '--no-ri --no-rdoc'
end
