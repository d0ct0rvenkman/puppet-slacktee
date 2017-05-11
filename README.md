# puppet-slacktee

Deploys the amazing and wonderful [slacktee](https://github.com/course-hero/slacktee) to servers managed by puppet

## Usage
* Clone the repo into your puppet modules directory.
* Include the module wherever it makes sense for you to include it. I typically use hiera for such things.
* Tweak the following settings to your environment:
  * `webhook_uri` (required) - The non-domain part of the slack webhook URL.
  * `default_username` - The default username from which slack messages come from. This can be overridden when slacktee is invoked at the command line. This defaults to the contents of the `fqdn` fact.
  * `default_channel` - The default channel where messages are sent. This can be overrideen when slacktee is invoked from the command line. This defaults to "#general".
  * `default_icon` - The default icon displayed for each message. This defaults to "robot_face", and can be overridden.
  * `upload_token` - Slack upload token for use with uploading files.
  * `proxy` - Boolean setting that dictates whether you want to submit slack messages to a custom proxy-pass URL. Useful for machines without direct external access. This defaults to `false`.
  * `proxy_url` - Protocol/domain name part for the proxy-pass URL.

## Examples
Basic use for inclusion with hiera
```yaml
---
classes:
    - slacktee

slacktee::webhook_uri: "services/AAAAAAAAA/BBBBBBBBB/CCCCCCCCCCCCCCCCCCCCCCCC"
slacktee::default_username: "Server Bot 9000"
slacktee::default_channel: "#server-noise"
```

Proxy use case
```yaml
---
classes:
    - slacktee

slacktee::proxy: true
slacktee::proxy_url: "https://slackproxy.mydomain.dom"
slacktee::webhook_uri: "services/AAAAAAAAA/BBBBBBBBB/CCCCCCCCCCCCCCCCCCCCCCCC"
slacktee::default_username: "Isolated Server Number 12"
slacktee::default_channel: "#lonely-servers-club"
slacktee::default_icon: "lonely_robot_face"

```

## Caveats / Notices
* This has only been tested on CentOS 5-7 and Raspbian Jessie.
* CentOS 5's version of curl does not support the `--data-urlencode` flag, so only `--data` is used. It may get ugly if your message contains character sequences that would be escaped by `--data-urlencode`.
* When using the proxy option, the `slacktee` class sets an alternate config file for curl that disables certificate validation. Future revisions may make this a configurable setting.
