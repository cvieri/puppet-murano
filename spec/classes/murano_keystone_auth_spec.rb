require 'spec_helper'

describe 'murano::keystone::auth' do

  let :facts do
    { :osfamily => 'Debian' }
  end

  describe 'with default class parameters' do
    let :params do
      { :password => 'murano_password',
        :tenant   => 'foobar' }
    end

    it { is_expected.to contain_keystone_user('murano').with(
                            :ensure   => 'present',
                            :password => 'murano_password',
                        ) }

    it { is_expected.to contain_keystone_user_role('murano@foobar').with(
                            :ensure  => 'present',
                            :roles   => ['admin']
                        )}

    it { is_expected.to contain_keystone_service('murano').with(
                            :ensure      => 'present',
                            :type        => 'application_catalog',
                            :description => 'Murano Application Catalog'
                        ) }

    it { is_expected.to contain_keystone_endpoint('RegionOne/murano').with(
                            :ensure       => 'present',
                            :public_url   => "http://127.0.0.1:8082",
                            :admin_url    => "http://127.0.0.1:8082",
                            :internal_url => "http://127.0.0.1:8082"
                        ) }
  end

  describe 'with endpoint parameters' do
    let :params do
      { :password     => 'murano_password',
        :public_url   => 'https://10.10.10.10:80',
        :internal_url => 'http://10.10.10.11:81',
        :admin_url    => 'http://10.10.10.12:81' }
    end

    it { is_expected.to contain_keystone_endpoint('RegionOne/murano').with(
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

    it { is_expected.to contain_keystone_user('muranoy') }
    it { is_expected.to contain_keystone_user_role('muranoy@services') }
    it { is_expected.to contain_keystone_service('muranoy') }
    it { is_expected.to contain_keystone_endpoint('RegionOne/muranoy') }
  end
end
