

var Adder = function(){};


Adder.prototype.add = function(a, b) {
  return (a + b);
};

Adder.prototype.subtract = function(a, b) {
  return (a - b);
};


module.exports = Adder;
