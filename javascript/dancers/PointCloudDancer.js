// Generated by CoffeeScript 1.8.0
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.PointCloudDancer = (function(_super) {
    __extends(PointCloudDancer, _super);

    PointCloudDancer.params = [
      {
        name: 'minDistance',
        "default": 5.0
      }, {
        name: 'maxDistance',
        "default": 10.0
      }, {
        name: 'count',
        "default": 500
      }
    ];

    PointCloudDancer.name = "PointCloudDancer";

    function PointCloudDancer(dance, danceMaterial, options) {
      var direction, geometry, i, material, position, positions, _i, _ref;
      this.dance = dance;
      this.danceMaterial = danceMaterial;
      if (options != null) {
        this.minDistance = options.minDistance, this.maxDistance = options.maxDistance, this.count = options.count;
      }
      if (this.minDistance == null) {
        this.minDistance = 5.0;
      }
      if (this.maxDistance == null) {
        this.maxDistance = 10.0;
      }
      if (this.count == null) {
        this.count = 500;
      }
      direction = new THREE.Vector3();
      position = new THREE.Vector3(0, 0, 0);
      geometry = new THREE.BufferGeometry();
      positions = new Float32Array(this.count * 3);
      for (i = _i = 0, _ref = this.count; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        direction.set(Math.random() - 0.5, Math.random() - 0.5, Math.random() - 0.5);
        direction.normalize();
        direction.multiplyScalar(this.minDistance + Math.random() * (this.maxDistance - this.minDistance));
        positions[3 * i] = position.x + direction.x;
        positions[3 * i + 1] = position.y + direction.y;
        positions[3 * i + 2] = position.z + direction.z;
      }
      geometry.addAttribute('position', new THREE.BufferAttribute(positions, 3));
      geometry.computeBoundingBox();
      material = new THREE.PointCloudMaterial({
        size: 0.5,
        color: this.danceMaterial.color
      });
      this.body = new THREE.PointCloud(geometry, material);
    }

    return PointCloudDancer;

  })(Dancer);

}).call(this);
