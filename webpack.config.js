module.exports = {
    entry: './N3.js/src/index.js',
    output: {
        filename: 'n3.js',
        globalObject: 'this',
        library: {
            type: 'umd',
            name: 'N3.js',
        },
    },
    mode: 'production',
    // target is web by default
};
