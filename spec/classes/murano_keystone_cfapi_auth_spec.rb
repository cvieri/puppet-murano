require 'spec_helper'

describe 'murano::keystone::cfapi_auth' do

  let :facts do
    { :osfamily => 'Debian' }
  end

  describe 'with default class parameters' do
    let :params do
      { :password => 'murano_password',
        :tenant   => 'foobar' }
    end

    it { is_expected.to contain_keystone_service('murano-cfapi::service_broker').with(
                            :ensure      => 'present',
                            :description => 'Murano Service Broker API'
                        ) }

    it { is_expected.to contain_keystone_endpoint('RegionOne/murano-cfapi::service_broker').with(
                            :ensure       => 'present',
                            :public_url   => "http://127.0.0.1:8083",
                            :admin_url    => "http://127.0.0.1:8083",
                            :internal_url => "http://127.0.0.1:8083"
                        ) }
  end

  describe 'with endpoint parameters' do
    let :params do
      { :password     => 'murano_password',
        :public_url   => 'https://10.10.10.10:80',
        :internal_url => 'http://10.10.10.11:81',
        :admin_url    => 'http://10.10.10.12:81' }
    end

    it { is_expected.to contain_keystone_endpoint('RegionOne/murano-cfapi::service_broker').with(
                            :ensure       => 'present',
                            :public_url   => 'https://10.10.10.10:80',
                            :internal_url => 'http://10.10.10.11:81',
                            :admin_url    => 'http://10.10.10.12:81'
                        ) }
  end

  describe 'when overriding auth name' do
    let :params do
      { :password => 'foo',
        :auth_name => 'muranoy' }
    end

    it { is_expected.to contain_keystone_service('muranoy::service_broker') }
    it { is_expected.to contain_keystone_endpoint('RegionOne/muranoy::service_broker') }
  end
end
