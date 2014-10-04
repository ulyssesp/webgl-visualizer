class window.Visualizer
  # Get those keys set up
  keys: { PAUSE: 32, SCALE_DANCE: 83, POSITION_DANCE: 68, CUBE_SHADER: 49, CUBE_COLOR: 50, SPHERE_SHADER: 51, SPHERE_COLOR: 52 }

  # Set up the scene based on a Main object which contains the scene.
  constructor: (scene, camera) ->
    @scene = scene
    @dancers = new Array()
    @shaderLoader = new ShaderLoader()


    # Create the audio context
    window.AudioContext = window.AudioContext || window.webkitAudioContext
    @audioContext = new AudioContext()
    @audioWindow = new AudioWindow(2048, 1);
    @loadedAudio = new Array()
    @analyser = @audioContext.createAnalyser()
    @analyser.fftSize = 2048
    @startOffset = 0

    # Load the sample audio
    @play('audio/Go.mp3')

    # @createLiveInput()

    # simpleFreqShader = new SimpleFrequencyShader(@shaderLoader)
    # simpleFreqShader.loadShader @audioWindow, (danceMaterial) =>
    #   defaultDancer = new CubeDancer(new PositionDance(0.2), danceMaterial)
    #   @dancers.push(defaultDancer)
    #   @scene.add(defaultDancer.body)
    
    defaultDancer = new CubeDancer(new PositionDance(0.2, new THREE.Vector3(0, 4.0, 0)), new ColorDanceMaterial(0.1))
    @dancers.push(defaultDancer)
    @scene.add(defaultDancer.body)

  # Render the scene by going through the AudioObject array and calling update(audioEvent) on each one
  render: () ->
    if !@playing
      return
    
    @audioWindow.update(@analyser)
    # Create event
    for dancer in @dancers
      dancer.update(@audioWindow)

  pause: () ->
    @source.stop()
    @playing = false
    @startOffset += @audioContext.currentTime - @startTime

  #Event methods
  onKeyDown: (event) ->
    switch event.keyCode
      when @keys.PAUSE
        if @playing then @pause() else @play(@currentlyPlaying)

      when @keys.SCALE_DANCE
        @receiveChoreography(0, { type: SphereDancer }, { type: ScaleDance, params: 0.5 }, { type: ColorDanceMaterial, params: 0.5 })
      when @keys.POSITION_DANCE
        @dancers[0].dance.reset(@dancers[0])
        @dancers[0].dance = new PositionDance(0.2, new THREE.Vector3(0, 2.0, 0))

      when @keys.CUBE_COLOR
        dance = @removeLastDancer()
        defaultDancer = new CubeDancer(dance, new ColorDanceMaterial(0.1))
        @dancers[0] = defaultDancer
        @scene.add(defaultDancer.body)

      when @keys.CUBE_SHADER
        simpleFreqShader = new SimpleFrequencyShader(@shaderLoader)
        simpleFreqShader.loadShader @audioWindow, (danceMaterial) =>
          dance = @removeLastDancer()
          defaultDancer = new CubeDancer(dance, danceMaterial)
          @dancers[0] = defaultDancer
          @scene.add(defaultDancer.body)

      when @keys.SPHERE_COLOR
        dance = @removeLastDancer()
        defaultDancer = new SphereDancer(dance, new ColorDanceMaterial(0.1))
        @dancers[0] = defaultDancer
        @scene.add(defaultDancer.body)

      when @keys.SPHERE_SHADER
        simpleFreqShader = new SimpleFrequencyShader(@shaderLoader)
        simpleFreqShader.loadShader @audioWindow, (danceMaterial) =>
          dance = @removeLastDancer()
          defaultDancer = new SphereDancer(dance, danceMaterial)
          @dancers[0] = defaultDancer
          @scene.add(defaultDancer.body)

  receiveChoreography: (id, dancer, dance, danceMaterial) ->
    if @dancers[id]?
      @scene.remove @dancers[id].body

    @dancers[id] = new dancer.type(new dance.type(dance.params), new danceMaterial.type(danceMaterial.params), dancer.params)
    @scene.add @dancers[id].body



  # Utility methods

  createLiveInput: () ->
    gotStream = (stream) =>
      @playing = true  
      @source = @audioContext.createMediaStreamSource stream
      @source.connect @analyser

    @dbSampleBuf = new Uint8Array(2048)

    if ( navigator.getUserMedia )
        navigator.getUserMedia({audio:true}, gotStream, (err) -> console.log(err) )
    else if (navigator.webkitGetUserMedia )
        navigator.webkitGetUserMedia({audio:true}, gotStream, (err) -> console.log(err) )
    else if (navigator.mozGetUserMedia )
        navigator.mozGetUserMedia({audio:true}, gotStream, (err) -> console.log(err) )
    else
        return(alert("Error: getUserMedia not supported!"));

  play: (url) ->
    @currentlyPlaying = url

    if @loadedAudio[url]?
      @loadFromBuffer(@loadedAudio[url])
      return

    request = new XMLHttpRequest()
    request.open("GET", url, true)
    request.responseType = 'arraybuffer'
    request.onload = () => 
      @audioContext.decodeAudioData request.response
          , (buffer) =>
            @loadedAudio[url] = buffer
            @loadFromBuffer(buffer)
          , (err) -> console.log(err)
      return

    request.send()
    return

  # Removes the last dancer, returns the dancer's dance
  removeLastDancer: () ->
    prevDancer = @dancers.pop()
    @scene.remove(prevDancer.body) 
    return prevDancer.dance

  
  loadFromBuffer: (buffer) ->
    @startTime = @audioContext.currentTime
    @source = @audioContext.createBufferSource()
    @source.buffer = buffer
    @source.connect(@analyser)
    @source.connect(@audioContext.destination)
    @playing = true
    @source.start(0, @startOffset)