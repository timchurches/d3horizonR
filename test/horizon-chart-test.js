var tape = require("tape"),
    hc = require("../");

tape("horizonChart() has a default height.", function(test) {
  test.equal(hc.horizonChart().height(), 30);
  test.end();
});
