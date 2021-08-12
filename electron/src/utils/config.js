export default {
    reg:{
        phone: /^(?:(?:\+|00)86)?1[3-9]\d{9}$/,
        password: /^.{6,8}$/,
        username: /^[a-zA-Z0-9]{1,30}$/,
        code: /^[0-9]{4,6}/,
        url:  /^(https?|ftp):\/\/([a-zA-Z0-9.-]+(:[a-zA-Z0-9.&%$-]+)*@)*((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])){3}|([a-zA-Z0-9-]+\.)*[a-zA-Z0-9-]+\.(com|edu|gov|int|mil|net|org|biz|arpa|info|name|pro|aero|coop|museum|[a-zA-Z]{2}))(:[0-9]+)*(\/($|[a-zA-Z0-9.,?'\\+&%$#=~_-]+))*$/,
        lower: /^[a-z]+$/,
        upper: /^[A-Z]+$/,
        letter: /^[A-Za-z]+$/
    },
}
