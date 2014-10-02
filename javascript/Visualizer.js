// Generated by CoffeeScript 1.8.0
(function() {
  window.Visualizer = (function() {
    Visualizer.prototype.keys = {
      PAUSE: 32,
      SCALE_DANCE: 83,
      POSITION_DANCE: 68,
      CUBE_SHADER: 49,
      CUBE_COLOR: 50,
      SPHERE_SHADER: 51,
      SPHERE_COLOR: 52
    };

    function Visualizer(scene, camera) {
      var defaultDancer;
      this.scene = scene;
      this.dancers = new Array();
      this.shaderLoader = new ShaderLoader();
      window.AudioContext = window.AudioContext || window.webkitAudioContext;
      this.audioContext = new AudioContext();
      this.audioWindow = new AudioWindow(2048, 1);
      this.loadedAudio = new Array();
      this.analyser = this.audioContext.createAnalyser();
      this.analyser.fftSize = 2048;
      this.startOffset = 0;
      this.createLiveInput();
      defaultDancer = new CubeDancer(new PositionDance(0.2), new ColorDanceMaterial(0.1));
      this.dancers[0] = defaultDancer;
      this.scene.add(defaultDancer.body);
    }

    Visualizer.prototype.render = function() {
      var dancer, _i, _len, _ref, _results;
      if (!this.playing) {
        return;
      }
      this.audioWindow.update(this.analyser);
      _ref = this.dancers;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        dancer = _ref[_i];
        _results.push(dancer.update(this.audioWindow));
      }
      return _results;
    };

    Visualizer.prototype.pause = function() {
      this.source.stop();
      this.playing = false;
      return this.startOffset += this.audioContext.currentTime - this.startTime;
    };

    Visualizer.prototype.onKeyDown = function(event) {
      var dance, defaultDancer, simpleFreqShader;
      switch (event.keyCode) {
        case this.keys.PAUSE:
          if (this.playing) {
            return this.pause();
          } else {
            return this.play(this.currentlyPlaying);
          }
          break;
        case this.keys.SCALE_DANCE:
          this.dancers[0].dance.reset(this.dancers[0]);
          return this.dancers[0].dance = new ScaleDance(0.5);
        case this.keys.POSITION_DANCE:
          this.dancers[0].dance.reset(this.dancers[0]);
          return this.dancers[0].dance = new PositionDance(0.2);
        case this.keys.CUBE_COLOR:
          dance = this.removeLastDancer();
          defaultDancer = new CubeDancer(dance, new ColorDanceMaterial(0.1));
          this.dancers[0] = defaultDancer;
          return this.scene.add(defaultDancer.body);
        case this.keys.CUBE_SHADER:
          simpleFreqShader = new SimpleFrequencyShader(this.shaderLoader);
          return simpleFreqShader.loadShader(this.audioWindow, (function(_this) {
            return function(danceMaterial) {
              dance = _this.removeLastDancer();
              defaultDancer = new CubeDancer(dance, danceMaterial);
              _this.dancers[0] = defaultDancer;
              return _this.scene.add(defaultDancer.body);
            };
          })(this));
        case this.keys.SPHERE_COLOR:
          dance = this.removeLastDancer();
          defaultDancer = new SphereDancer(dance, new ColorDanceMaterial(0.1));
          this.dancers[0] = defaultDancer;
          return this.scene.add(defaultDancer.body);
        case this.keys.SPHERE_SHADER:
          simpleFreqShader = new SimpleFrequencyShader(this.shaderLoader);
          return simpleFreqShader.loadShader(this.audioWindow, (function(_this) {
            return function(danceMaterial) {
              dance = _this.removeLastDancer();
              defaultDancer = new SphereDancer(dance, danceMaterial);
              _this.dancers[0] = defaultDancer;
              return _this.scene.add(defaultDancer.body);
            };
          })(this));
      }
    };

    Visualizer.prototype.createLiveInput = function() {
      var gotStream;
      gotStream = (function(_this) {
        return function(stream) {
          _this.playing = true;
          _this.source = _this.audioContext.createMediaStreamSource(stream);
          return _this.source.connect(_this.analyser);
        };
      })(this);
      this.dbSampleBuf = new Uint8Array(2048);
      if (navigator.getUserMedia) {
        return navigator.getUserMedia({
          audio: true
        }, gotStream, function(err) {
          return console.log(err);
        });
      } else if (navigator.webkitGetUserMedia) {
        return navigator.webkitGetUserMedia({
          audio: true
        }, gotStream, function(err) {
          return console.log(err);
        });
      } else if (navigator.mozGetUserMedia) {
        return navigator.mozGetUserMedia({
          audio: true
        }, gotStream, function(err) {
          return console.log(err);
        });
      } else {
        return alert("Error: getUserMedia not supported!");
      }
    };

    Visualizer.prototype.play = function(url) {
      var request;
      this.currentlyPlaying = url;
      if (this.loadedAudio[url] != null) {
        this.loadFromBuffer(this.loadedAudio[url]);
        return;
      }
      request = new XMLHttpRequest();
      request.open("GET", url, true);
      request.responseType = 'arraybuffer';
      request.onload = (function(_this) {
        return function() {
          _this.audioContext.decodeAudioData(request.response, function(buffer) {
            _this.loadedAudio[url] = buffer;
            return _this.loadFromBuffer(buffer);
          }, function(err) {
            return console.log(err);
          });
        };
      })(this);
      request.send();
    };

    Visualizer.prototype.removeLastDancer = function() {
      var prevDancer;
      prevDancer = this.dancers.pop();
      this.scene.remove(prevDancer.body);
      return prevDancer.dance;
    };

    Visualizer.prototype.loadFromBuffer = function(buffer) {
      this.startTime = this.audioContext.currentTime;
      this.source = this.audioContext.createBufferSource();
      this.source.buffer = buffer;
      this.source.connect(this.analyser);
      this.source.connect(this.audioContext.destination);
      this.playing = true;
      return this.source.start(0, this.startOffset);
    };

    return Visualizer;

  })();

}).call(this);
