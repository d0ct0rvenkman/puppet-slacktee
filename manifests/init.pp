# Class: slacktee
#
class slacktee (
    $default_username = "${::fqdn}",
    $webhook_uri,
    $upload_token = undef,
    $proxy = false,
    $proxy_url = undef,
){
    if $proxy == true {
      $webhook_url = "${proxy_url}/${webhook_uri}"
    } else {
      $webhook_url = "https://hooks.slack.com/${webhook_uri}"
    }

    case  "${::osfamily}-${::operatingsystemmajrelease}" {
        'RedHat-5': {
            $sourcefile = "slacktee.el5.sh"
        }
        default: {
            $sourcefile = "slacktee.sh"
        }
    }
    file { '/usr/local/bin/slacktee':
        ensure  => file,
        owner   => 'root',
        mode    => '0755',
        source  => "puppet:///modules/slacktee/${sourcefile}",
    }->
    file {
      '/usr/local/etc/slacktee':
      ensure  => 'directory',
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
    }->
    file {
      '/usr/local/etc/slacktee/.curlrc':
      ensure => file,
      owner  => 'root',
      mode   => '0644',
    }
    if $proxy == true {
      file_line {
        'Force insecure curl - slacktee':
        path => '/usr/local/etc/slacktee/.curlrc',
        line => 'insecure',
      }
    } else {
      file_line {
        'Disable insecure curl - slacktee':
        ensure => absent,
        path   => '/usr/local/etc/slacktee/.curlrc',
        line   => 'insecure',
      }
    }
    file {
      '/etc/slacktee.conf':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('slacktee/slacktee.conf.erb'),
    }
  }
