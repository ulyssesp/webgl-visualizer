class window.ChoreographyRoutine
  constructor: (@visualizer, @routinesController) ->
    @id = 0
    @dancer = "CubeDancer"
    @dance = "ScaleDance"
    @danceMaterial = "ColorDanceMaterial"
    @dancerParams = {}
    @danceParams = {}
    @danceMaterialParams = {}

    @reset()
    @routine = [[]]
      #[
        #{ id: -1 },
        #{
          #id: 2
          #dancer:
            #type: 'CubeDancer'
          #dance:
            #type: 'PositionDance'
            #params:
              #smoothingFactor: 0.5
              #direction: [0, 4.0, 0]
          #danceMaterial:
            #type: 'ColorDanceMaterial'
            #params:
              #smoothingFactor: 0.5
        #},
        #{
          #id: 0
          #dancer:
            #type: 'PointCloudDancer'
          #dance:
            #type: 'RotateDance'
            #params:
              #axis: [-1, -1, 0]
          #danceMaterial:
            #type: 'ColorDanceMaterial'
            #params:
              #smoothingFactor: 0.5
              #minL: 0.0
        #},
        #{
          #id: 1
          #dancer:
            #type: 'PointCloudDancer'
          #dance:
            #type: 'RotateDance'
            #params:
              #axis: [0, 1, 1]
              #speed: 0.5
          #danceMaterial:
            #type: 'ColorDanceMaterial'
            #params:
              #smoothingFactor: 0.5
              #minL: 0.0
        #}
      #],
      #[
        #{
          #id: 2
          #dancer:
            #type: 'SphereDancer'
            #params:
              #position: [0.5, 0, 0.5]
        #},
        #{
          #id: 3
          #dancer:
            #type: 'SphereDancer'
            #params:
              #position: [0.5, 0, -0.5]
          #dance:
            #type: 'ScaleDance'
            #params:
              #smoothingFactor: 0.5
          #danceMaterial:
            #type: 'ColorDanceMaterial'
            #params:
              #smoothingFactor: 0.5
              #wireframe: true
        #},
        #{
          #id: 4
          #dancer:
            #type: 'SphereDancer'
            #params:
              #position: [-0.5, 0, 0.5]
          #dance:
            #type: 'ScaleDance'
            #params:
              #smoothingFactor: 0.5
          #danceMaterial:
            #type: 'ColorDanceMaterial'
            #params:
              #smoothingFactor: 0.5
              #wireframe: true
        #},
        #{
          #id: 5
          #dancer:
            #type: 'SphereDancer'
            #params:
              #position: [-0.5, 0, -0.5]
          #dance:
            #type: 'PositionDance'
            #params:
              #smoothingFactor: 0.5
          #danceMaterial:
            #type: 'ColorDanceMaterial'
            #params:
              #smoothingFactor: 0.5
              #wireframe: true
        #},
      #]
    #]

#    @updateText()

  # Individual moment methods

  preview: () ->
    @visualizer.receiveChoreography false,
      id: @id
      dancer:
        type: @dancer
        params: @dancerParams
      dance:
        type: @dance
        params: @danceParams
      danceMaterial:
        type: @danceMaterial
        params: @danceMaterialParams

  add: () ->
    moment = 
      id: @id
      dancer:
        type: @dancer
        params: @dancerParams
      dance:
        type: @dance
        params: @danceParams
      danceMaterial:
        type: @danceMaterial
        params: @danceMaterialParams

    @routineMoment.push moment
    @visualizer.receiveChoreography true, moment
    @updateText()

  insertBeat: () ->
    @routineMoment = []
    @routine.splice(++@routineBeat, 0, @routineMoment)
    @updateText()

  playNext: () ->
    if @routineBeat >= @routine.length - 1
      @routineBeat = -1

    @routineMoment = @routine[++@routineBeat]
    for change in @routineMoment
      @visualizer.receiveChoreography true, change

    @updateText()

  updateDancer: (dancer) ->
    @dancer = dancer.constructor.name
    @danceMaterial = dancer.danceMaterial.constructor.name
    @dance = dancer.dance.constructor.name


  # Entire routine methods

  queueRoutine: (routineData) ->
    Array::push.apply @routine, routineData
    @updateText()

  createRoutine: (name, next) ->
    @visualizer.routinesController.pushRoutine name, @routine, () =>
      next()

  reset: () ->
    @routine = []
    @routineMoment = []
    @routineBeat = -1
    @visualizer.receiveChoreography(true, { id: -1 })
    @updateText()

  updateText: () ->
    @visualizer.interface.updateText()
