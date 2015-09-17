#
# Unit tests for murano::init
#
require 'spec_helper'

describe 'murano' do

  let :params do {
    :admin_password => 'secrete',
  }
  end

  shared_examples_for 'with default parameters' do
    it { is_expected.to contain_class('murano::params') }
    it { is_expected.to contain_class('murano::policy') }
    it { is_expected.to contain_class('murano::db') }

    it { is_expected.to contain_package('murano-common').with({
      :ensure => 'present'
    }) }

    it { is_expected.to contain_class('mysql::bindings::python') }

    it { is_expected.to contain_murano_config('DEFAULT/use_syslog').with_value(false) }

    it { is_expected.to contain_murano_config('DEFAULT/verbose').with_value(false) }
    it { is_expected.to contain_murano_config('DEFAULT/debug').with_value(false) }
    it { is_expected.to contain_murano_config('DEFAULT/log_dir').with_value('/var/log/murano') }
    it { is_expected.to contain_murano_config('DEFAULT/notification_driver').with_value('messagingv2') }

    it { is_expected.to contain_murano_config('murano/url').with_value('http://127.0.0.1:8082') }

    it { is_expected.to contain_murano_config('engine/use_trusts').with_value(false) }

    it { is_expected.to contain_murano_config('database/connection').with_value('mysql://murano:secrete@localhost:3306/murano') }
    it { is_expected.to contain_murano_config('database/idle_timeout').with_value('3600') }
    it { is_expected.to contain_murano_config('database/min_pool_size').with_value('1') }
    it { is_expected.to contain_murano_config('database/max_retries').with_value('10') }
    it { is_expected.to contain_murano_config('database/retry_interval').with_value('10') }
    it { is_expected.to contain_murano_config('database/max_pool_size').with_value('10') }
    it { is_expected.to contain_murano_config('database/max_overflow').with_value('20') }

    it { is_expected.to contain_murano_config('oslo_messaging_rabbit/rabbit_userid').with_value('guest') }
    it { is_expected.to contain_murano_config('oslo_messaging_rabbit/rabbit_password').with_value('guest') }
    it { is_expected.to contain_murano_config('oslo_messaging_rabbit/rabbit_hosts').with_value('127.0.0.1') }
    it { is_expected.to contain_murano_config('oslo_messaging_rabbit/rabbit_port').with_value('5672') }
    it { is_expected.to contain_murano_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value(false) }

    it { is_expected.to contain_murano_config('rabbitmq/login').with_value('guest') }
    it { is_expected.to contain_murano_config('rabbitmq/password').with_value('guest') }
    it { is_expected.to contain_murano_config('rabbitmq/host').with_value('127.0.0.1') }
    it { is_expected.to contain_murano_config('rabbitmq/port').with_value('5672') }
    it { is_expected.to contain_murano_config('rabbitmq/virtual_host').with_value('murano') }

    it { is_expected.to contain_murano_config('networking/default_dns').with_value('[]') }

    it { is_expected.to contain_murano_config('keystone_authtoken/auth_uri').with_value('http://127.0.0.1:5000/v2.0/') }
    it { is_expected.to contain_murano_config('keystone_authtoken/admin_user').with_value('admin') }
    it { is_expected.to contain_murano_config('keystone_authtoken/admin_tenant_name').with_value('admin') }
    it { is_expected.to contain_murano_config('keystone_authtoken/signing_dir').with_value('/tmp/keystone-signing-muranoapi') }
    it { is_expected.to contain_murano_config('keystone_authtoken/identity_uri').with_value('http://127.0.0.1:35357/') }
    it { is_expected.to contain_murano_config('keystone_authtoken/admin_password').with_value('secrete') }

    it { is_expected.to contain_exec('murano-dbmanage') }

  end

  shared_examples_for 'with parameters override' do
    let :params do {
      :admin_password          => 'secrete',
      :package_ensure          => 'latest',
      :verbose                 => true,
      :debug                   => true,
      :use_syslog              => true,
      :log_facility            => 'LOG_USER',
      :log_dir                 => '/var/log/murano_logs',
      :data_dir                => '/tmp/murano_data',
      :notification_driver     => 'messagingv1',
      :rabbit_os_host          => '10.255.0.1',
      :rabbit_os_port          => '5673',
      :rabbit_os_user          => 'os',
      :rabbit_os_password      => 'ossecrete',
      :rabbit_ha_queues        => true,
      :rabbit_own_host         => '10.255.0.2',
      :rabbit_own_port         => '5674',
      :rabbit_own_user         => 'murano',
      :rabbit_own_password     => 'secrete',
      :rabbit_own_vhost        => 'murano_vhost',
      :service_host            => '10.255.0.3',
      :service_port            => '8088',
      :use_ssl                 => true,
      :cert_file               => '/etc/murano/murano.crt',
      :key_file                => '/etc/murano/murano.key',
      :ca_file                 => '/etc/murano/ca.crt',
      :use_neutron             => true,
      :external_network        => 'murano-net',
      :default_router          => 'murano-router',
      :default_nameservers     => '["8.8.8.8"]',
      :use_trusts              => true,
      :database_connection     => 'mysql://murano:murano@localhost/murano',
      :database_idle_timeout   => '3601',
      :database_min_pool_size  => '2',
      :database_max_retries    => '11',
      :database_retry_interval => '11',
      :database_max_pool_size  => '11',
      :database_max_overflow   => '21',
      :sync_db                 => false,
      :admin_user              => 'murano',
      :admin_tenant_name       => 'secrete',
      :auth_uri                => 'http://10.255.0.1:5000/v2.0/',
      :identity_uri            => 'http://10.255.0.1:35357/',
      :signing_dir             => '/tmp/keystone-muranoapi',
    }
    end

    it { is_expected.to contain_class('murano::params') }
    it { is_expected.to contain_class('murano::policy') }
    it { is_expected.to contain_class('murano::db') }

    it { is_expected.to contain_package('murano-common').with({
      :ensure => 'latest'
    }) }

    it { is_expected.to contain_class('mysql::bindings::python') }

    it { is_expected.to contain_murano_config('DEFAULT/use_syslog').with_value(true) }

    it { is_expected.to contain_murano_config('DEFAULT/use_syslog_rfc_format').with_value(true) }
    it { is_expected.to contain_murano_config('DEFAULT/syslog_log_facility').with_value('LOG_USER') }

    it { is_expected.to contain_murano_config('DEFAULT/verbose').with_value(true) }
    it { is_expected.to contain_murano_config('DEFAULT/debug').with_value(true) }
    it { is_expected.to contain_murano_config('DEFAULT/log_dir').with_value('/var/log/murano_logs') }
    it { is_expected.to contain_murano_config('DEFAULT/notification_driver').with_value('messagingv1') }

    it { is_expected.to contain_murano_config('murano/url').with_value('https://10.255.0.3:8088') }

    it { is_expected.to contain_murano_config('engine/use_trusts').with_value(true) }

    it { is_expected.to contain_murano_config('database/connection').with_value('mysql://murano:murano@localhost/murano') }
    it { is_expected.to contain_murano_config('database/idle_timeout').with_value('3601') }
    it { is_expected.to contain_murano_config('database/min_pool_size').with_value('2') }
    it { is_expected.to contain_murano_config('database/max_retries').with_value('11') }
    it { is_expected.to contain_murano_config('database/retry_interval').with_value('11') }
    it { is_expected.to contain_murano_config('database/max_pool_size').with_value('11') }
    it { is_expected.to contain_murano_config('database/max_overflow').with_value('21') }

    it { is_expected.to contain_murano_config('oslo_messaging_rabbit/rabbit_userid').with_value('os') }
    it { is_expected.to contain_murano_config('oslo_messaging_rabbit/rabbit_password').with_value('ossecrete') }
    it { is_expected.to contain_murano_config('oslo_messaging_rabbit/rabbit_hosts').with_value('10.255.0.1') }
    it { is_expected.to contain_murano_config('oslo_messaging_rabbit/rabbit_port').with_value('5673') }
    it { is_expected.to contain_murano_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value(true) }

    it { is_expected.to contain_murano_config('rabbitmq/login').with_value('murano') }
    it { is_expected.to contain_murano_config('rabbitmq/password').with_value('secrete') }
    it { is_expected.to contain_murano_config('rabbitmq/host').with_value('10.255.0.2') }
    it { is_expected.to contain_murano_config('rabbitmq/port').with_value('5674') }
    it { is_expected.to contain_murano_config('rabbitmq/virtual_host').with_value('murano_vhost') }

    it { is_expected.to contain_murano_config('keystone_authtoken/auth_uri').with_value('http://10.255.0.1:5000/v2.0/') }
    it { is_expected.to contain_murano_config('keystone_authtoken/admin_user').with_value('murano') }
    it { is_expected.to contain_murano_config('keystone_authtoken/admin_tenant_name').with_value('secrete') }
    it { is_expected.to contain_murano_config('keystone_authtoken/signing_dir').with_value('/tmp/keystone-muranoapi') }
    it { is_expected.to contain_murano_config('keystone_authtoken/identity_uri').with_value('http://10.255.0.1:35357/') }
    it { is_expected.to contain_murano_config('keystone_authtoken/admin_password').with_value('secrete') }

    it { is_expected.to contain_murano_config('networking/external_network').with_value('murano-net') }
    it { is_expected.to contain_murano_config('networking/router_name').with_value('murano-router') }
    it { is_expected.to contain_murano_config('networking/create_router').with_value(true) }
    it { is_expected.to contain_murano_config('networking/default_dns').with_value('["8.8.8.8"]') }

    it { is_expected.to contain_murano_config('ssl/cert_file').with_value('/etc/murano/murano.crt') }
    it { is_expected.to contain_murano_config('ssl/key_file').with_value('/etc/murano/murano.key') }
    it { is_expected.to contain_murano_config('ssl/ca_file').with_value('/etc/murano/ca.crt') }


    it { is_expected.to_not contain_exec('murano-dbmanage') }

  end

  context 'on Debian platforms' do
    let :facts do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Debian'
      }
    end

    it_configures 'with default parameters'
    it_configures 'with parameters override'
  end

  context 'on RedHat platforms' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    it_configures 'with default parameters'
    it_configures 'with parameters override'
  end
end
