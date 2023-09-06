// -*- javascript -*-
// This is a PAC (Proxy Auto-Config) file
// - Refer to: https://developer.mozilla.org/en-US/docs/Web/HTTP/Proxy_servers_and_tunneling/Proxy_Auto-Configuration_(PAC)_file
// - GitHub: https://github.com/mirguest/MirguestIssueReport/blob/master/coding/shell/pac/default.pac
// - Edit: https://github.com/mirguest/MirguestIssueReport/edit/master/coding/shell/pac/default.pac
// - Raw:
//   - https://raw.githubusercontent.com/mirguest/MirguestIssueReport/master/coding/shell/pac/default.pac
//   - https://bitbucket.org/lintao/mirguestissuereport/raw/master/coding/shell/pac/default.pac

PROXY_DIRECT = "DIRECT";
PROXY_LAN = "SOCKS5 127.0.0.1:3839";
PROXY_WAN = "SOCKS5 127.0.0.1:48888";
PROXY_WAN_ = "PROXY 127.0.0.1:57890";


PROXY_DEFAULT = PROXY_WAN_;

// host_infos contains a list of host info:
// * name/description
// * proxy: (*)
// * url:
// * domain:
// * ip:
// * ipmask:


host_infos_all = [
    // * ## Local host
    {
        name: "local",
        ip: "127.0.0.1",
        ipmask: "255.255.255.255",
        proxy: PROXY_DIRECT
    },
    // * ## Some IPv6 mirrors should be accessed directly
    {
        name: "pt",
        domain: "*.pt",
        proxy: PROXY_DIRECT
    },
    {
        name: "edu",
        domain: "*.edu.cn",
        proxy: PROXY_DIRECT
    },
    {
        name: "ac",
        domain: "*.ac.cn",
        proxy: PROXY_DIRECT
    },
    {
        name: "cas",
        domain: "*.cas.cn",
        proxy: PROXY_DIRECT
    },
    {
        name: "cas-cst",
        domain: "*.cstnet.cn",
        proxy: PROXY_DIRECT
    },
    // * QQ
    {
        name: "qq",
        domain: "*.qq.com",
        proxy: PROXY_DIRECT
    },
    {
        name: "weiyun",
        domain: "*.weiyun.com",
        proxy: PROXY_DIRECT
    },
    // * ## Default
    {
        name: "default",
        proxy: PROXY_DEFAULT
    }
];

host_infos = host_infos_all;

function FindProxyForURL (url, host) {

    for (idx in host_infos) {
        host_info = host_infos[idx];
        if (host_info.url) {
            if (url.indexOf(host_info.url)>-1) {
                return host_info.proxy;
            }
        }
        if (host_info.domain) {
            if (shExpMatch(host, host_info.domain)) {
                return host_info.proxy;
            }
        }
        if (host_info.ip && host_info.ipmask) {
            if (isInNet(host, host_info.ip, host_info.ipmask)) {
                return host_info.proxy;
            }
        }
    }
  
    return PROXY_DEFAULT;
}
