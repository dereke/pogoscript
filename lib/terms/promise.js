(function() {
    var self = this;
    module.exports = function(terms) {
        var self = this;
        return function() {
            return terms.moduleConstants.defineAs([ "Promise" ], terms.javascript('require("bluebird")'), {
                generated: false
            });
        };
    };
}).call(this);