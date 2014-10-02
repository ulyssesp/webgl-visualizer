// Generated by CoffeeScript 1.8.0
(function() {
  window.SphereDancer = (function() {
    function SphereDancer(dance, danceMaterial) {
      var geometry, material;
      geometry = new THREE.SphereGeometry(1, 32, 24);
      material = danceMaterial.material;
      this.body = new THREE.Mesh(geometry, material);
      this.body.position = new THREE.Vector3(0, 0, 0);
      this.dance = dance;
      this.danceMaterial = danceMaterial;
    }

    SphereDancer.prototype.update = function(audioWindow) {
      this.dance.update(audioWindow, this);
      return this.danceMaterial.update(audioWindow, this);
    };

    return SphereDancer;

  })();

}).call(this);
