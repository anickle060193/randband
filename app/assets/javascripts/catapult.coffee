App.pageReady "static_pages", "catapult", ->
  # commonly used modules
  Engine = Matter.Engine
  Render = Matter.Render
  Runner = Matter.Runner
  Composites = Matter.Composites
  Constraint = Matter.Constraint
  MouseConstraint = Matter.MouseConstraint
  Mouse = Matter.Mouse
  World = Matter.World
  Bodies = Matter.Bodies

  # create engine
  engine = Engine.create()
  world = engine.world

  # create renderer
  render = Render.create( {
    element: document.body,
    engine: engine,
    options: {
      width: Math.min( document.documentElement.clientWidth, 800 ),
      height: Math.min( document.documentElement.clientHeight, 600 ),
      showAngleIndicator: true,
      showCollisions: true,
      showVelocity: true
    }
  } )

  Render.run(render)

  # create runner
  runner = Runner.create()
  Runner.run(runner, engine)

  # add bodies
  stack = Composites.stack( 250, 255, 1, 1, 0, 0, ( x, y ) ->
    Bodies.rectangle( x, y, 30, 30 ) )

  catapult = Bodies.rectangle( 400, 520, 320, 20 )

  World.add( world, [
    stack,
    catapult,
    Bodies.rectangle( 400, 600, 800, 50.5, { isStatic: true } ),
    Bodies.rectangle( 250, 555, 20, 50, { isStatic: true } ),
    Bodies.circle( 560, 100, 50, { density: 10 } ),
    Constraint.create( { bodyA: catapult, pointB: { x: 390, y: 580 } } ),
    Constraint.create( { bodyA: catapult, pointB: { x: 410, y: 580 } } )
  ] )

  # fit the render viewport to the scene
  Render.lookAt( render, {
    min: { x: 0, y: 0 },
    max: { x: 800, y: 600 }
  } )