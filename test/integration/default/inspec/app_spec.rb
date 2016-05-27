
describe 'Gse application' do
  it 'should have a gse user' do
    expect(user('gse')).to exist
  end

  it 'should have running postgresql' do
    expect(service 'postgresql').to be_running
    expect(service 'postgresql').to be_enabled
  end

  it 'should have running nginx' do
    expect(service 'nginx').to be_running
    expect(service 'nginx').to be_enabled
  end
end

describe command('ruby -v') do
  its(:stdout) { should match /ruby 2/ }
end

describe command('bundle -v') do
  its(:stdout) { should match /Bundler version/ }
end
