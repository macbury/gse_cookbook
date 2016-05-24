
describe command('ruby -v') do
  its(:stdout) { should match /ruby 2/ }
end

describe command('bundle -v') do
  its(:stdout) { should match /Bundler version/ }
end
