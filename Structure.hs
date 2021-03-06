import Rendering
import Cube
import Life
import Omniscient

import Graphics.Rendering.OpenGL
import Graphics.UI.GLUT
import Data.IORef
import Control.Applicative

main :: IO ()
main = do 
  (progname, _) <- getArgsAndInitialize
  createWindow "CGOL"
  initialDisplayMode $= [DoubleBuffered, WithDepthBuffer]
  depthFunc $= Just Less
  angle <- newIORef (Vector3 0.0 90.0 0.0)
  universe <- newIORef acorn
  rotatingCube angle universe
  mainLoop

rotatingCube angle universe = do
--  repeatedly 10 $ do
--    modifyIORef angle $ increase 0.1
--    forceDisplay
  repeatedly 100 $ do
    modifyIORef universe $ nextGeneration
    forceDisplay
  displayCallback $= display angle universe

display angle universe = do
  clear [ ColorBuffer, DepthBuffer ]
  rotationAngle <- get angle
  generation <- get universe
  preservingMatrix $ do 
    scale 0.2 0.2 (0.2::GLfloat)
    rotateVector rotationAngle
    follow generation
    renderUniverse generation
  flush

follow generation = do
  --translate (interestingPoint location)
  lookAt
    (interestingPoint generation)
    (Vertex3 0.0 0.0 0.0)
    (Vector3 0.0 1.0 0.0)
