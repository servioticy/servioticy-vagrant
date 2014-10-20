require 'spec_helper'

describe 'gradle' do

  context 'default' do
    it do
      should contain_file('/etc/profile.d/gradle.sh').with({
        'ensure' => 'file',
        'mode' => '0644'
      })
    end

    it 'should generate valid content' do
      content = catalogue.resource('file', '/etc/profile.d/gradle.sh').send(:parameters)[:content]
      content.should include('export GRADLE_HOME=/opt/gradle')
      content.should include('export PATH="$PATH:/opt/gradle/bin"')
      content.should include('export GRADLE_OPTS="-Dorg.gradle.daemon=true"')
    end
  end

  context 'custom target' do
    let(:params) { { :target => '/usr/local/gradle' } }

    it 'should generate valid content' do
      content = catalogue.resource('file', '/etc/profile.d/gradle.sh').send(:parameters)[:content]
      content.should include('export GRADLE_HOME=/usr/local/gradle')
      content.should include('export PATH="$PATH:/usr/local/gradle/bin"')
    end
  end

  context 'no daemon' do
    let(:params) { { :daemon => false } }

    it 'should generate valid content' do
      content = catalogue.resource('file', '/etc/profile.d/gradle.sh').send(:parameters)[:content]
      content.should_not include('export GRADLE_OPTS="-Dorg.gradle.daemon=true"')
    end
  end
end

