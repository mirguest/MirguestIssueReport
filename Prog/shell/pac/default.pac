// -*- javascript -*-
// This is a PAC (Proxy Auto-Config) file
// Refer: https://developer.mozilla.org/en-US/docs/Web/HTTP/Proxy_servers_and_tunneling/Proxy_Auto-Configuration_(PAC)_file

PROXY_DIRECT = "DIRECT";
PROXY_LAN = "SOCKS5 127.0.0.1:3839";
PROXY_WAN = "SOCKS5 127.0.0.1:48888";

PROXY_DEFAULT = PROXY_WAN;

// host_infos contains a list of host info:
// * name/description
// * proxy: (*)
// * url:
// * domain:
// * ip:
// * ipmask:


host_infos_all = [
    {
        name: "local",
        ip: "127.0.0.1",
        ipmask: "255.255.255.255",
        proxy: PROXY_DIRECT
    },
    {
        name: "byr",
        domain: "*.byr.cn",
        proxy: PROXY_DIRECT
    },
    {
        name: "neu",
        domain: "*.neu6.edu.cn",
        proxy: PROXY_DIRECT
    },
    {
        name: "ustc",
        domain: "*.ustc.edu.cn",
        proxy: PROXY_DIRECT
    },
    {
        name: "tsinghua",
        domain: "*.tsinghua.edu.cn",
        proxy: PROXY_DIRECT
    },
    {
        name: "ihep",
        domain: "*.ihep.ac.cn",
        proxy: PROXY_DIRECT
    },
    {
        name: "ihep-cas",
        domain: "*.ihep.cas.cn",
        proxy: PROXY_DIRECT
    },
    {
        name: "default",
        proxy: PROXY_DEFAULT
    }
];

// FORCE USING a dedicated proxy
host_infos_force = [
    {
        name: "default",
        proxy: PROXY_DEFAULT
    }
];

host_infos = host_infos_all; // or force

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
