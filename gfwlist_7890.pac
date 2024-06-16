/**
 * genpac 3.0rc1 https://github.com/JinnLynn/genpac
 * Generated: 2024-06-16 11:20:12
 * GFWList Last-Modified: -
 * GFWList From: -
 */

var proxy = 'SOCKS5 127.0.0.1:7890';
var rules = [
    [
        [],
        [],
        [],
        [
            "*ascii2d.net*",
            "*sourceforge.net*",
            "*files.pythonhosted.org*",
            "*repo.anaconda.com*",
            "*gitlab.com*",
            "*github.com*"
        ]
    ],
    [
        [],
        [],
        [],
        []
    ]
];

var lastRule = '';

function FindProxyForURL(url, host) {
    for (var i = 0; i < rules.length; i++) {
        var ret = testURL(url, i);
        if (ret !== undefined)
            return ret;
    }
    return 'DIRECT';
}

function testURL(url, index) {
    for (var i = 0; i < rules[index].length; i++) {
        for (var j = 0; j < rules[index][i].length; j++) {
            lastRule = rules[index][i][j];
            if ( (i % 2 == 0 && regExpMatch(url, lastRule))
                || (i % 2 != 0 && shExpMatch(url, lastRule)))
                return (i <= 1) ? 'DIRECT' : proxy;
        }
    }
    lastRule = '';
};

function regExpMatch(url, pattern) {
    try {
        return new RegExp(pattern).test(url);
    } catch(ex) {
        return false;
    }
};
