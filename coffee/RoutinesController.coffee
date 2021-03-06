require './RoutinesService.coffee'

class window.RoutinesController
  constructor: () ->
    @routines = []
    @routinesService = new RoutinesService()

  getRoutine: (id, next) ->
    # load from service or from @routines
    if @routines[id]?.data != ""
      next @routines[id]
      return

    @routinesService.getRoutine id, (routine) =>
      if !@routines[id]?
        @routines[id] = routine
      else
        @routines[id].data = JSON.parse(routine.data)

      next(@routines[id])

  refreshRoutines: (next) ->
    # get routines from server and cache sans data
    @routinesService.getRoutines (data) =>
      for routine in data
        if @routines[routine.id]?
          @routines[routine.id] = routine.name
        else
          @routines[routine.id] = routine

      if next? then next(@routines)

  pushRoutine: (name, data, next) ->
    routine =
      name: name
      data: JSON.stringify data
    @routinesService.createRoutine routine, () =>
      @refreshRoutines()
      next()