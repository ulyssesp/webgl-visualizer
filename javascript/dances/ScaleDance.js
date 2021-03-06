// Generated by CoffeeScript 1.8.0
(function () {
    window.ScaleDance = (function () {
        ScaleDance.params = [
            {
                name: 'smoothingFactor',
                "default": 0.5
            },
            {
                name: 'min',
                "default": [0.5, 0.5, 0.5]
            },
            {
                name: 'max',
                "default": [1, 1, 1]
            }
        ];

        ScaleDance.name = "ScaleDance";

        function ScaleDance(options) {
            var max, min, _ref;
            this.options = options;
            if (this.options != null) {
                _ref = this.options, this.smoothingFactor = _ref.smoothingFactor, min = _ref.min, max = _ref.max;
            }
            if (this.smoothingFactor == null) {
                this.smoothingFactor = 0.5;
            }
            this.averageDb = 0;
            this.min = min ? new THREE.Vector3(min[0], min[1], min[2]) : new THREE.Vector3(0.5, 0.5, 0.5);
            this.max = max ? new THREE.Vector3(max[0], max[1], max[2]) : new THREE.Vector3(1, 1, 1);
            this.scale = new THREE.Vector3();
        }

        ScaleDance.prototype.update = function (audioWindow, dancer) {
            var smoothingFactor;
            if (audioWindow.averageDb < this.averageDb) {
                this.averageDb = audioWindow.averageDb * this.smoothingFactor + (1 - this.smoothingFactor) * this.averageDb;
            } else {
                smoothingFactor = Math.max(1, this.smoothingFactor * 4);
                this.averageDb = audioWindow.averageDb * smoothingFactor + (1 - smoothingFactor) * this.averageDb;
            }
            this.scale.copy(this.min);
            this.scale.lerp(this.max, this.averageDb);
            return dancer.body.scale.set(this.scale.x, this.scale.y, this.scale.z);
        };

        ScaleDance.prototype.reset = function (dancer) {
            return dancer.body.scale.set(1, 1, 1);
        };

        return ScaleDance;

    })();

}).call(this);
