#
# Unit tests for murano::init
#
require 'spec_helper'

describe 'murano' do

  let :params do {
    :admin_password => 'secrete',
    :purge_config   => false,
  }
  end

  shared_examples_for 'with default parameters' do
    it { is_expected.to contain_class('murano::params') }
    it { is_expected.to contain_class('murano::policy') }
    it { is_expected.to contain_class('murano::db') }

    it { is_expected.to contain_package('murano-common').with({
      :ensure => 'present'
    }) }

    it 'passes purge to resource' do
      is_expected.to contain_resources('murano_config').with({
        :purge => false
      })
    end

    it { is_expected.to contain_class('mysql::bindings::python') }

    it { is_expected.to contain_murano_config('oslo_messaging_notifications/driver').with_value('messagingv2') }

    it { is_expected.to contain_murano_config('murano/url').with_value('http://127.0.0.1:8082') }

    it { is_expected.to contain_murano_config('engine/use_trusts').with_value('<SERVICE DEFAULT>') }

    it { is_expected.to contain_murano_config('DEFAULT/transport_url').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_murano_config('oslo_messaging_rabbit/rabbit_userid').with_value('guest') }
    it { is_expected.to contain_murano_config('oslo_messaging_rabbit/rabbit_password').with_value('guest') }
    it { is_expected.to contain_murano_config('oslo_messaging_rabbit/rabbit_hosts').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_murano_config('oslo_messaging_rabbit/rabbit_host').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_murano_config('oslo_messaging_rabbit/rabbit_port').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_murano_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_murano_config('oslo_messaging_rabbit/rabbit_use_ssl').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_murano_config('oslo_messaging_rabbit/rabbit_virtual_host').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_murano_config('oslo_messaging_rabbit/kombu_reconnect_delay').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_murano_config('oslo_messaging_rabbit/kombu_failover_strategy').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_murano_config('oslo_messaging_rabbit/kombu_compression').with_value('<SERVICE DEFAULT>') }

    it { is_expected.to contain_murano_config('rabbitmq/login').with_value('guest') }
    it { is_expected.to contain_murano_config('rabbitmq/password').with_value('guest') }
    it { is_expected.to contain_murano_config('rabbitmq/host').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_murano_config('rabbitmq/port').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_murano_config('rabbitmq/virtual_host').with_value('murano') }
    it { is_expected.to contain_murano_config('rabbitmq/ssl').with_value('<SERVICE DEFAULT>') }

    it { is_expected.to contain_murano_config('networking/default_dns').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_murano_config('networking/driver').with_value('nova') }

    it { is_expected.to contain_murano_config('keystone_authtoken/auth_uri').with_value('http://127.0.0.1:5000') }
    it { is_expected.to contain_murano_config('keystone_authtoken/admin_user').with_value('murano') }
    it { is_expected.to contain_murano_config('keystone_authtoken/admin_tenant_name').with_value('services') }
    it { is_expected.to contain_murano_config('keystone_authtoken/signing_dir').with_value('/tmp/keystone-signing-muranoapi') }
    it { is_expected.to contain_murano_config('keystone_authtoken/admin_password').with_value('secrete') }
    it { is_expected.not_to contain_murano_config('keystone_authtoken/identity_uri').with_value('http://10.255.0.1:35357/') }
    it { is_expected.to contain_murano_config('keystone_authtoken/memcached_servers').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_murano_config('engine/packages_service').with_value('<SERVICE DEFAULT>') }

    it { is_expected.to contain_exec('murano-dbmanage') }

  end

  shared_examples_for 'with parameters override' do
    let :params do {
      :admin_password          => 'secrete',
      :package_ensure          => 'latest',
      :notification_driver     => 'messagingv1',
      :default_transport_url   => 'rabbit://user:pass@host:1234/virt',
      :rabbit_os_host          => '10.255.0.1',
      :rabbit_os_port          => '5673',
      :rabbit_os_user          => 'os',
      :rabbit_os_password      => 'ossecrete',
      :rabbit_ha_queues        => true,
      :rabbit_os_use_ssl       => true,
      :rabbit_own_host         => '10.255.0.2',
      :rabbit_own_port         => '5674',
      :rabbit_own_user         => 'murano',
      :rabbit_own_password     => 'secrete',
      :rabbit_own_vhost        => 'murano_vhost',
      :rabbit_own_use_ssl      => true,
      :service_host            => '10.255.0.3',
      :service_port            => '8088',
      :packages_service        => 'glare',
      :use_ssl                 => true,
      :cert_file               => '/etc/murano/murano.crt',
      :key_file                => '/etc/murano/murano.key',
      :ca_file                 => '/etc/murano/ca.crt',
      :use_neutron             => true,
      :external_network        => 'murano-net',
      :default_router          => 'murano-router',
      :default_nameservers     => '["8.8.8.8"]',
      :use_trusts              => true,
      :sync_db                 => false,
      :admin_user              => 'muranoy',
      :admin_tenant_name       => 'secrete',
      :auth_uri                => 'http://10.255.0.1:5000/v2.0/',
      :identity_uri            => 'http://10.255.0.1:35357/',
      :signing_dir             => '/tmp/keystone-muranoapi',
      :kombu_reconnect_delay   => '1.0',
      :kombu_failover_strategy => 'round-robin',
      :kombu_compression       => 'gzip',
      :memcached_servers       => '1.1.1.1:11211',
    }
    end

    it { is_expected.to contain_class('murano::params') }
    it { is_expected.to contain_class('murano::policy') }
    it { is_expected.to contain_class('murano::db') }

    it { is_expected.to contain_package('murano-common').with({
      :ensure => 'latest'
    }) }

    it { is_expected.to contain_class('mysql::bindings::python') }

    it { is_expected.to contain_murano_config('oslo_messaging_notifications/driver').with_value('messagingv1') }

    it { is_expected.to contain_murano_config('murano/url').with_value('https://10.255.0.3:8088') }

    it { is_expected.to contain_murano_config('engine/use_trusts').with_value(true) }

    it { is_expected.to contain_murano_config('DEFAULT/transport_url').with_value('rabbit://user:pass@host:1234/virt') }
    it { is_expected.to contain_murano_config('oslo_messaging_rabbit/rabbit_userid').with_value('os') }
    it { is_expected.to contain_murano_config('oslo_messaging_rabbit/rabbit_password').with_value('ossecrete') }
    it { is_expected.to contain_murano_config('oslo_messaging_rabbit/rabbit_host').with_value('10.255.0.1') }
    it { is_expected.to contain_murano_config('oslo_messaging_rabbit/rabbit_port').with_value('5673') }
    it { is_expected.to contain_murano_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value(true) }
    it { is_expected.to contain_murano_config('oslo_messaging_rabbit/rabbit_use_ssl').with_value(true) }

    it { is_expected.to contain_murano_config('oslo_messaging_rabbit/kombu_reconnect_delay').with_value('1.0') }
    it { is_expected.to contain_murano_config('oslo_messaging_rabbit/kombu_failover_strategy').with_value('round-robin') }
    it { is_expected.to contain_murano_config('oslo_messaging_rabbit/kombu_compression').with_value('gzip') }

    it { is_expected.to contain_murano_config('rabbitmq/login').with_value('murano') }
    it { is_expected.to contain_murano_config('rabbitmq/password').with_value('secrete') }
    it { is_expected.to contain_murano_config('rabbitmq/host').with_value('10.255.0.2') }
    it { is_expected.to contain_murano_config('rabbitmq/port').with_value('5674') }
    it { is_expected.to contain_murano_config('rabbitmq/virtual_host').with_value('murano_vhost') }
    it { is_expected.to contain_murano_config('rabbitmq/ssl').with_value(true) }

    it { is_expected.to contain_murano_config('keystone_authtoken/auth_uri').with_value('http://10.255.0.1:5000/v2.0/') }
    it { is_expected.to contain_murano_config('keystone_authtoken/admin_user').with_value('muranoy') }
    it { is_expected.to contain_murano_config('keystone_authtoken/admin_tenant_name').with_value('secrete') }
    it { is_expected.to contain_murano_config('keystone_authtoken/signing_dir').with_value('/tmp/keystone-muranoapi') }
    it { is_expected.to contain_murano_config('keystone_authtoken/identity_uri').with_value('http://10.255.0.1:35357/') }
    it { is_expected.to contain_murano_config('keystone_authtoken/admin_password').with_value('secrete') }
    it { is_expected.to contain_murano_config('keystone_authtoken/memcached_servers').with_value('1.1.1.1:11211') }

    it { is_expected.to contain_murano_config('networking/external_network').with_value('murano-net') }
    it { is_expected.to contain_murano_config('networking/router_name').with_value('murano-router') }
    it { is_expected.to contain_murano_config('networking/create_router').with_value(true) }
    it { is_expected.to contain_murano_config('networking/default_dns').with_value('["8.8.8.8"]') }
    it { is_expected.to contain_murano_config('networking/driver').with_value('neutron') }

    it { is_expected.to contain_murano_config('ssl/cert_file').with_value('/etc/murano/murano.crt') }
    it { is_expected.to contain_murano_config('ssl/key_file').with_value('/etc/murano/murano.key') }
    it { is_expected.to contain_murano_config('ssl/ca_file').with_value('/etc/murano/ca.crt') }

    it { is_expected.to contain_murano_config('engine/packages_service').with_value('glare') }

    it { is_expected.to_not contain_exec('murano-dbmanage') }

  end

  context 'on Debian platforms' do
    let :facts do
      @default_facts.merge({
        :osfamily => 'Debian',
        :operatingsystem => 'Debian'
      })
    end

    it_configures 'with default parameters'
    it_configures 'with parameters override'
  end

  context 'on RedHat platforms' do
    let :facts do
      @default_facts.merge({ :osfamily => 'RedHat' })
    end

    it_configures 'with default parameters'
    it_configures 'with parameters override'
  end
end
