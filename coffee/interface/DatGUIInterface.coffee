require './QueueView.coffee'
require './RoutinesView.coffee'
require './AudioView.coffee'
require '../RoutinesController.coffee'

class window.DatGUIInterface
  constructor: (@routinesController) ->
    @container = $('#interface')

  setup: (@player, @choreographyRoutine, @viewer, @onUrl) ->
    gui = new dat.GUI()

    gui.add(@player.audioWindow, 'responsiveness', 0.0, 5.0)
    idController = gui.add(@choreographyRoutine, 'id')

    setupFolder = (name, varName, keys) =>
      controller = gui.add(@choreographyRoutine, varName, keys)
      folder = gui.addFolder(name)
      folder.open()
      return [ controller, folder ]

    updateFolder = (types, folder, params, value, obj) ->
      if !types[value]?
        return

      while folder.__controllers[0]?
        folder.remove(folder.__controllers[0])

      for param in types[value].params
        params[param.name] =
          if obj?.options?[param.name]
            obj.options[param.name]
          else
            param.default

        folder.add(params, param.name, param.selectionValues)

    [dancerController, dancerFolder] = setupFolder('Dancer parameters', 'dancer', Object.keys(Visualizer.dancerTypes))

    # These have obj for our own use. The even callback only uses value
    updateDancerFolder = (value, obj) =>
      updateFolder(Visualizer.dancerTypes, dancerFolder, @choreographyRoutine.dancerParams, value, obj)
    dancerController.onChange updateDancerFolder
    updateDancerFolder dancerController.initialValue

    [danceController, danceFolder] = setupFolder('Dance parameters', 'dance', Object.keys(Visualizer.danceTypes))

    updateDanceFolder = (value, obj) =>
      updateFolder(Visualizer.danceTypes, danceFolder, @choreographyRoutine.danceParams, value, obj)
    danceController.onChange updateDanceFolder
    updateDanceFolder danceController.initialValue

    [danceMaterialController, danceMaterialFolder] = setupFolder('Dance material paramaters', 'danceMaterial',
      Object.keys(Visualizer.danceMaterialTypes))

    updateDanceMaterialFolder = (value, obj) =>
      updateFolder(Visualizer.danceMaterialTypes, danceMaterialFolder, @choreographyRoutine.danceMaterialParams, value,
        obj)
    danceMaterialController.onChange updateDanceMaterialFolder
    updateDanceMaterialFolder danceMaterialController.initialValue

    idController.onChange (value) =>
      idDancer = @viewer.getDancer(value)
      if idDancer?
        @choreographyRoutine.updateDancer idDancer
        for controller in gui.__controllers
          controller.updateDisplay()

        updateDancerFolder(@choreographyRoutine.dancer, idDancer)
        updateDanceMaterialFolder(@choreographyRoutine.danceMaterial, idDancer.danceMaterial)
        updateDanceFolder(@choreographyRoutine.dance, idDancer.dance)

    gui.add(@choreographyRoutine, 'preview')
    gui.add(@choreographyRoutine, 'add')
    gui.add(@choreographyRoutine, 'insertBeat')
    gui.add(@choreographyRoutine, 'playNext')
    gui.add(@choreographyRoutine, 'reset')

    @containerTop = $ "<div>",
      class: "half-height"

    @container.append @containerTop

    @setupPopup()
    @setupQueueView()
    @setupRoutinesView()
    @setupAudioPlayer()


  setupPopup: () ->
    @viewerButton = $ "<a href='#'>Open Viewer</a>"
    @viewerButton.click (e) =>
      e.preventDefault()
      @domain = window.location.protocol + '//' + window.location.host
      popupURL = @domain + location.pathname + 'viewer.html'
      @popup = window.open(popupURL, 'myWindow')

      # We have to delay catching the window up because it has to load first.
      sendBeats = () =>
        routineBeat = @choreographyRoutine.routineBeat
        @choreographyRoutine.routineBeat = -1
        while @choreographyRoutine.routineBeat < routineBeat
          @choreographyRoutine.playNext()
      setTimeout sendBeats, 100

    @containerTop.append(@viewerButton)

  setupQueueView: () ->
    @queueView = new QueueView(@choreographyRoutine)
    @queueView.createView(@containerTop)

  setupRoutinesView: () ->
    @routinesView = new RoutinesView(@choreographyRoutine, @routinesController)
    @routinesView.createView(@container)

    @routinesView.updateRoutines () =>
      @routinesView.onSelect(1)
  
  setupAudioPlayer: () ->
    bottomBar = $ "<div>",
      class: "bottom-bar"

    @audioView = new AudioView()

    onMic = () =>
      @player.createLiveInput()

    @audioView.createView bottomBar, onMic, @onUrl 
    
    # TODO: Technically, container should contain this.
    $('body').append bottomBar
    @player.setPlayer @audioView.audioPlayer

  updateText: () ->
    if @queueView?
      @queueView.updateText(@choreographyRoutine.routineBeat, @choreographyRoutine.routine)
