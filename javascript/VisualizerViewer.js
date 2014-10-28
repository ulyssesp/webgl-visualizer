// Generated by CoffeeScript 1.8.0
(function() {
  require('./ShaderLoader.coffee');

  require('../javascript/Queue.js');

  window.VisualizerViewer = (function() {
    function VisualizerViewer(scene, camera) {
      this.scene = scene;
      this.dancers = new Array();
      this.shaderLoader = new ShaderLoader();
      this.choreographyQueue = new Queue();
    }

    VisualizerViewer.prototype.receiveChoreography = function(move) {
      return this.choreographyQueue.push(move);
    };

    VisualizerViewer.prototype.executeChoreography = function(_arg) {
      var addDancer, currentDancer, dance, danceMaterial, dancer, id, newDance, newMaterial, _i, _len, _ref;
      id = _arg.id, dancer = _arg.dancer, dance = _arg.dance, danceMaterial = _arg.danceMaterial;
      if (id === -1) {
        _ref = this.dancers;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          dancer = _ref[_i];
          this.scene.remove(dancer.body);
        }
        this.dancers = [];
        return;
      }
      if (this.dancers[id] != null) {
        currentDancer = this.dancers[id];
        if ((dancer == null) && !dance && !danceMaterial) {
          this.scene.remove(currentDancer.body);
          this.dancers.splice(this.dancers.indexOf(id), 1);
        }
        if (dance != null) {
          if ((dancer == null) && (danceMaterial == null)) {
            currentDancer.reset();
            currentDancer.dance = new Visualizer.danceTypes[dance.type](dance.params);
            return;
          } else {
            newDance = new Visualizer.danceTypes[dance.type](dance.params);
          }
        } else {
          newDance = currentDancer.dance;
        }
        addDancer = (function(_this) {
          return function(newDance, newMaterial) {
            var newDancer;
            if (dancer != null) {
              newDancer = new Visualizer.dancerTypes[dancer.type](newDance, newMaterial, dancer.params);
            } else {
              newDancer = new currentDancer.constructor(newDance, newMaterial);
            }
            currentDancer.reset();
            _this.scene.remove(currentDancer.body);
            _this.dancers[id] = newDancer;
            return _this.scene.add(newDancer.body);
          };
        })(this);
        if (danceMaterial != null) {
          if (danceMaterial.type.indexOf('Shader') > -1) {
            newMaterial = new Visualizer.danceMaterialTypes[danceMaterial.type](this.shaderLoader);
            newMaterial.loadShader(this.audioWindow, (function(_this) {
              return function(shaderMaterial) {
                return addDancer(newDance, shaderMaterial);
              };
            })(this));
            return;
          }
          newMaterial = new Visualizer.danceMaterialTypes[danceMaterial.type](danceMaterial.params);
        } else {
          newMaterial = currentDancer.danceMaterial;
        }
        addDancer(newDance, newMaterial);
      } else if (id != null) {
        this.dancers[id] = new Visualizer.dancerTypes[dancer.type](new Visualizer.danceTypes[dance.type](dance.params), new Visualizer.danceMaterialTypes[danceMaterial.type](danceMaterial.params), dancer.params);
        this.scene.add(this.dancers[id].body);
      } else {

      }
    };

    VisualizerViewer.prototype.getDancer = function(id) {
      return this.dancers[id];
    };

    VisualizerViewer.prototype.render = function(audioWindow) {
      var id, _i, _len, _ref, _results;
      while (this.choreographyQueue.length() > 0) {
        this.executeChoreography(this.choreographyQueue.shift());
      }
      _ref = Object.keys(this.dancers);
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        id = _ref[_i];
        _results.push(this.dancers[id].update(audioWindow));
      }
      return _results;
    };

    VisualizerViewer.prototype.removeLastDancer = function() {
      var prevDancer;
      prevDancer = this.dancers.pop();
      this.scene.remove(prevDancer.body);
      return prevDancer.dance;
    };

    return VisualizerViewer;

  })();

}).call(this);

//# sourceMappingURL=Viewer.js.map